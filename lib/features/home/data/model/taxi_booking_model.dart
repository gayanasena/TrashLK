// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaxiBookingModel {
  late String userId;
  late String pickupLocation;
  late String dropLocation;
  late String rideType;
  late String dateTime;
  TaxiBookingModel({
    required this.userId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.rideType,
    required this.dateTime,
  });

  TaxiBookingModel copyWith({
    String? userId,
    String? pickupLocation,
    String? dropLocation,
    String? rideType,
    String? dateTime,
  }) {
    return TaxiBookingModel(
      userId: userId ?? this.userId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      rideType: rideType ?? this.rideType,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'rideType': rideType,
      'dateTime': dateTime,
    };
  }

  factory TaxiBookingModel.fromMap(Map<String, dynamic> map) {
    return TaxiBookingModel(
      userId: map['userId'] as String,
      pickupLocation: map['pickupLocation'] as String,
      dropLocation: map['dropLocation'] as String,
      rideType: map['rideType'] as String,
      dateTime: map['dateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaxiBookingModel.fromJson(String source) =>
      TaxiBookingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaxiBookingModel(userId: $userId, pickupLocation: $pickupLocation, dropLocation: $dropLocation, rideType: $rideType, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant TaxiBookingModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.pickupLocation == pickupLocation &&
        other.dropLocation == dropLocation &&
        other.rideType == rideType &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        pickupLocation.hashCode ^
        dropLocation.hashCode ^
        rideType.hashCode ^
        dateTime.hashCode;
  }
}
