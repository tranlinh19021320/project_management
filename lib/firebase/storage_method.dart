import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String folderName,String username, Uint8List image) async{
    Reference ref = _storage.ref().child(folderName).child(username);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snap = await uploadTask;
    String url = await snap.ref.getDownloadURL();

    return url;
  }
}