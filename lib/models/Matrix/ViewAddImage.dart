
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lcled/models/Matrix/getPixelRGBValues.dart';
import 'package:lcled/models/select_photo_options_screen.dart';
import 'package:lcled/models/set_photo_screen.dart';
// import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

List<dynamic> input2 = [];

Future<String> convertImageToBase64(File imageFile) async {
  try {
    // Đọc dữ liệu ảnh dưới dạng bytes
    final bytes = await imageFile.readAsBytes();
    // Mã hóa dữ liệu ảnh thành chuỗi Base64
    final base64Image = base64Encode(bytes);
    return base64Image;
  } catch (e) {
    print("Lỗi khi chuyển đổi ảnh: $e");
    return '';
  }
}

// Hiển thị hình ảnh canvas
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

List<String> transformList(List<dynamic> inputList) {
  List<String> outputList = [];
  print("inputList: $inputList");
  
  for (int i = 0; i < inputList.length; i++) {
    var element = inputList[i];
    if (element is int){
      // Nếu phần tử là một số (chỉ số), lấy chuỗi từ phần tử kế tiếp
      // Tìm chuỗi tại các chỉ số tương ứng và thêm vào danh sách kết quả
      i++;
      var nextElement = inputList[i];
      if (nextElement is int){
        i++;
        var color = inputList[i];
        for (int j = element; j < nextElement; j++){
          outputList.add(color);
        }
        if (nextElement != 4096) {
          i++;
          if (inputList[i] is int){
            // outputList.add(inputList[i-1]);
            // return [];
            i--;
          }else {
            outputList.add(inputList[i]);
          }
        }
      }
    }else {
      var color = inputList[i];
      outputList.add(color);
    }
  }
  print("outputList: $outputList");
  return outputList;
}


List<String> input = transformList(input2);

// Danh sách dữ liệu ban đầu
List<dynamic> rawColors = input;

// Tạo danh sách màu từ rawColors
List<Color> colors = rawColors
  .whereType<String>() // Lấy các phần tử kiểu chuỗi
  .map(parseHexColor) // Chuyển chuỗi thành Color
  .toList();


class ColorGridScreen extends StatefulWidget {
  const ColorGridScreen({super.key});

  static const id = 'set_photo_screen';

  @override
  State<ColorGridScreen> createState() => _ColorGridScreenState();
}


class _ColorGridScreenState extends State<ColorGridScreen> {

  // ignore: unused_field
  File? _image;
  Future<void> _pickImage(ImageSource source) async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    File img = File(pickedFile.path);
    final croppedFile = await _cropImage(imageFile: img);

    if (croppedFile != null) {
      // Chuyển đổi ảnh sang Base64 và xử lý dữ liệu trước khi gọi setState()
      final base64Image = await convertImageToBase64(croppedFile);
      List<dynamic> parsedList = await getPixelRGBValues(base64Image);

      List<String> input = transformList(parsedList);
      
      rawColors = input;

      // Cập nhật trạng thái
      setState(() {
        _image = croppedFile;
        colors = rawColors
          .whereType<String>() // Lấy các phần tử kiểu chuỗi
          .map(parseHexColor) // Chuyển chuỗi thành Color
          .toList();
      });

      // In kết quả nếu cần
      print("parsedList: $parsedList");
    }
  } on PlatformException catch (e) {
    print("Error picking image: $e");
  }
}


  Future<File?> _cropImage({required File imageFile}) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Chỉnh sửa ảnh',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Chỉnh sửa ảnh',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(
              width: 520,
              height: 520,
            ),
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch (e) {
      print("Error cropping image: $e");
    }

    return null;
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SelectPhotoOptionsScreen(
              onTap: _pickImage,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma trận màu sắc từ danh sách'),
      ),
      body:  Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _showSelectPhotoOptions(context);
                      },
                      child: Center(
                        child: _image == null
                          ? const Text(
                              'Chưa chọn ảnh nào',
                              style: TextStyle(fontSize: 20),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                double size = MediaQuery.of(context).size.width; // Chiều rộng màn hình
                                return Container(
                                  width: size, // Chiều rộng bằng chiều rộng màn hình
                                  height: size, // Chiều cao bằng chiều rộng
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover, // Điều chỉnh ảnh lấp đầy hình vuông
                                    ),
                                  ),
                                );
                              },
                            ),
                      ),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 64, // Số cột trong lưới
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                  ),
                  itemCount: colors.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter, // Căn chỉnh xuống dưới giữa
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Khoảng cách từ dưới
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng nút
                children: [
                  ElevatedButton(
                    onPressed: ()=> _showSelectPhotoOptions(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Góc bo tròn
                      ),
                      backgroundColor: Colors.blueAccent, // Màu nền nút
                      elevation: 5, // Bóng đổ
                    ),
                    child: Text(
                      'Nhập ảnh',
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => WifiInputPage()),
                      // );
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
                      'Đặt ảnh',
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