import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lcled/models/devices.dart';

class StairStep {
  bool SegOn; // Trạng thái của các LED trên bậc (ON/OFF)
  double SegLen; // Màu sắc của các LED trên bậc
  StairStep({required this.SegOn, required this.SegLen});
}

Future<String> sendGetRequest(String ip, String key) async {
  // Địa chỉ IP của WLED
  String url = 'http://$ip/json/$key';

  // Gửi yêu cầu GET
  final response = await http.get(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );

  // Kiểm tra phản hồi từ server
  if (response.statusCode == 200) {
    // Nếu thành công, trả về chuỗi JSON nhận được
    return response.body;
  } else {
    // Nếu có lỗi, ném ra thông báo lỗi
    throw Exception('Yêu cầu thất bại với mã lỗi: ${response.statusCode}');
  }
}

void sendPostRequest(String ip, String key, Map<String, dynamic> data) async {
  // Địa chỉ IP của WLED
  String url = 'http://$ip/json/$key';
  print("data: $data");
  // Gửi yêu cầu POST
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  // Kiểm tra kết quả phản hồi
  if (response.statusCode == 200) {
    print('Yêu cầu thành công! Phản hồi: ${response.body}');
  } else {
    print('Yêu cầu thất bại với mã lỗi: ${response.statusCode}');
  }
}

Future<void> wled_Get_Infor(Device device) async {
  try {
    String jsonResponse = await sendGetRequest(device.ip, "state");
    Map<String, dynamic> jsonData = jsonDecode(jsonResponse);
    LightingConfig Wled_infor = LightingConfig.fromJson(jsonData);
    print('Power: ${Wled_infor.on}');
    print('Brightness: ${Wled_infor.bri}');
    print('Segment 1 ID: ${Wled_infor.seg[0].id}');
  } catch (e) {
    print('Lỗi: $e');
  }
}

Future<List<StairStep>> Wled_get_seg(Device device) async {
  List<StairStep> segs = [];
  try {
    // Lấy dữ liệu JSON từ thiết bị
    String jsonResponse = await sendGetRequest(device.ip, "state");

    // Giải mã JSON thành kiểu dữ liệu phù hợp
    dynamic jsonData = jsonDecode(jsonResponse);

    // Kiểm tra nếu dữ liệu là một List, tức là không phải Map
    if (jsonData is Map) {
      var segList = jsonData['seg'];
      // Chuyển đổi danh sách thành List<StairStep>
      segs = segList.map<StairStep>((seg) {
        return StairStep(
          SegOn: seg['on'] ?? false, // Giá trị mặc định là false nếu không tìm thấy
          SegLen: (seg['len'] ?? 0).toDouble(), // Giá trị mặc định là 0
        );
      }).toList();
    }
  } catch (e) {
    print('Lỗi: $e');
  }
  return segs;
}

Future<void> fetchWLEDState() async {
  final String apiUrl = "http://<ip_address>/json/state";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("WLED State: $data");
      // Xử lý trạng thái ở đây
    } else {
      print("Failed to fetch WLED state. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching WLED state: $e");
  }
}

Future<void>  Wled_Togglele(Device device) async {
  try {
    String jsonResponse = await sendGetRequest(device.ip, "state");
    Map<String, dynamic> jsonData = jsonDecode(jsonResponse);
    LightingConfig Wled_infor = LightingConfig.fromJson(jsonData);
    bool state = !Wled_infor.on;
    // Dữ liệu JSON cần gửi
    Map<String, dynamic> data = {
      'on': state,
    };
    sendPostRequest(device.ip, "state", data);
  } catch (e) {
    print('Lỗi isisisis: $e');
  }
}

Future<List<String>> wled_Get_eff(Device device) async {
  try {
    // Gửi yêu cầu GET và nhận chuỗi JSON
    String jsonResponse = await sendGetRequest(device.ip, "eff");

    // Giải mã chuỗi JSON thành một danh sách
    List<dynamic> jsonData = jsonDecode(jsonResponse);

    // Chuyển đổi List<dynamic> thành List<String>
    return List<String>.from(jsonData);
  } catch (e) {
    print('Lỗi: $e');
    return <String>[]; // Trả về danh sách rỗng nếu có lỗi
  }
}

