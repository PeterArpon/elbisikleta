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

  Map<String, dynamic> toMap() {
    return {
      'bikeId': bikeId,
      'ownerId': ownerId,
      'modelName': modelName,
      'description': description,
      'photoUrls': photoUrls,
      'costPerHour': costPerHour,
      'isAvailable': isAvailable,
      'location': location,
      'features': features,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory BikeModel.fromMap(Map<String, dynamic> map) {
    return BikeModel(
      bikeId: map['bikeId'],
      ownerId: map['ownerId'],
      modelName: map['modelName'],
      description: map['description'],
      photoUrls: List<String>.from(map['photoUrls']),
      costPerHour: map['costPerHour'].toDouble(),
      isAvailable: map['isAvailable'],
      location: map['location'],
      features: map['features'] != null ? List<String>.from(map['features']) : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }
}
