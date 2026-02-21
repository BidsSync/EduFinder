import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_schools.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection name
  static const String schoolsCollection = 'schools';

  // Seed data function - Call this once to populate your database
  Future<void> seedInitialData() async {
    final batch = _db.batch();
    
    for (var school in mockUkSchools) {
      final docRef = _db.collection(schoolsCollection).doc(school.id);
      batch.set(docRef, {
        'name': school.name,
        'type': school.type,
        'address': school.address,
        'course': school.course,
        'feeRate': school.feeRate,
        'lat': school.lat,
        'lng': school.lng,
        'rating': school.rating,
        'city': school.city,
        'description': school.description,
        'id': school.id,
        'imageUrl': school.imageUrl,
      });
    }

    await batch.commit();
    print('✅ Firestore seeded with ${mockUkSchools.length} schools');
  }

  // Get all schools
  Stream<List<School>> getSchools() {
    return _db.collection(schoolsCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return School(
          id: data['id'] ?? doc.id,
          name: data['name'] ?? '',
          type: data['type'] ?? '',
          address: data['address'] ?? '',
          course: data['course'] ?? '',
          feeRate: (data['feeRate'] as num?)?.toDouble() ?? 0.0,
          lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
          lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          city: data['city'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    });
  }
}
