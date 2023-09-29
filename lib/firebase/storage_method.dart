import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage({required String folderName,required String username,
      String? imageReport,required Uint8List image}) async {
    Reference ref = (imageReport == null)
        ? _storage.ref().child(folderName).child(username)
        : _storage.ref().child(folderName).child(username).child(imageReport);
    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snap = await uploadTask;
    String url = await snap.ref.getDownloadURL();

    return url;
  }
}