Future<void>  Wled_Set_color_all(Device device, List<List<int>> col) async {
  try {
    // Lấy dữ liệu JSON từ thiết bị
    String jsonResponse = await sendGetRequest(device.ip, "state");

    // Giải mã JSON thành kiểu dữ liệu phù hợp
    dynamic jsonData = jsonDecode(jsonResponse);

    // Kiểm tra nếu dữ liệu là một List, tức là không phải Map
    if (jsonData is List) {
      // Xử lý trường hợp trả về là List
      print('Dữ liệu trả về là List');
      // Nếu bạn muốn lấy giá trị từ List, có thể truy cập như sau:
      var firstItem = jsonData[0];  // lấy phần tử đầu tiên trong List
      print(firstItem);
    } else if (jsonData is Map) {
      // Xử lý trường hợp trả về là Map
      print('Dữ liệu trả về là Map');
      // Tiến hành cập nhật các trường "fx", "sx", "ix"
      for (var segment in jsonData['seg']) {
        // Cập nhật giá trị trong mảng "col"
        segment["col"] = col;
      }
      // Chuyển lại Map thành JSON để gửi lại
      String updatedJsonString = jsonEncode(jsonData);

      // In ra JSON đã được cập nhật
      print(updatedJsonString);

      // Ép kiểu (cast) dynamic thành Map<String, dynamic>
      Map<String, dynamic> jsonMap = jsonData as Map<String, dynamic>;

      // Gửi lại JSON (nếu cần)
      sendPostRequest(device.ip, "state", jsonMap);
} else {
  print('Dữ liệu trả về không phải Map hay List');
}
  } catch (e) {
    print('Lỗi: $e');
  }
}

Future<void>  Wled_Set_bri_all(Device device, double bri) async {
  try {
    // Lấy dữ liệu JSON từ thiết bị
    String jsonResponse = await sendGetRequest(device.ip, "state");

    // Giải mã JSON thành kiểu dữ liệu phù hợp
    dynamic jsonData = jsonDecode(jsonResponse);

    // Kiểm tra nếu dữ liệu là một List, tức là không phải Map
    if (jsonData is List) {
      // Xử lý trường hợp trả về là List
      print('Dữ liệu trả về là List');
      // Nếu bạn muốn lấy giá trị từ List, có thể truy cập như sau:
      var firstItem = jsonData[0];  // lấy phần tử đầu tiên trong List
      print(firstItem);
    } else if (jsonData is Map) {
      // Xử lý trường hợp trả về là Map
      print('Dữ liệu trả về là Map');
      jsonData['bri'] = bri.toInt();
      // Chuyển lại Map thành JSON để gửi lại
      String updatedJsonString = jsonEncode(jsonData);

      // In ra JSON đã được cập nhật
      print(updatedJsonString);

      // Ép kiểu (cast) dynamic thành Map<String, dynamic>
      Map<String, dynamic> jsonMap = jsonData as Map<String, dynamic>;

      // Gửi lại JSON (nếu cần)
      sendPostRequest(device.ip, "state", jsonMap);
} else {
  print('Dữ liệu trả về không phải Map hay List');
}
  } catch (e) {
    print('Lỗi: $e');
  }
}

Future<void>  Wled_Set_eff_all(Device device, int fxID) async {
  try {
    // Lấy dữ liệu JSON từ thiết bị
    String jsonResponse = await sendGetRequest(device.ip, "state");

    // Giải mã JSON thành kiểu dữ liệu phù hợp
    dynamic jsonData = jsonDecode(jsonResponse);

    // Kiểm tra nếu dữ liệu là một List, tức là không phải Map
    if (jsonData is List) {
      // Xử lý trường hợp trả về là List
      print('Dữ liệu trả về là List');
      // Nếu bạn muốn lấy giá trị từ List, có thể truy cập như sau:
      var firstItem = jsonData[0];  // lấy phần tử đầu tiên trong List
      print(firstItem);
    } else if (jsonData is Map) {
      // Xử lý trường hợp trả về là Map
      print('Dữ liệu trả về là Map');
      // Tiến hành cập nhật các trường "fx", "sx", "ix"
      for (var segment in jsonData['seg']) {
        segment['fx'] = fxID;  // Cập nhật fx thành 27 cho tất cả các phần tử
        // segment['sx'] = 128; // Cập nhật sx thành 128 cho tất cả các phần tử
        // segment['ix'] = 128; // Cập nhật ix thành 128 cho tất cả các phần tử
      }
      // Chuyển lại Map thành JSON để gửi lại
      String updatedJsonString = jsonEncode(jsonData);

      // In ra JSON đã được cập nhật
      print(updatedJsonString);

      // Ép kiểu (cast) dynamic thành Map<String, dynamic>
      Map<String, dynamic> jsonMap = jsonData as Map<String, dynamic>;

      // Gửi lại JSON (nếu cần)
      sendPostRequest(device.ip, "state", jsonMap);
} else {
  print('Dữ liệu trả về không phải Map hay List');
}
  } catch (e) {
    print('Lỗi: $e');
  }
}

