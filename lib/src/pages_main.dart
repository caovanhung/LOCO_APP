//
//
//Chứa các trong chính của ứng dụng
//
//
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'package:lcled/src/database.dart';
import 'package:lcled/models/devices.dart';
import 'package:lcled/src/wled_controller.dart';
// import 'package:lcled/src/wled_controller.dart';
import 'package:multicast_dns/multicast_dns.dart';
// import 'package:http/http.dart' as http;
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<String> deviceTypes = <String>['On/Off', 'Led RGB', 'Cửa cuốn', 'Cầu thang'];
// enum DeviceType {bulb, rgb, door, stair}

class Page_AddDevice extends StatelessWidget {
  const Page_AddDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thêm thiết bị',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 115, 118, 121), // AppBar màu tối
      ),
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           Card( // Đặt ListTile trong một Card để tạo hiệu ứng viền
              margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0), // Căn chỉnh và margin hợp lý
              elevation: 1, // Đặt bóng đổ cho card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Góc bo tròn cho card
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding cho ListTile
                title: Text(
                  'Thiết bị Wifi',
                  style: TextStyle(
                    fontSize: 18, // Kích thước chữ tiêu đề lớn hơn
                    fontWeight: FontWeight.bold, // Chữ đậm
                  ),
                ),
                leading: Icon(
                  Icons.wifi,
                  size: 32, // Kích thước icon lớn hơn để dễ nhìn
                  color: Colors.blueAccent, // Màu sắc icon
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page_AddDevice_Wifi()),
                  );
                }
              ),
            ),
            const SizedBox(height: 20),
            Card( // Đặt ListTile trong một Card để tạo hiệu ứng viền
              margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0), // Căn chỉnh và margin hợp lý
              elevation: 1, // Đặt bóng đổ cho card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Góc bo tròn cho card
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding cho ListTile
                title: Text(
                  'Thiết bị Bluetooth',
                  style: TextStyle(
                    fontSize: 18, // Kích thước chữ tiêu đề lớn hơn
                    fontWeight: FontWeight.bold, // Chữ đậm
                  ),
                ),
                leading: Icon(
                  Icons.bluetooth,
                  size: 32, // Kích thước icon lớn hơn để dễ nhìn
                  color: Colors.blueAccent, // Màu sắc icon
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page_AddDevice_Wifi()),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page_AddScene extends StatelessWidget {
  const Page_AddScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm cảnh'),
      ),
      body: Center(
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Text('Go back!'),
        // ),
      ),
    );
  }
}

class Page_AddHome extends StatelessWidget {
  const Page_AddHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm nhà mới'),
      ),
      body: Center(
        // child: ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Text('Go back!'),
        // ),
      ),
    );
  }
}

class MyApps extends StatefulWidget {
  const MyApps({Key? key}) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApps> {
  final flutterNsd = FlutterNsd();
  final services = <NsdServiceInfo>[];
  bool initialStart = true;
  bool _scanning = false;

  _MyAppState();

  @override
  void initState() {
    super.initState();

    // Try one restart if initial start fails, which happens on hot-restart of
    // the flutter app.
    flutterNsd.stream.listen(
      (NsdServiceInfo service) {
        setState(() {
          services.add(service);
        });
      },
      onError: (e) async {
        if (e is NsdError) {
          if (e.errorCode == NsdErrorCode.startDiscoveryFailed &&
              initialStart) {
            await stopDiscovery();
          } else if (e.errorCode == NsdErrorCode.discoveryStopped &&
              initialStart) {
            initialStart = false;
            await startDiscovery();
          }
        }
      },
    );
  }

  Future<void> startDiscovery() async {
    if (_scanning) return;

    setState(() {
      services.clear();
      _scanning = true;
    });
    await flutterNsd.discoverServices('_http._tcp.');
  }

  Future<void> stopDiscovery() async {
    if (!_scanning) return;

    setState(() {
      services.clear();
      _scanning = false;
    });
    flutterNsd.stopDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NSD Example'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Start'),
                  onPressed: () async => startDiscovery(),
                ),
                ElevatedButton(
                  child: const Text('Stop'),
                  onPressed: () async => stopDiscovery(),
                ),
              ],
            ),
            Expanded(
              child: _buildMainWidget(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    if (services.isEmpty && _scanning) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (services.isEmpty && !_scanning) {
      return const SizedBox.shrink();
    } else {
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text(services[index].hostname ?? 'Invalid service name'),
        ),
        itemCount: services.length,
      );
    }
  }
}

