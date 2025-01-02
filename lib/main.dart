// // import 'package:flutter/material.dart';
// // import 'package:lcled/models/Task.dart';
// // import 'package:path/path.dart';
// // import 'package:sqflite/sqflite.dart';

// // /// Flutter code sample for [AppBar].

// // class Product {
// //   final String name;
// //   // final double price;
// //   // final String imageUrl;
// //   // final String description;

// //   Product({
// //     required this.name,
// //     // required this.price,
// //     // required this.imageUrl,
// //     // required this.description,
// //   });
// // }



// // List<Product> products = [
// //   Product(
// //     name: 'Thêm thiết bị',
// //     // price: 100000,
// //     // imageUrl: 'assets/images/ao_phong.jpg',
// //     // description: 'Áo phông cotton cao cấp',
// //   ),
// //   Product(
// //     name: 'Thêm nhà',
// //     // price: 100000,
// //     // imageUrl: 'assets/images/ao_phong.jpg',
// //     // description: 'Áo phông cotton cao cấp',
// //   ),
// //   Product(
// //     name: 'Thêm nhà',
// //     // price: 100000,
// //     // imageUrl: 'assets/images/ao_phong.jpg',
// //     // description: 'Áo phông cotton cao cấp',
// //   ),
// //   // ... thêm các sản phẩm khác vào đây
// // ];

// // List<String> titles = <String>[
// //   'Home',
// //   'Automation',
// //   'Add',
// //   'Setting',
// // ];

// // class Device {
// //   final int id;
// //   final String name;
// //   final int type;

// //   const Device({
// //     required this.id,
// //     required this.name,
// //     required this.type,
// //   });
// // }


// // void main() => runApp(const AppBarApp());

// // class AppBarApp extends StatelessWidget {
// //   const AppBarApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData(
// //           colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
// //       home: const AppBarExample(),
// //     );
// //   }
// // }

// // class AppBarExample extends StatefulWidget {
// //   const AppBarExample({super.key});

// //   @override
// //   _AppBarExampleState createState() => _AppBarExampleState();
// // }

// // class _AppBarExampleState extends State<AppBarExample> {
// //   int _selectedIndex = 0;
// //   late TabController _tabController;

// //   // @override
// //   // void initState() {
// //   //   super.initState();
// //   //   _tabController = TabController(length: 3, vsync: this);
// //   // }

// //   // @override
// //   // void dispose() {
// //   //   _tabController.dispose();
// //   //   super.dispose();
// //   // }
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //       // _tabController.index = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final ColorScheme colorScheme = Theme.of(context).colorScheme;
// //     final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
// //     final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
// //     const int tabsCount = 4;

// //     // int _selectedIndex = 0;
// //     final ScrollController _homeController = ScrollController();
// //     final ScrollController _homeController1 = ScrollController();

// //     int _selectedIndex = 0;
// //     const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
// //     const List<Widget> _widgetOptions =
// //     <Widget>[
// //       Text(
// //         'Index 0: Home',
// //         style: optionStyle,
// //       ),
// //       Text(
// //         'Index 1: Business',
// //         style: optionStyle,
// //       ),
// //       Text(
// //         'Index 2: School',
// //         style: optionStyle,
// //       ),
// //       Text(
// //         'Index 3: Settings',
// //         style: optionStyle,
// //       ),
// //     ];

// //     void _onItemTapped(int index) {
// //       setState(() {
// //         _selectedIndex = index;
// //       });
// //     }

// //     final DatabaseService _databaseService = DatabaseService.intance;
// //     _databaseService.addTask('Devices');

// //     _databaseService.getTasks();

// //     // final dbHelper = DatabaseHelper();
// //     // List<Device> devices = await dbHelper.getDevices();