Future<void>  Wled_add_seg(Device device, bool isadd) async {
  try {
    // Lấy dữ liệu JSON từ thiết bị
    String jsonResponse = await sendGetRequest(device.ip, "state");

    // Giải mã JSON thành kiểu dữ liệu phù hợp
    dynamic jsonData = jsonDecode(jsonResponse);

    // Kiểm tra nếu dữ liệu là một List, tức là không phải Map
    if (jsonData is List) {
      // Xử lý trường hợp trả về là List
      print('Dữ liệu trả về là List');
      // Nếu bạn muốn lấy giá trị từ List, có thể truy cập như sau:
      var firstItem = jsonData[0];  // lấy phần tử đầu tiên trong List
      print(firstItem);
    } else if (jsonData is Map) {
      // Xử lý trường hợp trả về là Map
      print('Dữ liệu trả về là Map');
      // thêm hoặc xóa 1 segseg
      if (isadd){
        // Lấy phần tử cuối
        // thay đỏi số lượng LED truóctruóc
        var lateSeg;
        for (var segment in jsonData['seg']) {
          lateSeg = segment;
        }
        // Copy seg
        lateSeg['id'] = lateSeg['id'] + 1;
        lateSeg['start'] = lateSeg['stop'];
        lateSeg['stop'] = lateSeg['start'] + lateSeg['len'];
        // Thêm 1 seg: giống seg cuối
        // Thêm phần tử vào cuối mảng
        jsonData['seg'].add(lateSeg);
      }else {
        // Xóa 1 seg endend
        // Lấy phần tử cuối
        var lateSeg;
        for (var segment in jsonData['seg']) {
          lateSeg = segment;
        }
        // Copy seg
        lateSeg['start'] = 0;
        lateSeg['stop'] = 0;
        lateSeg['len'] = 0;
        // Thêm 1 seg: giống seg cuối
        // Thêm phần tử vào cuối mảng
        jsonData['seg'].removeLast();
        jsonData['seg'].add(lateSeg);
      }
      // Ép kiểu (cast) dynamic thành Map<String, dynamic>
      Map<String, dynamic> jsonMap = jsonData as Map<String, dynamic>;

      // Gửi lại JSON (nếu cần)
      await Future.delayed(Duration(seconds: 1));
      sendPostRequest(device.ip, "state", jsonMap);
    } else {
      print('Dữ liệu trả về không phải Map hay List');
    }
  } catch (e) {
    print('Lỗi: $e');
  }
}

Future<void> Wled_change_segLed(Device device, int stepIndex, double newLedCount) async {
  try {
    // Lấy dữ liệu JSON từ thiết bị
    String jsonResponse = await sendGetRequest(device.ip, "state");

    // Giải mã JSON
    dynamic jsonData = jsonDecode(jsonResponse);

    if (jsonData is Map && jsonData.containsKey('seg')) {
      print('Dữ liệu trả về là Map');
      print('stepIndex: $stepIndex');

      // Kiểm tra 'seg' là List
      if (jsonData['seg'] is List) {
        // List<dynamic> segments = jsonData['seg'];
        // Lấy danh sách segments
        List<Map<String, dynamic>> segments = List<Map<String, dynamic>>.from(jsonData['seg']);
        // Chỉ giữ lại các thuộc tính cần thiết
        segments = segments.map((segment) {
          return {
            "id": segment['id'],
            "len": segment['len'],
            "start": segment['start'],
            "stop": segment['stop'],
          };
        }).toList();
        // Cập nhật số lượng LED và các thuộc tính liên quan
        double start = 0;
        for (var segment in segments) {
          if (segment['id'] == stepIndex) {
            segment['len'] = newLedCount;
            segment['stop'] = segment['start'] + segment['len'];
            start = segment['stop'];
          } else if (segment['id'] > stepIndex) {
            segment['start'] = start;
            segment['stop'] = segment['start'] + segment['len'];
            start = segment['stop'];
          }
        }
        // Gói dữ liệu cập nhật trong một map

        segments = segments.map((segment) {
          return {
            "id": segment['id'],
            "len": segment['len'].toInt(),  // Chuyển đổi len thành int
            "start": segment['start'].toInt(),  // Chuyển đổi start thành int
            "stop": segment['stop'].toInt(),  // Chuyển đổi stop thành int
          };
        }).toList();

        // Gói dữ liệu cập nhật trong một map
        Map<String, dynamic> updatedData = {
          "seg": segments
        };
        // Gửi lại request POST để cập nhật trên thiết bị
        sendPostRequest(device.ip, "state", updatedData);
        print('Dữ liệu cập nhật đã được gửi: ${jsonEncode(updatedData)}');
      } else {
        print('Dữ liệu "seg" không phải là List');
      }
    } else if (jsonData is List) {
      print('Dữ liệu trả về là List');
      // Xử lý trường hợp trả về là List (nếu cần)
    } else {
      print('Dữ liệu trả về không hợp lệ');
    }
  } catch (e) {
    print('Lỗi: $e');
  }
}