class WifiSetupPage extends StatefulWidget {
  final WifInfor wifInfor;

  WifiSetupPage({
    required this.wifInfor
  });
  @override
  _WifiSetupPage createState() => _WifiSetupPage();
}

class _WifiSetupPage extends State<WifiSetupPage> {

  bool isWifiConfigured = false; // Trạng thái để kiểm soát nút "Đã thấy"
  Timer? checkTimer; // Timer để kiểm tra liên tục
  late WifInfor wifInfor;

  Future<void> checkWifiConfiguration() async {
    try {
      // Thử ping đến google.com
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isWifiConfigured = true; // Có Internet, cập nhật trạng thái
        });
        print('Internet is available');
      }
    } catch (e) {
      // Không có Internet
      setState(() {
        isWifiConfigured = false;
      });
      print('No internet connection');
    }
  }

    // Hàm kiểm tra liên tục
  void startContinuousCheck() {
    checkTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkWifiConfiguration();
    });
  }

  @override
  void initState() {
    super.initState();
    startContinuousCheck();
    wifInfor = widget.wifInfor;
  }

  void Push_WifiSetup(){
    wled_Wifi_setup(wifInfor);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt WiFi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi,
              size: 80,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 16),
            Text(
              'Vui lòng đảm bảo bạn đã kết nối thiết bị với mạng WiFi "WLED-AP" (mật khẩu: wled1234)"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Nhấn vào nút bên dưới để tiếp tục.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              // onPressed: () {
              //   // Hành động khi nhấn nút "Tiếp tục"
              //   Navigator.pop(context); // Ví dụ: Quay lại màn hình trước
              // },
              onPressed: isWifiConfigured
              ? () {
                  // Hành động khi nhấn nút "Đã thấy"
                  Push_WifiSetup();
                  //Page_AddDevice_Wifi
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page_AddDevice_Wifi()),
                  );
                }
              : null, // Disable nút khi chưa đủ điều kiện
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Đã thấy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WifiInputPage extends StatelessWidget {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final WifInfor wifInfor = WifInfor(name: '',pass: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập thông tin WiFi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên WiFi (SSID)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: ssidController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên WiFi',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Mật khẩu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập mật khẩu WiFi',
              ),
              obscureText: true, // Ẩn mật khẩu
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String ssid = ssidController.text;
                  String password = passwordController.text;

                  wifInfor.name = ssid;
                  wifInfor.pass = password;

                  if (ssid.isEmpty || password.isEmpty) {
                    // Hiển thị cảnh báo nếu thiếu thông tin
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Cảnh báo'),
                        content: Text('Vui lòng nhập đầy đủ thông tin WiFi.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Xử lý logic khi nhập thông tin WiFi
                    print('WiFi SSID: $ssid');
                    print('WiFi Password: $password');
                    // Điều hướng hoặc thực hiện hành động khác//WifiSetupPage
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WifiSetupPage(wifInfor: wifInfor)),
                      );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Tiếp tục',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page_AddDevice_Wifi extends StatefulWidget {
  @override
  _Page_AddDevice_WifiState createState() => _Page_AddDevice_WifiState();
}

class _Page_AddDevice_WifiState extends State<Page_AddDevice_Wifi> {
  List<Device> devices = []; // Danh sách thiết bị
  List<String> deviceOptions = ['LED', 'Cầu thang', 'Cửa cuốn']; // Danh sách thiết bị
  String? selectedDevice; // Lưu trữ thiết bị được chọn

  List<DeviceWledScan> DevciesWifiScan = [];


