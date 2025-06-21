import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/models/alert_model.dart';
import 'package:desh_crime_alert/models/user_model.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

class StreamService {
  static final _db = FirebaseFirestore.instance;
      static final _geo = GeoFlutterFire();

  // Active Emergency Alerts Stream
  static Stream<List<AlertModel>> getActiveAlerts() {
    return _db
        .collection('alerts')
        .where('status', isEqualTo: 'active')
        .where('created_at', isGreaterThan: 
          DateTime.now().subtract(const Duration(hours: 1)))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlertModel.fromFirestore(doc))
            .toList());
  }

  // Nearby Users Stream
  static Stream<List<UserModel>> getNearbyUsers(Position position) {
    // Get users within 5km radius
    final center = _geo.point(
      latitude: position.latitude, 
      longitude: position.longitude
    );
    
    var collectionRef = _db.collection('users');
    return _geo.collection(collectionRef: collectionRef)
        .within(
          center: center, 
          radius: 5, 
          field: 'lastLocation', // This field must store GeoFirePoint data
          strictMode: true
        ).map((snapshot) {
          return snapshot.map((doc) => UserModel.fromFirestore(doc)).toList();
        });
  }
}
