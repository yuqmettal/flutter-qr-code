import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/src/pages/maps_page.dart';
import 'package:qr_app/src/pages/directions_page.dart';
import 'package:qr_app/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _buildNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQR,
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _buildNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),
        ),
      ],
    );
  }

  _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
      case 1:
        return DirectionsPage();
      default:
        return MapsPage();
    }
  }

  _scanQR() async {
    // https://fernando-herrera.com
    // geo:-2.8917821057165836,-79.00128736933597
    // dynamic futureString = '';
    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    // futureString = e.toString();
    // }
    // print('Future string: ${futureString.rawContent}');
    dynamic futureString = 'https://fernando-herrera.com';
    if (futureString != null) {
      final scan = ScanModel(valor: futureString);
      DBProvider.db.nuevoScan(scan);
    }
  }
}