Future<bool> wled_Wifi_setup(WifInfor wifInfor) async {
   // Địa chỉ IP của WLED
  String CS = wifInfor.name;
  String CP = wifInfor.pass;

  String url = 'http://4.3.2.1/settings/wifi?CS=$CS&CP=$CP&CM=loco&AS=LOCO-AP&AP=loco1234';
  // Gửi yêu cầu POST
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: null, // body rỗng
  );

  // Kiểm tra kết quả phản hồi
  if (response.statusCode == 200) {
    print('Yêu cầu thành công! Phản hồi: ${response.body}');
    return true;
  } else {
    print('Yêu cầu thất bại với mã lỗi: ${response.statusCode}');
    return false;
  }
}

String Wled_Make_Json(Device device) {
  // Khai báo các biến
  bool on = true;
  int bri = 128;
  int transition = 7;
  int ps = -1;
  int pl = -1;
  int ledmap = 0;

  bool audioReactiveOn = false;

  bool nightLightOn = false;
  int nightLightDur = 60;
  int nightLightMode = 1;
  int nightLightTbri = 0;
  int nightLightRem = -1;

  bool udpSend = false;
  bool udpRecv = true;
  int udpSgrp = 1;
  int udpRgrp = 1;

  int lor = 0;
  int mainseg = 0;

  // Cấu hình segment
  int segId = 0;
  int segStart = 0;
  int segStop = 30;
  int segLen = 30;
  int segGrp = 1;
  int segSpc = 0;
  int segOf = 0;
  bool segOn = true;
  bool segFrz = false;
  int segBri = 255;
  int segCct = 127;
  int segSet = 0;
  List<List<int>> segCol = [
    [255, 160, 0],
    [0, 0, 0],
    [0, 0, 0],
  ];
  int segFx = 0;
  int segSx = 128;
  int segIx = 128;
  int segPal = 0;
  int segC1 = 128;
  int segC2 = 128;
  int segC3 = 16;
  bool segSel = true;
  bool segRev = false;
  bool segMi = false;
  bool segO1 = false;
  bool segO2 = false;
  bool segO3 = false;
  int segSi = 0;
  int segM12 = 0;

  // Tạo JSON từ các biến
  Map<String, dynamic> jsonMap = {
    "on": on,
    "bri": bri,
    "transition": transition,
    "ps": ps,
    "pl": pl,
    "ledmap": ledmap,
    "AudioReactive": {
      "on": audioReactiveOn,
    },
    "nl": {
      "on": nightLightOn,
      "dur": nightLightDur,
      "mode": nightLightMode,
      "tbri": nightLightTbri,
      "rem": nightLightRem,
    },
    "udpn": {
      "send": udpSend,
      "recv": udpRecv,
      "sgrp": udpSgrp,
      "rgrp": udpRgrp,
    },
    "lor": lor,
    "mainseg": mainseg,
    "seg": [
      {
        "id": segId,
        "start": segStart,
        "stop": segStop,
        "len": segLen,
        "grp": segGrp,
        "spc": segSpc,
        "of": segOf,
        "on": segOn,
        "frz": segFrz,
        "bri": segBri,
        "cct": segCct,
        "set": segSet,
        "col": segCol,
        "fx": segFx,
        "sx": segSx,
        "ix": segIx,
        "pal": segPal,
        "c1": segC1,
        "c2": segC2,
        "c3": segC3,
        "sel": segSel,
        "rev": segRev,
        "mi": segMi,
        "o1": segO1,
        "o2": segO2,
        "o3": segO3,
        "si": segSi,
        "m12": segM12,
      },
    ],
  };

  // Chuyển Map sang JSON string
  String jsonString = jsonEncode(jsonMap);

  // In chuỗi JSON
  print(jsonString);
  return jsonString;
}

