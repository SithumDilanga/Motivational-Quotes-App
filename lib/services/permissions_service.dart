import 'package:permission_handler/permission_handler.dart';

class PermissionsService {

  final PermissionHandler permissionHandler = PermissionHandler();


  // requesting permission of what we want
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }    
    return false;
  }

  // asking particular permission
  Future<bool> requestStoragePermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.storage);
    if (!granted) { // if permission is declined it shpuld ask again when it needs
      onPermissionDenied();  // get called when the user declines permission 
    }
    return granted;
  }

  // dedicated functions for specific permissions
  Future<bool> hasContactsPermission() async {
    return hasPermission(PermissionGroup.storage);
  }

  // checking whether user already given the permission
  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }

  

}