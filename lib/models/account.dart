import 'package:flutter/material.dart';

class AccountManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý tài khoản"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 40,
                child: const Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(height: 20),
            isLandscape
                ? Row(
                    children: [
                      Expanded(child: _buildTextField('Họ và tên', 'tuyen', Icons.edit)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField('Số điện thoại', '', Icons.edit)),
                    ],
                  )
                : Column(
                    children: [
                      _buildTextField('Họ và tên', 'tuyen', Icons.edit),
                      const SizedBox(height: 16),
                      _buildTextField('Số điện thoại', '', Icons.edit),
                    ],
                  ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'tuyendoactive@gmail.com',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến trang đổi mật khẩu
              },
              child: const Text('Đổi mật khẩu'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Đăng xuất
              },
              child: const Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Thực hiện hành động khi nhấn vào icon edit
          },
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
