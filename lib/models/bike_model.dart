import 'package:cloud_firestore/cloud_firestore.dart';

class BikeModel {
  final String bikeId;
  final String ownerId;
  final String modelName;
  final String description;
  final List<String> photoUrls;  // Store multiple photo URLs
  final double costPerHour;
  final bool isAvailable;
  final String? location;  // Added for location tracking
  final List<String>? features;  // Added for bike features/specs
  final DateTime createdAt;
  final DateTime updatedAt;

  BikeModel({
    required this.bikeId,
    required this.ownerId,
    required this.modelName,
    required this.description,
    required this.photoUrls,
    required this.costPerHour,
    required this.isAvailable,
    this.location,
    this.features,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BikeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BikeModel(
      bikeId: doc.id,
      ownerId: data['ownerId'],
      modelName: data['modelName'],
      description: data['description'],
      photoUrls: List<String>.from(data['photoUrls']),
      costPerHour: data['costPerHour'],
      isAvailable: data['isAvailable'],
      location: data['location'],
      features: data['features'] != null
          ? List<String>.from(data['features'])
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
