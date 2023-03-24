import 'package:cloud_firestore/cloud_firestore.dart';

class IdService {
  static String generateId() {
    return FirebaseFirestore.instance.collection("id-generator").doc().id;
  }
}