// //     return DefaultTabController(
// //       initialIndex: 0,
// //       length: tabsCount,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('CLED'),
// //           // This check specifies which nested Scrollable's scroll notification
// //           // should be listened to.
// //           //
// //           // When `ThemeData.useMaterial3` is true and scroll view has
// //           // scrolled underneath the app bar, this updates the app bar
// //           // background color and elevation.
// //           //
// //           // This sets `notification.depth == 1` to listen to the scroll
// //           // notification from the nested `ListView.builder`.
// //           notificationPredicate: (ScrollNotification notification) {
// //             return notification.depth == 1;
// //           },
// //           // The elevation value of the app bar when scroll view has
// //           // scrolled underneath the app bar.
// //           scrolledUnderElevation: 4.0,
// //           shadowColor: Theme.of(context).shadowColor,
// //           // bottom: TabBar(
// //           //   tabs: <Widget>[
// //           //     Tab(
// //           //       icon: const Icon(Icons.home),
// //           //       text: titles[0],
// //           //     ),
// //           //     Tab(
// //           //       icon: const Icon(Icons.share_arrival_time_outlined),
// //           //       text: titles[1],
// //           //     ),
// //           //     Tab(
// //           //       icon: const Icon(Icons.add),
// //           //       text: titles[2],
// //           //     ),
// //           //     Tab(
// //           //       icon: const Icon(Icons.settings),
// //           //       text: titles[3],
// //           //     ),
// //           //   ],
// //           // ),
// //         ),
// //         body: Center(
// //           child: _widgetOptions.elementAt(_selectedIndex),
// //         ),
// //         // body: TabBarView(
// //         //   controller: _tabController,
// //         //   children: <Widget>[
// //         //     ListView.builder(
// //         //       itemCount: 5,
// //         //       itemBuilder: (BuildContext context, int index) {
// //         //         return ListTile(
// //         //           tileColor: index.isOdd ? oddItemColor : evenItemColor,
// //         //           title: Text('${titles[0]} $index'),
// //         //           trailing: ElevatedButton(
// //         //             onPressed: () {
// //         //               // Thêm sản phẩm vào giỏ hàng
// //         //               // addToCart(product);
// //         //             },
// //         //             child: Text('Setting'),
// //         //           ),
// //         //         );
// //         //       },
// //         //     ),
// //         //     ListView.builder(
// //         //       itemCount: 5,
// //         //       itemBuilder: (BuildContext context, int index) {
// //         //         return ListTile(
// //         //           tileColor: index.isOdd ? oddItemColor : evenItemColor,
// //         //           title: Text('${titles[1]} $index'),
// //         //         );
// //         //       },
// //         //     ),
// //         //     ListView.builder(
// //         //       itemCount: 5,
// //         //       itemBuilder: (BuildContext context, int index) {
// //         //         return ListTile(
// //         //           tileColor: index.isOdd ? oddItemColor : evenItemColor,
// //         //           title: Text('${titles[2]} $index'),
// //         //         );
// //         //       },
// //         //     ),
// //         //   ],
// //         // ),
// //         bottomNavigationBar: BottomNavigationBar(
// //           items: const <BottomNavigationBarItem>[
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.home),
// //               label: 'Home',
// //               backgroundColor: Colors.red,
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.business),
// //               label: 'Business',
// //               backgroundColor: Colors.green,
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.school),
// //               label: 'School',
// //               backgroundColor: Colors.purple,
// //             ),
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.settings),
// //               label: 'Settings',
// //               backgroundColor: Colors.pink,
// //             ),
// //           ],
// //           currentIndex: _selectedIndex,
// //           selectedItemColor: Colors.amber[800],
// //           onTap: _onItemTapped,
// //         ),
// //       ),
// //     );
// //   }
// //   void showModal(BuildContext context) {
// //     showDialog<void>(
// //       context: context,
// //       builder: (BuildContext context) => AlertDialog(
// //         content: const Text('Example Dialog'),
// //         actions: <TextButton>[
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //             },
// //             child: const Text('Close'),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }


// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'name': name,
// //       'age': age,
// //     };
// //   }
// // }


