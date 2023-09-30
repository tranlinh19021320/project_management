import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage({required String folderNamev1,required String folderNamev2,
      String? folderNamev3,required Uint8List image}) async {
    Reference ref = (folderNamev3 == null)
        ? _storage.ref().child(folderNamev1).child(folderNamev2)
        : _storage.ref().child(folderNamev1).child(folderNamev2).child(folderNamev3);
    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snap = await uploadTask;
    String url = await snap.ref.getDownloadURL();

    return url;
  }
}
