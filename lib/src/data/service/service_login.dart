import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tmoto_passenger/src/data/model/passenger.dart';
import 'package:tmoto_passenger/src/utils/database_tables.dart';
import 'package:tmoto_passenger/src/utils/network_response.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> verifyOTPCode(String code, String verificationId) async {
    try {
      final PhoneAuthCredential authCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

      final UserCredential userCredential = await _auth.signInWithCredential(authCredential);
      return userCredential.user?.uid ?? null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<String?> verifyOTPCodeWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user?.uid ?? null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<NetworkResponse<Passenger?>> get checkExistence async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection(DatabaseTable.passenger)
          .where("phone", isEqualTo: _auth.currentUser?.phoneNumber ?? "")
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final String reference = snapshot.docs.first.id;
        final Map<String, dynamic> map = snapshot.docs.first.data();
        map.addAll({"reference": reference});
        final Passenger passenger = Passenger.fromMap(map);
        return NetworkResponse(result: passenger, success: true);
      }
      return NetworkResponse(result: null, success: true, error: "New user");
    } catch (error) {
      print(error);
      return NetworkResponse(result: null, success: false, error: error.toString());
    }
  }
}
