import 'dart:async';

import 'package:qr_app/src/models/scan_model.dart';

class Validators {
  final validateGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((element) => element.tipo == 'geo').toList();
      sink.add(geoScans);
    }
  );

  final validateHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((element) => element.tipo == 'http').toList();
      sink.add(geoScans);
    }
  );
}