import 'package:flutter/material.dart';

// Tạo danh sách màu từ rawColors
List<String> transformList(List<dynamic> inputList) {
  List<String> outputList = [];
  
  for (int i = 0; i < inputList.length; i++) {
    var element = inputList[i];
    if (element is int){
      // Nếu phần tử là một số (chỉ số), lấy chuỗi từ phần tử kế tiếp
      // Tìm chuỗi tại các chỉ số tương ứng và thêm vào danh sách kết quả
      i++;
      var nextElement = inputList[i];
      print("element: $element, nextElement: $nextElement");
      i++;
      var color = inputList[i];
      for (int j = element; j < nextElement; j++){
        outputList.add(color);
      }
      if (nextElement != 256) {
        i++;
        outputList.add(inputList[i]);
      }
    }else {
      outputList.add(inputList[i]);
    }
  }
  return outputList;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColorGridScreen(),
    );
  }
}

// Hàm chuyển chuỗi hexa thành Color
Color parseHexColor(String hexColor) {
  final cleanedHex = hexColor.replaceAll('#', '');
  if (cleanedHex.length == 6) {
    return Color(int.parse('FF$cleanedHex', radix: 16)); // Thêm alpha = 255
  } else if (cleanedHex.length == 8) {
    return Color(int.parse(cleanedHex, radix: 16));
  } else {
    return Colors.black; // Giá trị mặc định nếu lỗi
  }
}

// List<dynamic> input = [0,2,'106c21','093c12',3,6,'010602','0e601d',7,9,'106c21','0f661f',10,12,'010602','040404','162c1a',14,17,'106c21','093d13','3d0d04','a30000','a20000','a30000','081c08','0f671f','106c21','041e09',26,28,'a30000','232323','0b0b0a','16301b','106c21','0b4c17','350401','c51f1f','ff4747','ff4c4c','ff0000','820000','09310f','083711','770000',42,44,'ff0000','4a4a4a','232323','080808','17451f','000000','d00000','ff9696','ffffff','ffecec','ff0101','ff0000','4b0000','390000',57,60,'ff0000','4c4c4c','494949','1e1e1e','000000','010401','bd0000','ffc8c8','ffffff','ff1111',69,71,'ff0000','f30000','f10000',73,76,'ff0000','4c4c4c','444444','1b1b1b','030303','010602','ba0000','ff2424','fe2626',84,92,'ff0000','4c4c4c','434343','1a1a1a','040404','000000','c80000','ff2727','fe3535',100,108,'ff0000','4c4c4c','474747','1d1d1d','000000','020b03','af0100','fabcbc','fff7f7',116,124,'ff0000','4c4c4c','414141','1a1a1a','060707','0f661f','0b0e04','a20c0c','ff1010',132,140,'ff0000','444444','171717','060606','126421','106c21','0c4e18','241406','9c0000',148,155,'ff0000','e40000','1d1d1d','0d0d0c','17431f',159,162,'106c21','0b4a17','131005','c20000',165,170,'ff0000','e30000','730000','080a08','173d1e',174,179,'106c21','0c5219','030100','f70000',182,185,'ff0000','ea0000','750000','000100','17431f',189,195,'106c21','106a20','0c5319','160000','eb0000','ff0000','f70000','790000','0a0000','0b4e18','116821',205,213,'106c21','0a4214','470000','b40000','ab0000','180000','0a4114',219,230,'106c21','083310','2e0100','3b0000','072e0e',234,247,'106c21','05200a','041807',249,256,'106c21'];



List<dynamic> input2 = [0,2,'106c21','093c12',3,6,'010602','0e601d',7,9,'106c21','0f661f',10,12,'010602','040404','162c1a',14,17,'106c21','093d13','3d0d04','a30000','a20000','a30000','081c08','0f671f','106c21','041e09',26,28,'a30000','232323','0b0b0a','16301b','106c21','0b4c17','350401','c51f1f','ff4747','ff4c4c','ff0000','820000','09310f','083711','770000',42,44,'ff0000','4a4a4a','232323','080808','17451f','000000','d00000','ff9696','ffffff','ffecec','ff0101','ff0000','4b0000','390000',57,60,'ff0000','4c4c4c','494949','1e1e1e','000000','010401','bd0000','ffc8c8','ffffff','ff1111',69,71,'ff0000','f30000','f10000',73,76,'ff0000','4c4c4c','444444','1b1b1b','030303','010602','ba0000','ff2424','fe2626',84,92,'ff0000','4c4c4c','434343','1a1a1a','040404','000000','c80000','ff2727','fe3535',100,108,'ff0000','4c4c4c','474747','1d1d1d','000000','020b03','af0100','fabcbc','fff7f7',116,124,'ff0000','4c4c4c','414141','1a1a1a','060707','0f661f','0b0e04','a20c0c','ff1010',132,140,'ff0000','444444','171717','060606','126421','106c21','0c4e18','241406','9c0000',148,155,'ff0000','e40000','1d1d1d','0d0d0c','17431f',159,162,'106c21','0b4a17','131005','c20000',165,170,'ff0000','e30000','730000','080a08','173d1e',174,179,'106c21','0c5219','030100','f70000',182,185,'ff0000','ea0000','750000','000100','17431f',189,195,'106c21','106a20','0c5319','160000','eb0000','ff0000','f70000','790000','0a0000','0b4e18','116821',205,213,'106c21','0a4214','470000','b40000','ab0000','180000','0a4114',219,230,'106c21','083310','2e0100','3b0000','072e0e',234,247,'106c21','05200a','041807',249,256,'106c21'];

List<String> input = transformList(input2);

// Danh sách dữ liệu ban đầu
final List<dynamic> rawColors = input;

// Tạo danh sách màu từ rawColors
final List<Color> colors = rawColors
    .whereType<String>() // Lấy các phần tử kiểu chuỗi
    .map(parseHexColor) // Chuyển chuỗi thành Color
    .toList();

class ColorGridScreen extends StatelessWidget {
  const ColorGridScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma trận màu sắc từ danh sách'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 16, // Số cột trong lưới
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
        ),
        itemCount: colors.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }
}