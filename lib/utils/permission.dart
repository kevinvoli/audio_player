import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission(BuildContext context) async {
  if (await Permission.manageExternalStorage.isGranted) return true;

  var status = await Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Permission de stockage refusée")),
    );
    await openAppSettings();
    return false;
  }
  return true;
}
