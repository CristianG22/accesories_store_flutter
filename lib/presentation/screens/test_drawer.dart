import 'package:flutter/material.dart';

class TestDrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Drawer')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Header')),
            ListTile(
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(child: Text('Body')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.home),
        onPressed: () {},
      ),
    );
  }
} 