class Segment {
  int id;
  int start;
  int stop;
  int len;
  int grp;
  int spc;
  int of;
  bool on;
  bool frz;
  int bri;
  int cct;
  int set;
  List<List<int>> col;
  int fx;
  int sx;
  int ix;
  int pal;
  int c1;
  int c2;
  int c3;
  bool sel;
  bool rev;
  bool mi;
  bool o1;
  bool o2;
  bool o3;
  int si;
  int m12;

  Segment({
    required this.id,
    required this.start,
    required this.stop,
    required this.len,
    required this.grp,
    required this.spc,
    required this.of,
    required this.on,
    required this.frz,
    required this.bri,
    required this.cct,
    required this.set,
    required this.col,
    required this.fx,
    required this.sx,
    required this.ix,
    required this.pal,
    required this.c1,
    required this.c2,
    required this.c3,
    required this.sel,
    required this.rev,
    required this.mi,
    required this.o1,
    required this.o2,
    required this.o3,
    required this.si,
    required this.m12,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    var colFromJson = json['col'] as List;
    List<List<int>> colList = colFromJson.map((i) => List<int>.from(i)).toList();

    return Segment(
      id: json['id'],
      start: json['start'],
      stop: json['stop'],
      len: json['len'],
      grp: json['grp'],
      spc: json['spc'],
      of: json['of'],
      on: json['on'],
      frz: json['frz'],
      bri: json['bri'],
      cct: json['cct'],
      set: json['set'],
      col: colList,
      fx: json['fx'],
      sx: json['sx'],
      ix: json['ix'],
      pal: json['pal'],
      c1: json['c1'],
      c2: json['c2'],
      c3: json['c3'],
      sel: json['sel'],
      rev: json['rev'],
      mi: json['mi'],
      o1: json['o1'],
      o2: json['o2'],
      o3: json['o3'],
      si: json['si'],
      m12: json['m12'],
    );
  }
}

class LightingConfig {
  bool on;
  int bri;
  int transition;
  int ps;
  int pl;
  int ledmap;
  Map<String, bool> audioReactive;
  Map<String, dynamic> nl;
  Map<String, dynamic> udpn;
  int lor;
  int mainseg;
  List<Segment> seg;

  LightingConfig({
    required this.on,
    required this.bri,
    required this.transition,
    required this.ps,
    required this.pl,
    required this.ledmap,
    required this.audioReactive,
    required this.nl,
    required this.udpn,
    required this.lor,
    required this.mainseg,
    required this.seg,
  });

  factory LightingConfig.fromJson(Map<String, dynamic> json) {
    var segFromJson = json['seg'] as List;
    List<Segment> segList = segFromJson.map((i) => Segment.fromJson(i)).toList();

    return LightingConfig(
      on: json['on'] ?? false,  // Default value if 'on' is null
      bri: json['bri'] ?? 0,    // Default value if 'bri' is null
      transition: json['transition'] ?? 0,  // Default value if 'transition' is null
      ps: json['ps'] ?? 0,      // Default value if 'ps' is null
      pl: json['pl'] ?? 0,      // Default value if 'pl' is null
      ledmap: json['ledmap'] ?? 0,  // Default value if 'ledmap' is null
      audioReactive: Map<String, bool>.from(json['audioReactive'] ?? {}), // Default to empty map if null
      nl: Map<String, dynamic>.from(json['nl'] ?? {}),  // Default to empty map if null
      udpn: Map<String, dynamic>.from(json['udpn'] ?? {}),  // Default to empty map if null
      lor: json['lor'] ?? 0,     // Default value if 'lor' is null
      mainseg: json['mainseg'] ?? 0,  // Default value if 'mainseg' is null
      seg: segList,
    );
  }
}
