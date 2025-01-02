import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lcled/src/advertisement.dart';
import 'package:lcled/src/wled_controller.dart';
import 'package:lcled/src/color_picker.dart';
// import 'package:lcled/src/database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Các loại thiết bị
class DeviceType {
  static const int bulb = 1;
  static const int rgb = 2;
  static const int door = 3;
  static const int stair = 4;

  // Hàm chuyển từ `int` sang tên kiểu thiết bị (String)
  static String typeToString(int type) {
    switch (type) {
      case bulb:
        return "Bulb";
      case rgb:
        return "RGB";
      case door:
        return "Door";
      case stair:
        return "Stair";
      default:
        return "Unknown";
    }
  }

  // Hàm chuyển từ tên kiểu thiết bị (String) sang `int`
  static int fromString(String type) {
    switch (type.toLowerCase()) {
      case "bulb":
        return bulb;
      case "rgb":
        return rgb;
      case "door":
        return door;
      case "stair":
        return stair;
      default:
        throw ArgumentError("Invalid device type: $type");
    }
  }
}

class DeviceWledScan {
  String ip;
  String name;

  DeviceWledScan({required this.ip, required this.name});
}

class WifInfor {
  String name;
  String pass;

  WifInfor({required this.name, required this.pass});
}

class Device {
  final int id;
  final String ip;
  final String name;
  final int type;
  final int state;

  Device({
    required this.id,
    required this.ip,
    required this.name,
    required this.type,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'ip' : ip,
      'name': name,
      'type': type,
      'state': state,
      // ...
    };
  }

  factory
  Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      ip: map['ip'],
      name: map['name'],
      type: map['type'],
      state: map['state'],
      // ...
    );
  }
  bool controlOnOff(){
    print("controlOnOff $name");
    // Gửi bản tin điều khiển MQTT
    return true;
  }
  void openCloseDoor() {
    if (type == DeviceType.door) {
      print('$name đã mở/đóng cửa');
    }
  }
  Future<bool> _sendCommand(String command) async {
    try {
      print('[$name]:[send command]: $command');
      final response = await http.get(Uri.parse('http://$ip/$command'));
      if (response.statusCode == 200) {
        return true; // Lệnh thành công
      } else {
        print('Failed to execute command $command on $ip');
        return false; // Lệnh thất bại
      }
    } catch (e) {
      print('Error sending command $command to $ip: $e');
      return false; // Lỗi kết nối
    }
  }
}

class StaircaseLedControlPage extends StatefulWidget {
  final Device device; // Truyền vào đối tượng Device
  // Constructor của GarageDoorPage
  const StaircaseLedControlPage({super.key, 
    required this.device, // Yêu cầu đối tượng device khi tạo GarageDoorPage
  });
  @override
  _StaircaseLedControlPage createState() => _StaircaseLedControlPage();
}

