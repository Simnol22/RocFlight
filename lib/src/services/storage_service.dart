import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageService {
  /// Checks and requests storage permissions.
  /// Returns true if permissions are granted, otherwise false.
  /// To verify. Maybe not necessary with path_provider (seems to work fine without it)
  Future<bool> checkAndRequestStoragePermissions() async {
    // Permissions are granted.
    return true;
  }
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

 /// Gets the user ID if it has been previously set
  Future<void> setUserId(String uid) async {
    final path = await _localPath;
    File uidFile = File('$path/uid.txt');
    uidFile.writeAsStringSync(uid, flush: true);
  }


  /// Gets the user ID if it has been previously set
  Future<String> getUserId() async {
    try{
      final path = await _localPath;
      File uidFile = File('$path/uid.txt');
      final contents = await uidFile.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }
}
