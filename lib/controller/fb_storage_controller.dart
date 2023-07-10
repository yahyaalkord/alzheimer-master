import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:patient_app/firebase_helper.dart';


class FbStorageController with FirebaseHelper {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Reference>> read({required String id}) async {
    ListResult listResult = await _storage.ref('images').list();
    List<Reference> filteredItems = [];
    for (Reference ref in listResult.items) {
      if (ref.name.contains(id)) {
        filteredItems.add(ref);
      }
    }
    if (filteredItems.isNotEmpty) {
      return filteredItems;
    }else{
      return [];
    }

  }



}
