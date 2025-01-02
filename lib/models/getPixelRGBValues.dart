import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Sửa hàm này trả về List<dynamic>

Future<List<dynamic>> getPixelRGBValues(String base64Image) async {
  List<dynamic> Array = [];
  List<List<int>> pixelRGBValues = [];
  List<String> commandArray = [];
  String JSONledString = '';
  int maxNoOfColorsInCommandString = 256;
  bool hybridAddressing = true;
  String ledSetupSelection = "matrix";
  bool hexValueCheck = true;
  bool segmentValueCheck = true;
  // ignore: dead_code
  String colorSeparatorStart = hexValueCheck ? '\'' : '[';
  // ignore: dead_code
  String colorSeparatorEnd = hexValueCheck ? '\'' : ']';

  // Decode the Base64 image
  Uint8List imageBytes = base64Decode(base64Image.split(',').last);
  ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
  ui.FrameInfo frame = await codec.getNextFrame();
  ui.Image image = frame.image;

  // Resize the image to 16x16
  int sizeX = 16;
  int sizeY = 16;
  ui.PictureRecorder recorder = ui.PictureRecorder();
  ui.Canvas canvas = ui.Canvas(recorder);
  ui.Paint paint = ui.Paint();
  canvas.drawImageRect(
    image,
    ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    ui.Rect.fromLTWH(0, 0, sizeX.toDouble(), sizeY.toDouble()),
    paint,
  );
  ui.Image resizedImage = await recorder.endRecording().toImage(sizeX, sizeY);

  ByteData? byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.rawRgba);
  if (byteData == null) {
    throw Exception("Failed to get image data.");
  }

  List<int> pixelData = byteData.buffer.asUint8List();
  int right2leftAdjust = ledSetupSelection == 'l2r' ? 0 : 1;

  for (int i = 0; i < pixelData.length; i += 4) {
    int r = pixelData[i];
    int g = pixelData[i + 1];
    int b = pixelData[i + 2];
    int a = pixelData[i + 3];
    int pixel = i ~/ 4;
    int row = pixel ~/ sizeX;
    int led = pixel;

    if (ledSetupSelection == 'matrix') {
      // Do nothing, matrix handling here if needed
    } else if ((row + right2leftAdjust) % 2 == 0) {
      // Handle left-to-right vs right-to-left addressing
      int indexOnRow = led - (row * sizeX);
      int maxIndexOnRow = sizeX - 1;
      int reversedIndexOnRow = maxIndexOnRow - indexOnRow;
      led = (row * sizeX) + reversedIndexOnRow;
    }

    pixelRGBValues.add([r, g, b, a, led, pixel, row]);
  }

  pixelRGBValues.sort((a, b) => a[5].compareTo(b[5]));
  List<List<int>> ledRGBValues = [...pixelRGBValues];
  ledRGBValues.sort((a, b) => a[4].compareTo(b[4]));

  int segmentStart = -1;
  int curentColorIndex = 0;

  for (int i = 0; i < ledRGBValues.length; i++) {
    var pixel = ledRGBValues[i];
    int r = pixel[0];
    int g = pixel[1];
    int b = pixel[2];
    String segmentString = '';
    int segmentEnd = -1;

    if (segmentValueCheck) {
      if (segmentStart < 0) {
        segmentStart = i;
      }
      if (i < ledRGBValues.length - 1) {
        var nextPixel = ledRGBValues[i + 1];
        if (nextPixel[0] != r || nextPixel[1] != g || nextPixel[2] != b) {
          segmentEnd = i + 1;
          segmentString = (segmentStart == i && hybridAddressing)
              ? ''
              : '$segmentStart,$segmentEnd,';
        }
      } else {
        segmentEnd = i + 1;
        segmentString = (segmentStart + 1 == segmentEnd && hybridAddressing)
            ? ''
            : '$segmentStart,$segmentEnd,';
      }
    }

    if (segmentEnd > -1) {
      String colorValueString = hexValueCheck
          ? [r, g, b].map((x) => x.toRadixString(16).padLeft(2, '0')).join('')
          // ignore: dead_code
          : '$r,$g,$b';

      JSONledString +=
          '$segmentString$colorSeparatorStart$colorValueString$colorSeparatorEnd';
      if (segmentEnd - segmentStart != 1){
        Array.add(segmentStart);
        Array.add(segmentEnd);
      }
      

      curentColorIndex++;
      if (curentColorIndex % maxNoOfColorsInCommandString == 0 || i == ledRGBValues.length - 1) {
        commandArray.add(JSONledString);
        JSONledString = '';
        Array.add('$colorValueString');
      } else {
        JSONledString += ',';
        Array.add('$colorValueString');
      }
      segmentStart = -1;
    }
  }
  return Array;
}