class _StaircaseLedControlPage extends State<StaircaseLedControlPage> {
  double _briValue = 0;
  double _timeValue = 0;
  double _fireValue = 0;
  String _selectedValue = 'Chọn hiệu ứng';
  Color currentColor = Color(0xff07ff00);
  List<String> effectModes = [];
  late Device device;
  bool isPowerOn = false; // Trạng thái bật/tắt

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    device = widget.device; // Gán giá trị từ widget cha
    fetchWLEDState();
    Future.delayed(Duration(seconds: 2), () {
      fetchEffects();
    });
  }

  void stopPolling() {
    // Dừng polling
    _timer?.cancel();
  }

  Future<void> fetchWLEDState() async {
    try {
      String jsonResponse = await  sendGetRequest(device.ip, "state");
      Map<String, dynamic> jsonData = jsonDecode(jsonResponse);
      LightingConfig Wled_infor = LightingConfig.fromJson(jsonData);
      setState(() {
        isPowerOn = Wled_infor.on;
        _briValue = Wled_infor.bri.toDouble();
        _timeValue = Wled_infor.seg[0].sx.toDouble();
        _fireValue = Wled_infor.seg[0].ix.toDouble();

        List<int> firstColor = Wled_infor.seg[0].col[0];
        currentColor = Color((255 << 24) | (firstColor[0] << 16) | (firstColor[1] << 8) | firstColor[2]);
        print("currentColor:$currentColor");
      });
    } catch (e) {
      print("Error fetching WLED state: $e");
    }
  }

  // Lấy dữ liệu hiệu ứng từ API
  Future<void> fetchEffects() async {
    try {
      List<String> effects = await wled_Get_eff(widget.device);  // Lấy dữ liệu hiệu ứng từ API
      setState(() {
        effectModes = effects;  // Cập nhật danh sách hiệu ứng
        if (effectModes.isNotEmpty) {
          _selectedValue = effectModes[0];  // Nếu danh sách không rỗng, chọn hiệu ứng đầu tiên làm giá trị mặc định
        }
      });
    } catch (e) {
      print('Lỗi khi tải hiệu ứng: $e');
    }
  }

  @override
  void dispose() {
    stopPolling(); // Dừng khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        backgroundColor: Color.fromARGB(255, 98, 174, 250),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 98, 174, 250), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isPowerOn ? Colors.green : Colors.grey[800], // Thay đổi màu theo trạng thái
                    shape: BoxShape.circle, // Hình dạng: Circle hoặc BoxShape.rectangle
                  ),
                  padding: const EdgeInsets.all(2), // Khoảng cách bên trong
                  child: IconButton(
                    icon: const Icon(Icons.power_settings_new, color: Colors.white),
                    onPressed: () async {
                      Device device = widget.device;
                      await Wled_Togglele(device);
                      setState(() {
                        isPowerOn = !isPowerOn; // Đảo trạng thái
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Màu nền
                    shape: BoxShape.circle, // Hình dạng: Circle hoặc BoxShape.rectangle
                  ),
                  padding: const EdgeInsets.all(2), // Khoảng cách bên trong
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StairSettingPage(device: device), // Trang điều khiển cầu thang
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            CircleColorPicker(
              initialColor: currentColor,
              thumbRadius: 10,
              colorListener: (int value) {
                // Được gọi khi người dùng thay đổi màu
                setState(() {
                  currentColor = Color(value);
                  // Cập nhật màu khi người dùng đang kéo
                });
              },
              onChangeEnd: () {
                // Được gọi khi người dùng thả tay ra
                setState(() {
                  print(currentColor);
                  // Gửi dữ liệu khi người dùng ngừng kéo
                  List<List<int>> scol = [
                    [currentColor.red, currentColor.green, currentColor.blue], // Màu đỏ
                    [0, 255, 0], // Màu xanh lá
                    [0, 0, 255], // Màu xanh dương
                  ];
                  Wled_Set_color_all(device, scol);
                });
              },
            ),
            const SizedBox(height: 30),
            // Thanh trượt điều chỉnh màu đỏ
            _buildSliderWithBackground(
              icon: Icons.sunny, // Icon sunny
              value: _briValue,
              onChanged: (value) {
                // Đây là sự kiện thay đổi giá trị khi người dùng kéo slider, nhưng không cần xử lý gì ở đây.
                setState(() {
                  _briValue = value;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _briValue = value;
                  // Chỉ gọi hàm khi người dùng nhả tay ra
                  Wled_Set_bri_all(device, _briValue);
                });
              },
            ),
            const SizedBox(height: 10), // Khoảng cách giữa các sliders
            _buildSliderWithBackground(
              icon: Icons.timer, // Icon đồng hồ
              value: _timeValue,
              onChanged: (value) {
                setState(() {
                  _timeValue = value;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _timeValue = value;
                  // Chỉ gọi hàm khi người dùng nhả tay ra
                  // Wled_Set_bri_all(device, _briValue);
                });
              },
            ),
            const SizedBox(height: 10), // Khoảng cách giữa các sliders
            _buildSliderWithBackground(
              icon: Icons.whatshot, // Icon lửa
              value: _fireValue,
              onChanged: (value) {
                setState(() {
                  _fireValue = value;
                });
              },
              onChangeEnd: (value) {
                setState(() {
                  _fireValue = value;
                  // Chỉ gọi hàm khi người dùng nhả tay ra
                  // Wled_Set_bri_all(device, _briValue);
                });
              },
            ),
            const SizedBox(height: 10), // Khoảng cách giữa các sliders
            // Thêm DropdownButton sau slider
            Card( // Đặt ListTile trong một Card để tạo hiệu ứng viền
              margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 0.0), // Căn chỉnh và margin hợp lý
              elevation: 1, // Đặt bóng đổ cho card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Góc bo tròn cho card
              ),
              child: ListTile(
                // contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding cho ListTile
                title: Text(
                  _selectedValue,
                  style: TextStyle(
                    fontSize: 18, // Kích thước chữ tiêu đề lớn hơn
                    fontWeight: FontWeight.bold, // Chữ đậm
                  ),
                ),
                // leading: Icon(
                //   Icons.wifi,
                //   size: 32, // Kích thước icon lớn hơn để dễ nhìn
                //   color: Colors.blueAccent, // Màu sắc icon
                // ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    builder: (context) {
                      return SingleChildScrollView( // Dùng SingleChildScrollView để có thể cuộn
                        child: Container(
                          width: double.infinity,  // Chiều rộng tự động theo màn hình
                          margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal),
                          child: Column(
                            children: effectModes.map<Widget>((String effect) {
                              return ListTile(
                                title: Text(
                                  effect,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedValue = effect;  // Cập nhật giá trị khi người dùng chọn hiệu ứng mới
                                    int selectedIndex = effectModes.indexOf(_selectedValue);
                                    Wled_Set_eff_all(device, selectedIndex);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     showModalBottomSheet(
            //       context: context,
            //       shape: const RoundedRectangleBorder(
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(25.0),
            //           topRight: Radius.circular(25.0),
            //         ),
            //       ),
            //       builder: (context) {
            //         return SizedBox(
            //           // height: 300, // Điều chỉnh chiều cao của Bottom Sheet (có thể lớn hơn nếu cần)
            //           child: SingleChildScrollView(  // Dùng SingleChildScrollView để có thể cuộn
            //             child: Container(
            //               width: 1000,  // Đặt chiều rộng cho Container
            //               height: 500, // Đặt chiều cao cho Container (hoặc không cần nếu không cần chiều cao cố định)
            //               margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal),
            //               child: Column(
            //                 // crossAxisAlignment: CrossAxisAlignment.start,
            //                 // mainAxisSize: MainAxisSize.min,
            //                 children: effectModes.map<Widget>((String effect) {
            //                   return ListTile(
            //                     title: Text(
            //                       effect,
            //                       style: TextStyle(
            //                         fontSize: 20,
            //                         fontWeight: FontWeight.w600,
            //                       ),
            //                     ),
            //                     trailing: Checkbox(
            //                       value: _selectedValue == effect,  // Checkbox sẽ được đánh dấu nếu _selectedValue == effect
            //                       onChanged: (bool? newValue) {
            //                         setState(() {
            //                           if (newValue != null) {
            //                             if (newValue) {
            //                               _selectedValue = effect;  // Chọn hiệu ứng khi checkbox được tích
            //                             } else {
            //                               _selectedValue = '';  // Bỏ chọn khi checkbox không được tích
            //                             }
            //                             int selectedIndex = effectModes.indexOf(_selectedValue);
            //                             Wled_Set_eff_all(device, selectedIndex);
            //                           }
            //                         });
            //                       },
            //                     ),
            //                     onTap: () {
            //                       // Khi người dùng nhấn vào một mục, cũng có thể thay đổi trạng thái checkbox
            //                       setState(() {
            //                         if (_selectedValue == effect) {
            //                           _selectedValue = '';  // Nếu đã chọn, bỏ chọn khi nhấn lại
            //                         } else {
            //                           _selectedValue = effect;  // Chọn hiệu ứng mới
            //                         }
            //                         int selectedIndex = effectModes.indexOf(_selectedValue);
            //                         Wled_Set_eff_all(device, selectedIndex);
            //                       });
            //                     },
            //                   );
            //                 }).toList(),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            //   child: Text(_selectedValue),  // Hiển thị 'Chọn hiệu ứng' nếu _selectedValue là null
            // ),
          ],
        ),
      ),
      ),
    );
  }
  Widget _buildSliderWithBackground({
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd, // Thêm tham số cho onChangeEnd
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 117, 93, 93), // Nền bao quanh (màu xám đậm)
        borderRadius: BorderRadius.circular(16), // Viền bo tròn
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[300], // Màu của icon
            size: 32,
          ),
          Expanded(
            child: Slider(
              value: value,
              min: 0,
              max: 255,
              divisions: 255,
              activeColor: Colors.white, // Màu phần đã chọn
              inactiveColor: Colors.grey, // Màu phần chưa chọn
              onChanged: onChanged, // Xử lý thay đổi giá trị ngay khi người dùng kéo slider
              onChangeEnd: onChangeEnd, // Xử lý khi người dùng nhả tay khỏi slider
            ),
          ),
        ],
      ),
    );
  }
}


