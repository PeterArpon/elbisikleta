import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String bikeId;
  final String renterId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  ReviewModel({
    required this.reviewId,
    required this.bikeId,
    required this.renterId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'bikeId': bikeId,
      'renterId': renterId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['reviewId'],
      bikeId: map['bikeId'],
      renterId: map['renterId'],
      rating: map['rating'].toDouble(),
      comment: map['comment'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}