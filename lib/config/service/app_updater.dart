import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ota_update/ota_update.dart';
import 'dart:convert';

class AppUpdater {
  final String backendUrl = 'https://tu-backend.com/api/version';
  final String apkDownloadUrl = 'https://tu-backend.com/api/download-apk';

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final response = await http.post(
        Uri.parse(backendUrl),
        body: {'current_version': currentVersion},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String latestVersion = data['latest_version'];
        bool updateRequired = data['update_required'];

        if (updateRequired && _isNewerVersion(currentVersion, latestVersion)) {
          _showUpdateDialog(context, latestVersion);
        }
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  bool _isNewerVersion(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  void _showUpdateDialog(BuildContext context, String newVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Nueva versión disponible'),
        content: Text('Versión $newVersion está disponible. ¿Deseas actualizar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Después'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadAndInstallApk(context);
            },
            child: Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstallApk(BuildContext context) async {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      
      if (storageStatus.isGranted || storageStatus.isLimited) {
        try {
          // OTA Update descarga e instala automáticamente con progreso
          OtaUpdate()
              .execute(
            apkDownloadUrl,
            destinationFilename: 'app-update.apk',
          )
              .listen(
            (OtaEvent event) {
              print('OTA Status: ${event.status} - ${event.value}');
              
              if (event.status == OtaStatus.DOWNLOADING) {
                // Mostrar progreso
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          value: event.value != null 
                              ? double.parse(event.value!) / 100 
                              : null,
                        ),
                        SizedBox(height: 16),
                        Text('Descargando: ${event.value ?? 0}%'),
                      ],
                    ),
                  ),
                );
              } else if (event.status == OtaStatus.INSTALLING) {
                Navigator.pop(context); // Cerrar diálogo de progreso
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Instalando actualización...')),
                );
              } else if (event.status == OtaStatus.ALREADY_RUNNING_ERROR) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ya hay una descarga en curso')),
                );
              } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Permisos denegados')),
                );
              }
            },
            onError: (error) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $error')),
              );
            },
          );
          
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permisos necesarios denegados')),
        );
      }
    }
  }
}