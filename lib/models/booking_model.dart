import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, ongoing, completed, cancelled }

class BookingModel {
  final String orderId;
  final String renterId;
  final String bikeId;
  final DateTime startDate;
  final DateTime endDate;
  final BookingStatus status;
  final double totalCost;
  final String? renterReviewId;  // Added to link with reviews
  final String? ownerReviewId;   // Added to link with reviews
  final DateTime createdAt;
  final DateTime? cancelledAt;

  BookingModel({
    required this.orderId,
    required this.renterId,
    required this.bikeId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalCost,
    this.renterReviewId,
    this.ownerReviewId,
    required this.createdAt,
    this.cancelledAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'renterId': renterId,
      'bikeId': bikeId,
      'startDate': startDate,
      'endDate': endDate,
      'status': status.toString(),
      'totalCost': totalCost,
      'renterReviewId': renterReviewId,
      'ownerReviewId': ownerReviewId,
      'createdAt': createdAt,
      'cancelledAt': cancelledAt,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      orderId: map['orderId'],
      renterId: map['renterId'],
      bikeId: map['bikeId'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
      ),
      totalCost: map['totalCost'].toDouble(),
      renterReviewId: map['renterReviewId'],
      ownerReviewId: map['ownerReviewId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      cancelledAt: map['cancelledAt'] != null 
          ? (map['cancelledAt'] as Timestamp).toDate() 
          : null,
    );
  }
}
