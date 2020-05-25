import 'package:flutter/material.dart';
import 'package:qr_app/src/bloc/scans_bloc.dart';
import 'package:qr_app/src/models/scan_model.dart';
import 'package:qr_app/src/utils/utils.dart';

class MapsPage extends StatelessWidget {
final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final scans = snapshot.data;
        if (scans.length == 0) {
          return Center(
            child: Text('No hay informacion'),
          );
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
              child: ListTile(
                leading: Icon(Icons.map,
                    color: Theme.of(context).primaryColor),
                title: Text(scans[i].valor),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () => openScan(context, scans[i]),
              ),
            );
          },
        );
      },
    );
  }
}
