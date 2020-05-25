import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_app/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = new MapController();

  String tipoMapa = 'satellite';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scan.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _buildFlutterMap(scan),
      floatingActionButton: _buildFloatingButton(context),
    );
  }

  _buildFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _buildMap(),
        _buildPoints(scan),
      ],
    );
  }

  _buildMap() {
    final String key =
        'pk.eyJ1IjoibXl1cXVpbGltYSIsImEiOiJja2Fsa2FsOGExMHJ6MnFtbmIwazJ0a2xkIn0.pYLYTJxtagFNYcDFBjsM1w';
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': key,
        'id': 'mapbox.$tipoMapa',
      },
    );
  }

  _buildPoints(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100,
          height: 100,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 70,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if ( tipoMapa == 'streets' ) {
          tipoMapa = 'dark';
        } else if ( tipoMapa == 'dark' ) {
          tipoMapa = 'light';
        } else if ( tipoMapa == 'light' ) {
          tipoMapa = 'outdoors';
        } else if ( tipoMapa == 'outdoors' ) {
          tipoMapa = 'satellite';
        } else {
          tipoMapa = 'streets';
        }

        setState((){});
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