class GarageDoorPage extends StatefulWidget {
  final Device device; // Truyền vào đối tượng Device
  // Constructor của GarageDoorPage
  const GarageDoorPage({super.key, 
    required this.device, // Yêu cầu đối tượng device khi tạo GarageDoorPage
  });
  @override
  _GarageDoorPageState createState() => _GarageDoorPageState();
}

class _GarageDoorPageState extends State<GarageDoorPage>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Device device; // Khai báo biến device trong State

  @override
  void initState() {
    super.initState();
    device = widget.device; // Lấy đối tượng device từ widget và gán cho biến device
    _controller = AnimationController(
      duration: const Duration(seconds: 51),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDoor() => _controller.forward(); // Kéo cửa lên (đóng cửa)
  void _closeDoor() => _controller.reverse(); // Kéo cửa xuống (mở cửa)
  void _stopDoor() => _controller.stop(); // Dừng cửa lại

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Door Control'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/khung.png',  // Đường dẫn ảnh tường
              fit: BoxFit.cover, 
            ),
          ),
          // Hình ảnh cửa cuốn (Phần cửa cuốn di chuyển và mờ dần)
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -1.9, // Vị trí ngang cố định
                    226 - MediaQuery.of(context).size.height * 0.35 * _animation.value, // Cửa cuốn di chuyển lên (đóng cửa)
                  ),
                  child: Image.asset(
                    'lib/assets/cua.png', // Đường dẫn ảnh cửa cuốn
                    width: MediaQuery.of(context).size.width * 0.79,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
              // Ảnh Khung trên (Khung trên cửa cuốn)
          Positioned(
            top: 0, // Đặt khung trên ở trên cùng
            left: 0,
            right: 5,
            child: Image.asset(
              'lib/assets/khung_up.png', // Đường dẫn ảnh khung trên
              fit: BoxFit.cover,
              height: 233, // Điều chỉnh chiều cao khung trên
              width: 10,
            ),
          ),
          // Các nút điều khiển
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:() {
                    _openDoor();
                    device._sendCommand("state?state=open");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 151, 165, 152)),
                  child: Text('Mở'),
                ),
                ElevatedButton(
                  onPressed:() {
                    _stopDoor();
                    device._sendCommand("state?state=stop");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Dừng'),
                ),
                ElevatedButton(
                  onPressed:() {
                    _closeDoor();
                    device._sendCommand("state?state=close");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Đóng'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LEDControlPage extends StatefulWidget {
  final Device device; // Truyền vào đối tượng Device
  // Constructor của GarageDoorPage
  const LEDControlPage({super.key, 
    required this.device, // Yêu cầu đối tượng device khi tạo GarageDoorPage
  });
  @override
  _LEDControlPageState createState() => _LEDControlPageState();
}

class _LEDControlPageState extends State<LEDControlPage> {
  Color _ledColor = Colors.red;
  double _brightness = 1.0;
  bool _isBlinking = false;
  bool _isFlashing = false;

  Timer? _blinkTimer;

  // Hàm mở ColorPicker khi nhấn vào màu LED
  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chọn Màu LED", style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _ledColor,
              onColorChanged: (color) {
                setState(() {
                  _ledColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Bắt đầu và dừng chế độ Blink
  void _toggleBlink() {
    setState(() {
      _isBlinking = !_isBlinking;
    });

    if (_isBlinking) {
      // Blink LED với khoảng thời gian đổi màu
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _ledColor = _ledColor == Colors.red ? Colors.green : Colors.red; // Chuyển màu khi Blink
        });
      });
    } else {
      // Dừng Blink
      _blinkTimer?.cancel();
    }
  }

  // Bắt đầu và dừng chế độ Flash
  void _toggleFlash() {
    setState(() {
      _isFlashing = !_isFlashing;
    });

    if (_isFlashing) {
      // Flash LED (Tắt sáng)
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _ledColor = _ledColor == Colors.red ? Colors.transparent : Colors.red;
        });
      });
    } else {
      // Dừng Flash
      _blinkTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LED RGB Control'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Nhấn vào màu để chọn màu LED
            GestureDetector(
              onTap: _pickColor,  // Mở hộp thoại chọn màu khi nhấn vào màu
              child: AnimatedContainer(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _ledColor.withOpacity(_brightness), // Màu LED với độ sáng
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 5),
                  ],
                ),
                duration: const Duration(milliseconds: 300),
              ),
            ),
            const SizedBox(height: 20),

            // Slider để điều chỉnh độ sáng LED
            Text(
              'Độ sáng: ${((_brightness * 100).toInt())}%',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            Slider(
              value: _brightness,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(_brightness * 100).toInt()}%',
              onChanged: (double value) {
                setState(() {
                  _brightness = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Nút chọn chế độ Blink
            ElevatedButton(
              onPressed: _toggleBlink,
              style: ElevatedButton.styleFrom(
                // primary: _isBlinking ? Colors.red : Colors.blue,
                // onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                _isBlinking ? 'Dừng Blink' : 'Bắt đầu Blink',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Nút chọn chế độ Flash
            ElevatedButton(
              onPressed: _toggleFlash,
              style: ElevatedButton.styleFrom(
                // primary: _isFlashing ? Colors.green : Colors.orange,
                // onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                _isFlashing ? 'Dừng Flash' : 'Bắt đầu Flash',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class StairSettingPage extends StatefulWidget {
  final Device device; // Truyền vào đối tượng Device
  // Constructor của GarageDoorPage
  const StairSettingPage({super.key, 
    required this.device, // Yêu cầu đối tượng device khi tạo GarageDoorPage
  });

  @override
  _StairSettingPageState createState() => _StairSettingPageState();
}

class _StairSettingPageState extends State<StairSettingPage> {
  late Device device; // Khai báo biến device trong State
  List<StairStep> steps = [];

  @override
  void initState() {
    super.initState();
    device = widget.device; // Lấy đối tượng device từ widget và gán cho biến device
    
    // Gọi hàm fetchSteps sau một thời gian ngắn
    Future.delayed(Duration.zero, () {
      fetchSteps();
    });
  }

  Future<void> fetchSteps() async {
    try {
      // Giả sử đây là nơi bạn gọi API hoặc thao tác với dữ liệu bất đồng bộ
      List<StairStep> _steps = await Wled_get_seg(device);  // Lấy dữ liệu hiệu ứng từ API
      setState(() {
        steps = _steps;  // Cập nhật danh sách hiệu ứng
      });
    } catch (e) {
      print('Lỗi khi tải bậc thang: $e');
    }
  }

  void updateLedCount(int stepIndex, double newLedCount) {
    if (newLedCount > 0) {
      // Cập nhật danh sách LED với số lượng mới
      setState(() {
        steps[stepIndex].SegLen = newLedCount;
      });
    }
  }

  Future<void> _reloadData() async {
    List<StairStep> _steps = await Wled_get_seg(device);  // Lấy dữ liệu hiệu ứng từ API
    setState(() {
      steps = _steps;  // Cập nhật danh sách hiệu ứng
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt LED Cầu thang'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Danh sách các bậc thang
            Expanded(
              child: ListView.builder(
                itemCount: steps.length, // Số bậc thang
                itemBuilder: (context, stepIndex) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Bậc ${stepIndex + 1}'),
                      leading: const Icon(Icons.arrow_upward),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Nút bật/tắt LED trên các bậc
                          // IconButton(
                          //   icon: Icon(
                          //     steps[stepIndex].SegOn
                          //         ? Icons.toggle_on
                          //         : Icons.toggle_off,
                          //   ),
                          //   onPressed: () {
                          //     toggleLed(stepIndex, 0); // Toggle LED trên bậc
                          //     // Set trang thai On off của seg
                          //   },
                          // ),
                          IconButton(
                          icon: Text(
                            'LED = ${steps[stepIndex].SegLen.toInt()}', // Số lượng LED trên bậc
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                          },
                        ),
                        ],
                      ),
                      onTap: () {
                        double newLedCount = steps[stepIndex].SegLen.toDouble(); // Số lượng LED hiện tại
                        // Mở hộp thoại chọn màu cho LED trên bậc
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Nhập số lượng LED cho Bậc ${stepIndex + 1}'),
                              content: TextField(
                                keyboardType: TextInputType.number, // Chỉ nhập số
                                decoration: const InputDecoration(
                                  hintText: 'Nhập số lượng LED',
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    newLedCount = double.tryParse(value) ?? newLedCount;
                                  }
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Đóng hộp thoại
                                  },
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Cập nhật số lượng LED
                                    // updateLedCount(stepIndex, newLedCount);
                                    await Wled_change_segLed(device, stepIndex, newLedCount);
                                    _reloadData();
                                    Navigator.of(context).pop(); // Đóng hộp thoại
                                  },
                                  child: const Text('Xác nhận'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều giữa các phần tử
              children: [
                TextButton(
                  child: Text('Xóa 1 bậc'),
                  onPressed: () async {
                    await Wled_add_seg(device, false);
                    _reloadData();
                  },
                ),
                TextButton(
                  child: Text('Thêm 1 bậc'),
                  onPressed: () async {
                    await Wled_add_seg(device, true);
                    _reloadData();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class WLEDControlPage extends StatefulWidget {
  final Device device; // Truyền vào đối tượng Device
  // Constructor của GarageDoorPage
  const WLEDControlPage({super.key, 
    required this.device, // Yêu cầu đối tượng device khi tạo GarageDoorPage
  });

  @override
  _WLEDControlPageState createState() => _WLEDControlPageState();
}

class _WLEDControlPageState extends State<WLEDControlPage> {
  Color _ledColor = Colors.red;
  double _brightness = 1.0;
  bool _isBlinking = false;
  late Device device;

  @override
  void initState() {
    super.initState();
    device = widget.device; // Lấy đối tượng device từ widget và gán cho biến device
  }

  // Hàm gửi yêu cầu API đến WLED để thay đổi màu LED
  Future<void> _setColor(Color color) async {
    // int r = (color.red / 255 * 255).toInt();
    // int g = (color.green / 255 * 255).toInt();
    // int b = (color.blue / 255 * 255).toInt();

    // String url = 'http://${widget.device.ip}/win&rgb=$r,$g,$b';
    try {
      // await http.get(Uri.parse(url)); // Gửi yêu cầu đến WLED
      // dbHelper.Wled_Change_color(device, color);
    } catch (e) {
      print("Error setting color: $e");
    }
  }

  // Hàm điều chỉnh độ sáng LED trên WLED
  Future<void> _setBrightness(double brightness) async {
    // int brightnessValue = (brightness * 255).toInt();
    // String url = 'http://${widget.device.ip}/win&bri=$brightnessValue';
    try {
      // await http.get(Uri.parse(url)); // Gửi yêu cầu đến WLED
      // dbHelper.Wled_Brightness(device, brightnessValue);
    } catch (e) {
      print("Error setting brightness: $e");
    }
  }

  // Hàm chọn màu khi nhấn vào vòng tròn màu
  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chọn Màu LED", style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _ledColor,
              onColorChanged: (color) {
                setState(() {
                  _ledColor = color;
                });
                _setColor(_ledColor);
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm bật/tắt chế độ Blink
  Future<void> _toggleBlink() async {
    setState(() {
      _isBlinking = !_isBlinking;
    });

    if (_isBlinking) {
      // Blink LED với khoảng thời gian đổi màu
      Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        _ledColor = _ledColor == Colors.red ? Colors.green : Colors.red;
        await _setColor(_ledColor);
      });
    } else {
      // Dừng Blink
      _setColor(_ledColor); // Đặt lại màu ban đầu
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WLED RGB Control'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Vòng tròn màu để chọn màu LED
            GestureDetector(
              onTap: _pickColor,  // Mở hộp thoại chọn màu khi nhấn vào vòng tròn
              child: AnimatedContainer(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _ledColor.withOpacity(_brightness), // Màu LED với độ sáng
                  shape: BoxShape.circle,  // Hình tròn
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, spreadRadius: 1, blurRadius: 5),
                  ],
                ),
                duration: const Duration(milliseconds: 300),
              ),
            ),
            const SizedBox(height: 20),

            // Slider để điều chỉnh độ sáng LED
            Text(
              'Độ sáng: ${((_brightness * 100).toInt())}%',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            Slider(
              value: _brightness,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(_brightness * 100).toInt()}%',
              onChanged: (double value) {
                setState(() {
                  _brightness = value;
                });
                _setBrightness(_brightness);
              },
            ),
            const SizedBox(height: 20),

            // Nút chọn chế độ Blink
            ElevatedButton(
              onPressed: _toggleBlink,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                _isBlinking ? 'Dừng Blink' : 'Bắt đầu Blink',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}