  void passerDevicesScaned() async {
    String serviceType = '_http._tcp';
    final MDnsClient client = MDnsClient();
    await client.start();

    await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer(serviceType))) {
      print('PTR: ${ptr.toString()}');

      await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(ptr.domainName))) {
        print('SRV target: ${srv.target} port: ${srv.port}');

        await for (final IPAddressResourceRecord ip
            in client.lookup<IPAddressResourceRecord>(
                ResourceRecordQuery.addressIPv4(srv.target))) {
          print('IP: ${ip.address.toString()}');
          if (srv.target == "loco.local"){
            DevciesWifiScan.add(
              DeviceWledScan(
                ip: ip.address.address.toString(),
                name: "Loco LED :😈",
              ),
            );
          }
        }
      }
    }
    client.stop();
    setState(() {});
  }
  

  final flutterNsd = FlutterNsd();
  final services = <NsdServiceInfo>[];
  bool initialStart = true;

  @override
  void initState() {
    super.initState();
    startDiscovery();
  }

  Future<void> startDiscovery() async {
    passerDevicesScaned();
  }

  void handleDeviceSelection(String? device) {
    // Xử lý khi người dùng chọn một thiết bị từ danh sách
    setState(() {
      selectedDevice = device;
    });
    print("Selected device: $device");
  }

  void addDevice_Page_AddDevice_WifiState(Device device){
    dbHelper.addDevice(device);
    setState(() {});
  }

  void showLoginDialog(BuildContext context, Device device) {
    // Text editing controllers để lấy giá trị nhập vào
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Device Selected'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text('Name: ${device.name}\nIP: ${device.ip}'),
            SizedBox(height: 10),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Ẩn ký tự nhập vào
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Đóng dialog
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Xử lý dữ liệu từ các TextField
              String username = usernameController.text;
              String password = passwordController.text;

              // In ra console hoặc xử lý logic khác
              print('Username: $username, Password: $password');

              Navigator.pop(context); // Đóng dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void showLoginDialogHandmade(BuildContext context, String ip, String name, int index) {
    TextEditingController ipController = TextEditingController(text: ip);
    TextEditingController nameController = TextEditingController(text: name);
    String selectedDeviceType = "Loại thiết bị";

    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth * 0.8; // Dialog chiếm 80% chiều rộng màn hình

        return AlertDialog(
          title: const Text('Thông tin thiết bị'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: dialogWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      labelText: 'Ip',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownMenuExample(
                    selectedValue: selectedDeviceType,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedDeviceType = newValue;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                String ip = ipController.text;
                String name = nameController.text;

                int typeSelected = DeviceType.bulb;
                if (selectedDeviceType == deviceTypes[0]) {
                  typeSelected = DeviceType.bulb;
                } else if (selectedDeviceType == deviceTypes[1]) {
                  typeSelected = DeviceType.rgb;
                } else if (selectedDeviceType == deviceTypes[2]) {
                  typeSelected = DeviceType.door;
                } else if (selectedDeviceType == deviceTypes[3]) {
                  typeSelected = DeviceType.stair;
                }

                print('Ip: $ip, Name: $name, Type: $typeSelected');
                Navigator.pop(context);

                Device newDevice = Device(id: 0, ip: ip, name: name, type: typeSelected, state: 0);
                if (index != -1) DevciesWifiScan.removeAt(index);
                addDevice_Page_AddDevice_WifiState(newDevice);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm thiết bị qua Wifi'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: DevciesWifiScan.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: DevciesWifiScan.length,
                  itemBuilder: (context, index) {
                    final device = DevciesWifiScan[index];
                    return Card( // Đặt ListTile trong một Card để tạo hiệu ứng viền
                      margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 16.0), // Căn chỉnh và margin hợp lý
                      elevation: 1, // Đặt bóng đổ cho card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Góc bo tròn cho card
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding cho ListTile
                        title: Text(
                          device.name,
                          style: TextStyle(
                            fontSize: 18, // Kích thước chữ tiêu đề lớn hơn
                            fontWeight: FontWeight.bold, // Chữ đậm
                          ),
                        ),
                        leading: Icon(
                          Icons.stairs,
                          size: 32, // Kích thước icon lớn hơn để dễ nhìn
                          color: Colors.blueAccent, // Màu sắc icon
                        ),
                        onTap: () async => showLoginDialogHandmade(
                          context, 
                          device.ip, // Giá trị mẫu cho IP
                          device.name, // Giá trị mẫu cho tên
                          index, // Giá trị mẫu cho index
                        ), 
                      ),
                    );
                  }
                ),
              )
            ]
          ),
          Align(
            alignment: Alignment.bottomCenter, // Căn chỉnh xuống dưới giữa
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Khoảng cách từ dưới
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng nút
                children: [
                  ElevatedButton(
                    onPressed: () async => showLoginDialogHandmade(
                      context, 
                      "", // Giá trị mẫu cho IP
                      "", // Giá trị mẫu cho tên
                      -1, // Giá trị mẫu cho index
                    ), // Gọi hàm khi nhấn nút
                    style: ElevatedButton.styleFrom(
                      // padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0), // Kích thước nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Góc bo tròn
                      ),
                      backgroundColor: Colors.blueAccent, // Màu nền nút
                      elevation: 5, // Bóng đổ
                    ),
                    child: Text(
                      'Nhập thủ công',
                      style: TextStyle(
                        fontSize: 16, // Kích thước chữ
                        fontWeight: FontWeight.bold, // Chữ đậm
                        color: Colors.white, // Màu chữ
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Khoảng cách giữa hai nút
                  ElevatedButton(
                    onPressed: () {
                      // Hành động khi nhấn nút
                      // showLoginDialog_handmade();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WifiInputPage()),
                      );
                      print('Another action button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0), // Kích thước nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Góc bo tròn
                      ),
                      backgroundColor: Colors.green, // Màu nền nút
                      elevation: 5, // Bóng đổ
                    ),
                    child: Text(
                      'Không thấy thiết bị',
                      style: TextStyle(
                        fontSize: 16, // Kích thước chữ
                        fontWeight: FontWeight.bold, // Chữ đậm
                        color: Colors.white, // Màu chữ
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownButtonDeviceType extends StatefulWidget {
  final List<String> items; // Danh sách các lựa chọn
  final String? selectedValue; // Giá trị được chọn ban đầu
  final Function(String?) onChanged; // Callback khi thay đổi giá trị

  DropdownButtonDeviceType({
    required this.items,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  State<DropdownButtonDeviceType> createState() => _DropdownButtonDeviceTypeState();
}

class _DropdownButtonDeviceTypeState extends State<DropdownButtonDeviceType> {
  String _currentValue  = deviceTypes.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _currentValue,
      // icon: const Icon(Icons.menu),
      elevation: 16,
      // style: const TextStyle(color: Colors.deepPurple),
      // underline: Container(
      //   height: 2,
      //   color: Colors.deepPurpleAccent,
      // ),
      borderRadius: BorderRadius.circular(10),
      onChanged: (String? value) {
        // Cập nhật giá trị khi người dùng chọn
        setState(() {
          _currentValue = value!;
        });
        widget.onChanged(value);
      },
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}

typedef MenuEntry = DropdownMenuEntry<String>;

class DropdownMenuExample extends StatefulWidget {
  // const DropdownMenuExample({super.key});

  final String? selectedValue; // Giá trị được chọn ban đầu
  final Function(String?) onChanged; // Callback khi thay đổi giá trị

  DropdownMenuExample({
    this.selectedValue,
    required this.onChanged,
  });
  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    deviceTypes.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  String selectedValue = deviceTypes.first;

  @override
  void initState() {
    super.initState();
    // Gán giá trị mặc định từ widget.selectedValue nếu có, nếu không, sử dụng giá trị đầu tiên trong danh sách
    selectedValue = widget.selectedValue ?? deviceTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: deviceTypes.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          selectedValue = value!;
        });
        widget.onChanged(value); // Gọi callback với giá trị mới
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}