/////////////////////////////////////////////////////////////////////////////////////////////////
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lcled/models/account.dart';
import 'package:lcled/src/database.dart';
import 'package:lcled/models/devices.dart';
import 'package:lcled/src/pages_main.dart';
import 'package:lcled/src/advertisement.dart';
// import 'package:badges/badges.dart' as badges_pkg;  // Alias badges package

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int _selectedIndex = 0;
  List<Device> devices = []; // Khởi tạo devices với một danh sách rỗng
  List<Device> loves = []; // Khởi tạo devices với một danh sách rỗng
  late Timer _timer;
  List<String> Homes = ['ROLL Villas', 'CROWL Villas', 'ELVIS 13', 'SH-545'];

  // Đánh dấu hàm là async để sử dụng await
  Future<void> getDevices() async {
    // Giả sử db.getDevices() là một hàm bất đồng bộ trả về Future<List<Device>>
    devices = await dbHelper.getDevices(); 
    loves = await dbHelper.getLoves(); 
    setState(() {}); // Cập nhật lại UI sau khi lấy dữ liệu
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    getDevices();
  }

  @override
  void initState() {
    super.initState();
    getDevices(); // Gọi hàm get_Devices khi widget được khởi tạo
    _pageController = PageController(initialPage: currentIndex);
    
    // Tạo một Timer để tự động thay đổi ảnh sau mỗi phút
    _timer = Timer.periodic(const Duration(seconds : 10), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex) % images.length;
          if (currentIndex == 4) currentIndex = -1;
        });
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        currentIndex += 1;
      }
    });
  }
  final List<String> images = [
    'lib/assets/cgv_1.png',
    'lib/assets/cgv_2.png',
    'lib/assets/cgv_3.png',
    'lib/assets/cgv_4.png'
  ];

  // Controller cho PageView
  late PageController _pageController;

  // Biến để theo dõi index của ảnh hiện tại
  int currentIndex = 0;

  @override
  void dispose() {
    _timer.cancel(); // Hủy Timer khi widget bị dispose
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _LoadLoves() async {
    setState(() {
      getDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      SingleChildScrollView(
        child: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal), // Căn chỉnh và margin hợp lý
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 0, // Loại bỏ bóng đổ nếu không cần
            color: Colors.transparent, // Đặt nền Card trong suốt
            child: Container(
              width: 1000,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          loves.isEmpty
          ? Container(
            margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal), // Căn chỉnh và margin hợp lý
            width: 1000, // Chiều rộng của thẻ
            height: 150, // Chiều cao của thẻ
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1), // Màu nền mờ
              borderRadius: BorderRadius.circular(12), // Bo góc
              border: Border.all(
                color: const Color.fromARGB(255, 61, 55, 55).withOpacity(0.5), // Viền mờ
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Hành động khi nhấn vào biểu tượng "+"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Page_AddDevice()),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.2), // Vòng tròn nền mờ
                    ),
                    child: const Icon(
                      Icons.add, // Biểu tượng dấu +
                      color: Color.fromARGB(255, 7, 6, 6),
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Hãy bắt đầu băng việc thêm thiết bị và khám phá các sản phẩm mới của chúng ta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 85, 79, 109),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều các phần tử trong Row
            children: <Widget>[
              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                child: Text(
                  'Yêu thích',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: loves.length,
            itemBuilder: (context, index) {
              final device = loves[index];
              return Card( // Đặt ListTile trong một Card để tạo hiệu ứng viền
                margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal), // Căn chỉnh và margin hợp lý
                elevation: 1, // Đặt bóng đổ cho card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Góc bo tròn cho card
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: type_horizontal), // Padding cho ListTile
                  title: Text(
                    device.name,
                    style: TextStyle(
                      fontSize: 18, // Kích thước chữ tiêu đề lớn hơn
                      fontWeight: FontWeight.bold, // Chữ đậm
                    ),
                  ),
                  leading: Icon(
                    Icons.hub,
                    size: 32, // Kích thước icon lớn hơn để dễ nhìn
                    color: Colors.blueAccent, // Màu sắc icon
                  ),
                  trailing: ElevatedButton(
                    style: TextButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero, // Loại bỏ khoảng cách mặc định của nút
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Giảm kích thước tap
                    ),
                    onPressed: () {
                      // Hiển thị hộp thoại xác nhận
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận'),
                            content: Text('Xóa khỏi danh sách yêu thích?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Hành động khi chọn "No" (không xóa)
                                  Navigator.of(context).pop();
                                },
                                child: Text('Không'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Hành động khi chọn "Yes" (xóa)
                                  dbHelper.deletelove(device);
                                  print('Đã xóa!');
                                  Navigator.of(context).pop();
                                  _LoadLoves();
                                },
                                child: Text('Có'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Giúp nút chỉ rộng vừa đủ cho nội dung
                      children: [
                        Icon(
                          FontAwesomeIcons.minusSquare, // Icon của bạn
                          size: 30.0, // Kích thước icon
                          color: Colors.blue, // Màu icon
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Điều hướng đến trang chi tiết thiết bị
                    if (device.type == DeviceType.bulb) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WLEDControlPage(device: device), // Trang điều khiển đèn
                        ),
                      );
                    } else if (device.type == DeviceType.door) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GarageDoorPage(device: device), // Trang điều khiển cửa
                        ),
                      );
                    } else if (device.type == DeviceType.stair) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaircaseLedControlPage(device: device), // Trang điều khiển cầu thang
                        ),
                      );
                    } else if (device.type == DeviceType.rgb) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LEDControlPage(device: device), // Trang điều khiển cầu thang
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn đều các phần tử trong Row
            children: <Widget>[
              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  // padding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                child: Text(
                  'Locoloco Khám phá',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          const CustomImageCard(
            imagePath: 'lib/assets/ban_nang_ha.png',
            title: 'Bàn học thông minh LOCOLOCO',
            link: "https://www.flutter.dev",
          ),
          const CustomImageCard(
            imagePath: 'lib/assets/3d_Pha_le.png',
            title: '3D pha lê thông minh LOCOLOCO',
            link: "https://www.facebook.com/tuyen.o.838596",
          ),
        ],
      ),
      ),
      devices.isEmpty
      ? Container(
        margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal), // Căn chỉnh và margin hợp lý
        width: 1000, // Chiều rộng của thẻ
        height: 150, // Chiều cao của thẻ
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1), // Màu nền mờ
          borderRadius: BorderRadius.circular(12), // Bo góc
          border: Border.all(
            color: const Color.fromARGB(255, 61, 55, 55).withOpacity(0.5), // Viền mờ
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Hành động khi nhấn vào biểu tượng "+"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Page_AddDevice()),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.2), // Vòng tròn nền mờ
                ),
                child: const Icon(
                  Icons.add, // Biểu tượng dấu +
                  color: Color.fromARGB(255, 7, 6, 6),
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Hãy bắt đầu bằng việc thêm thiết bị và khám phá các sản phẩm mới của chúng ta.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 85, 79, 109),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ) // Hiển thị loading nếu danh sách thiết bị rỗng
      : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Card( // Đặt ListTile trong một Card để tạo hiệu ứng viền
            margin: EdgeInsets.symmetric(vertical: type_vertical, horizontal: type_horizontal), // Căn chỉnh và margin hợp lý
            elevation: 1, // Đặt bóng đổ cho card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Góc bo tròn cho card
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: type_horizontal), // Padding cho ListTile
              title: Text(
                device.name,
                style: TextStyle(
                  fontSize: 18, // Kích thước chữ tiêu đề lớn hơn
                  fontWeight: FontWeight.bold, // Chữ đậm
                ),
              ),
              leading: Icon(
                Icons.hub,
                size: 32, // Kích thước icon lớn hơn để dễ nhìn
                color: Colors.blueAccent, // Màu sắc icon
              ),
              trailing: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert, // Dùng biểu tượng 3 chấm thay vì bút, dễ nhận diện hơn
                  size: 28, // Kích thước icon nhỏ hơn
                  color: Colors.blue, // Màu icon
                ),
                onSelected: (String value) {
                  // Xử lý lựa chọn từ menu
                  switch (value) {
                    case 'tolove':
                      // Gọi logic chỉnh sửa
                      dbHelper.toloveDevices(device);
                      break;
                    case 'delete':
                      // Gọi logic xóa
                      dbHelper.deleteDevices(device);
                      break;
                    case 'change':
                      // Gọi logic chia sẻ
                      showLoginDialog_handmade(device);
                      break;
                    case 'share':
                      // Gọi logic chia sẻ
                      // _shareDevice(device);
                      break;
                  }
                  _LoadLoves();
              },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'tolove',
                    child: ListTile(
                      leading: Icon(Icons.heart_broken, color: Colors.green),
                      title: Text('Yêu thích'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Xóa'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'change',
                    child: ListTile(
                      leading: Icon(Icons.edit, color: Colors.blue),
                      title: Text('Sửa'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share, color: Colors.blue),
                      title: Text('Chia sẻ'),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Điều hướng đến trang chi tiết thiết bị
                if (device.type == DeviceType.bulb) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WLEDControlPage(device: device), // Trang điều khiển đèn
                    ),
                  );
                } else if (device.type == DeviceType.door) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GarageDoorPage(device: device), // Trang điều khiển cửa
                    ),
                  );
                } else if (device.type == DeviceType.stair) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaircaseLedControlPage(device: device), // Trang điều khiển cầu thang
                    ),
                  );
                } else if (device.type == DeviceType.rgb) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LEDControlPage(device: device), // Trang điều khiển cầu thang
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      Icon(
        Icons.chat,
        size: 150,
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                print('Container tapped!');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountManagementPage()),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: type_horizontal),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'tuyen',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Chủ nhà',
                              style: TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSection(context, [
              _buildTile(
                context,
                icon: Icons.location_city,
                color: Colors.red,
                title: 'Quản lý khu vực',
              ),
              _buildTile(
                context,
                icon: Icons.devices,
                color: Colors.green,
                title: 'Quản lý thiết bị',
              ),
              _buildTile(
                context,
                icon: Icons.people,
                color: Colors.purple,
                title: 'Quản lý thành viên',
              ),
            ]),
            const SizedBox(height: 30),
            _buildSection(context, [
              _buildTile(
                context,
                icon: Icons.notifications,
                color: Colors.yellow,
                title: 'Thông báo',
              ),
              _buildTile(
                context,
                icon: Icons.language,
                color: Colors.blue,
                title: 'Ngôn ngữ & giao diện',
              ),
            ]),
            const SizedBox(height: 60),
          ],
        ),
      ),
    ];
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Hiển thị menu khi nhấn vào Text
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(0, 89, 0, 0), // Đặt vị trí menu
                    items: Homes.map((home) {
                      return PopupMenuItem<String>(
                        value: home,
                        child: Text(home),
                      );
                    }).toList(),
                  ).then((selectedValue) {
                    // Xử lý khi người dùng chọn một mục từ menu
                    if (selectedValue != null) {
                      // In ra giá trị của mục đã chọn
                      print('Selected: $selectedValue');
                    }
                  });
                },
                child: Row(
                  children: [
                    Text(
                      'ROLL VILLAS',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 98, 174, 250), // Màu nền cho AppBar
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: PopupMenuButton(
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Page_AddDevice()),
                    );
                  } else if (value == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApps()),
                    );
                  } else if (value == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Page_AddHome()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(Icons.device_hub, color: Colors.deepPurple),
                          SizedBox(width: 10),
                          Text('Thêm thiết bị'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(Icons.scale, color: Colors.orange),
                          SizedBox(width: 10),
                          Text('Thêm cảnh'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(Icons.home, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Thêm nhà'),
                        ],
                      ),
                    ),
                  ];
                },
                icon: 
                Opacity(
                opacity: 0.5, // Độ mờ (0.0 = hoàn toàn trong suốt, 1.0 = không trong suốt)
                child: Icon(
                  Icons.add_circle,
                  size: 36.0,
                  color: Colors.white, // Màu icon
                ),
                )
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blueAccent, // Màu khi mục được chọn
          unselectedItemColor: Colors.grey, // Màu khi mục không được chọn
          backgroundColor: Colors.white, // Màu nền của thanh điều hướng
          type: BottomNavigationBarType.fixed, // Để các biểu tượng đều nằm trên cùng một hàng
          selectedFontSize: 14, // Kích thước font khi mục được chọn
          unselectedFontSize: 12, // Kích thước font khi mục không được chọn
          elevation: 10, // Tạo bóng đổ cho thanh điều hướng
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.favorite, color: Colors.blue),
              icon: Icon(Icons.favorite_border, color: Colors.grey),
              label: 'Yêu thích',
              backgroundColor: Color.fromARGB(255, 100, 145, 235),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home, color: Colors.blue),
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              label: 'Trang chủ',
              backgroundColor: Color.fromARGB(255, 100, 145, 235),
            ),
            BottomNavigationBarItem(
              icon: Badge(
                child: Icon(Icons.auto_awesome, color: Colors.grey),
              ),
              label: 'Hẹn giờ',
              backgroundColor: Color.fromARGB(255, 100, 145, 235),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.settings, color: Colors.blue),
              icon: Badge(
                child: Icon(Icons.settings, color: Colors.grey),
              ),
              label: 'Cài đặt',
              backgroundColor: Color.fromARGB(255, 100, 145, 235),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 98, 174, 250), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: _pages.elementAt(_selectedIndex), //New
          ),
        ),
      )
    );
  }

  void showLoginDialog_handmade(Device device) {
    // Text editing controllers để lấy giá trị nhập vào
    TextEditingController ipController = TextEditingController(text: device.ip);
    TextEditingController nameController = TextEditingController(text: device.name);
    String selectedDeviceType = "Loại thiết bị";
    const double widgetSize = 250;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thông tin thiết bị'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            SizedBox(
              width: widgetSize,
              child: TextField(
                controller: ipController,
                decoration: InputDecoration(
                  labelText: 'Ip',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: widgetSize,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: widgetSize,
              height: 50,
              child:DropdownMenuExample(
                selectedValue: selectedDeviceType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDeviceType = newValue!;
                  });
                },
              ),
            ),
          ]
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Đóng dialog
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              // Xử lý dữ liệu từ các TextField
              String ip = ipController.text;
              String name = nameController.text;
              int type_celected = DeviceType.bulb;
              if (selectedDeviceType == deviceTypes[0]){
                type_celected = DeviceType.bulb;
              }else if (selectedDeviceType == deviceTypes[1]){
                type_celected = DeviceType.rgb;
              }else if (selectedDeviceType == deviceTypes[2]){
                type_celected = DeviceType.door;
              }else if (selectedDeviceType == deviceTypes[3]){
                type_celected = DeviceType.stair;
              }
              // In ra console hoặc xử lý logic khác
              print('Ip: $ip, Name: $name, Type: $type_celected');
              Navigator.pop(context); // Đóng dialog
              Device newDevice = Device(id: device.id ,ip: ip, name: name, type: type_celected, state: device.state);
              dbHelper.updateDevice(newDevice);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: type_horizontal),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: tiles),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Điều hướng hoặc thực hiện hành động tương ứng
      },
    );
  }
}
List<bool> stateDevices = [false, false];
void changerState(int id){
  stateDevices[id] = !stateDevices[id];
}



class PopupMenuExample extends StatefulWidget {
  const PopupMenuExample({super.key});

  @override
  State<PopupMenuExample> createState() => _PopupMenuExampleState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _PopupMenuExampleState extends State<PopupMenuExample> {
  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PopupMenuButton')),
      body: Center(
        child: PopupMenuButton<SampleItem>(
          initialValue: selectedItem,
          onSelected: (SampleItem item) {
            setState(() {
              selectedItem = item;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemOne,
              child: Text('Item 1'),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemTwo,
              child: Text('Item 2'),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemThree,
              child: Text('Item 3'),
            ),
          ],
        ),
      ),
    );
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////