import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:lcled/models/Task.dart';
import 'package:lcled/models/devices.dart';
import 'package:wled/wled.dart';

// class DatabaseHelper {
//   static final _databaseName = 'my_database.db';
//   static final _databaseVersion = 1;

//   static final table = 'devices';
//   // static late Database _database;
//   late final Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await openDatabase(
//       join(await getDatabasesPath(), _databaseName),

//       version: _databaseVersion,
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE $table(id INTEGER PRIMARY KEY, name TEXT, type TEXT)',
//         );
//       },
//     );
//     return _database;
//   }

//   Future<List<Device>> getDevices() async {
//     // Lấy danh sách các thiết bị từ database
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(table);

//     return List.generate(maps.length, (i) {
//       return
//  Device.fromMap(maps[i]);
//     });
//   }

//   Future<void> addDevice(Device device) async {
//     // Thêm một thiết bị mới vào database
//     final db = await database;
//     await db.insert(table, device.toMap());
//   }

//   // Các phương thức update, delete tương tự
// }


// class DatabaseService {
//   static Database? _db;
//   static final DatabaseService  intance = DatabaseService._contructor();

//   final String _tasksTableName = "tasks";
//   final String _tasksIdColumnName = "id";
//   final String _tasksContentColumnName = "content";
//   final String _tasksStatusColumnName = "status";

//   DatabaseService._contructor();

//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await getDatabase();
//     return _db!;
//   }

//   Future<Database> getDatabase() async {
//     final databaseDirPath = await getDatabasesPath();
//     final databasePath = join(databaseDirPath, "master_db.db");
//     final database = await openDatabase(
//       databasePath,
//       version: 1,
//       onCreate: (db, version) {
//         db.execute('''
//         CREATE TABLE $_tasksTableName (
//           $_tasksIdColumnName INTEGER PRIMARY KEY,
//           $_tasksContentColumnName TEXT NOT NULL,
//           $_tasksStatusColumnName INTEGER NOT NULL
//         )
//         ''');
//       },
//     );
//     return database;
//   }

//   void addTask(String content,) async {
//     final db = await database;
//     await db.insert(
//       _tasksTableName,
//       {
//         _tasksContentColumnName: content,
//         _tasksStatusColumnName: 0,
//       },
//     );
//   }

//   Future<List<Task>?> getTasks() async {
//     final db = await database;
//     final data = await db.query(_tasksTableName);
//     print(data);
//   }
// }

// class Device {
//   String name;
//   String id;
//   bool isConnected;
//   bool state;
//   // Các thuộc tính khác tùy thuộc vào loại thiết bị

//   Device({
//     required this.name,
//     required this.id,
//     this.isConnected = false,
//     this.state = false,
//   });

//   // Các phương thức để điều khiển thiết bị
//   Future<void> connect() async {
//     // Logic để kết nối với thiết bị
//   }

//   Future<void> disconnect() async {
//     // Logic để ngắt kết nối với thiết bị
//   }

//   Future<void> sendData(Map<String, dynamic> data) async {
//     // Logic để gửi dữ liệu đến thiết bị
//   }

//   Future<Map<String, dynamic>> receiveData() async {
//     // Logic để nhận dữ liệu từ thiết bị
//   }
// }

var dbHelper = DatabaseHelper();

class DatabaseHelper {
  DatabaseHelper();
  static Database? _db;
  // static final DatabaseHelper  intance = DatabaseHelper._contructor();
   // Named constructor
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

    // required this.id,
    // required this.ip,
    // required this.name,
    // required this.type,
    // required this.state,
  final String TableDevices = "Devices";
  final String TableLoves = "Loves";
  final String columnId = "id";
  final String columnIp = "ip";
  final String columnName = "name";
  final String columnType = "type";
  final String columnState = "state";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "Devices_db.db");
    print("Tao bang $TableDevices");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $TableDevices (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIp TEXT,
        $columnName TEXT,
        $columnType INTEGER,
        $columnState INTEGER)
        ''');
        // Tạo bảng Users
        await db.execute('''
        CREATE TABLE $TableLoves (
        $columnId INTEGER PRIMARY KEY,
        $columnIp TEXT,
        $columnName TEXT,
        $columnType INTEGER,
        $columnState INTEGER)
        ''');
      },
    );
    return database;
  }

  Future<void> addDevice(Device device) async {
    // Thêm một thiết bị mới vào database
    final db = await database;
    await db.insert(TableDevices, device.toMap());
  }

  Future<List<Device>> getDevices() async {
    // Lấy danh sách các thiết bị từ database
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TableDevices);
    print(maps);
    return List.generate(maps.length, (i) {
      return Device.fromMap(maps[i]);
    });
  }

  Future<void> updateDevice(Device device) async {
    try {
      final db = await database; // Lấy database
      
      // Cập nhật thông tin thiết bị trong database
      await db.update(
        TableDevices, // Tên bảng
        device.toMap(), // Chuyển thiết bị thành map để lưu vào database
        where: 'id = ?', // Điều kiện để cập nhật thông tin dựa trên id
        whereArgs: [device.id], // Tham số điều kiện
      );

      updateLove(device);
      
      print('Cập nhật thiết bị thành công!');
    } catch (error) {
      print('Lỗi khi cập nhật thiết bị: $error');
    }
  }

  Future<void> deleteDevices(Device device) async {
    try {
      final db = await database; // Lấy database
      // Xóa thiết bị từ database
      await db.delete(
        TableDevices,
        where: 'id = ?', // Điều kiện để xóa thiết bị dựa trên id
        whereArgs: [device.id],
      );

      deletelove(device);

    } catch (error) {
      print('Lỗi khi xóa thiết bị: $error');
    }
  }

  Future<void> toloveDevices(Device device) async {
    try {
      // Thêm một thiết bị mới vào database
      final db = await database;
      await db.insert(TableLoves, device.toMap());
    } catch (error) {
      print('Lỗi khi xóa thiết bị: $error');
    }
  }

  Future<List<Device>> getLoves() async {
    // Lấy danh sách các thiết bị từ database
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TableLoves);
    print(maps);
    return List.generate(maps.length, (i) {
      return Device.fromMap(maps[i]);
    });
  }

  Future<void> deletelove(Device device) async {
    try {
      final db = await database; // Lấy database
      // Xóa thiết bị từ database
      await db.delete(
        TableLoves,
        where: 'id = ?', // Điều kiện để xóa thiết bị dựa trên id
        whereArgs: [device.id],
      );
    } catch (error) {
      print('Lỗi khi xóa thiết bị: $error');
    }
  }

  Future<void> updateLove(Device device) async {
    try {
      final db = await database; // Lấy database
      
      // Cập nhật thông tin thiết bị trong database
      await db.update(
        TableLoves, // Tên bảng
        device.toMap(), // Chuyển thiết bị thành map để lưu vào database
        where: 'id = ?', // Điều kiện để cập nhật thông tin dựa trên id
        whereArgs: [device.id], // Tham số điều kiện
      );
      
      print('Cập nhật thiết bị thành công!');
    } catch (error) {
      print('Lỗi khi cập nhật thiết bị: $error');
    }
  }

  Future<void> Wled_Brightness(Device device, int value) async{
    final wled = Wled(device.ip);
    wled.brightness(value);
  }
  Future<void> Wled_Change_color(Device device, Color color) async{
    final wled = Wled(device.ip);
    wled.color(color);
  }

}
