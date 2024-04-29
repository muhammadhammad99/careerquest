import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class TokenManager {
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  static void saveAccessToken(String token) {
    const storage = FlutterSecureStorage();
    storage.write(key: 'accessToken', value: token);
  }

  static void deleteAccessToken() async {
    await storage.delete(key: 'accessToken');
  }
}

class GlobalMethod {

  static void showErrorDialog(
      {required String error, required BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Error Occurred',
                  ),
                ),
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
