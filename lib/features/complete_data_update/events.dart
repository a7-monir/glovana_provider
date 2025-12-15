part of 'bloc.dart';

class CompleteDataUpdateEvents {}

class CompleteDataUpdateEvent extends CompleteDataUpdateEvents {
  final List<ProviderType> providerTypes;
  final int providerId;

  CompleteDataUpdateEvent({required this.providerTypes,required this.providerId});
}

class ProviderType {
  final int? id;
  final int? providerId;
  final int? typeId;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final String address;
  final String workNumber,bookingType;
  final double? pricePerHour;
  final List<Map<String, dynamic>>? servicesWithPrices;

// final bool isVip;
  final List<int>? serviceIds;
  final File? images;
  final List<File> gallery;
  final List<String>? deletedImages;
  final List<String>? deletedGalleries;
  final List<Availability> availability;

  File? identityPhoto;
  File? practicePhoto;

  ProviderType({
    this.id,
    this.typeId,
    this.providerId,
    required this.name,
    required this. bookingType,
    required this.description,
    required this.workNumber,
    required this.lat,
    required this.lng,
    required this.address,
    this.pricePerHour,
    this.servicesWithPrices,
    //  required this.isVip,

    this.serviceIds,
    required this.images,
    required this.gallery,
    required this.availability,
    this.deletedImages,
    this.deletedGalleries,
    this.identityPhoto,
    this.practicePhoto,
  });
}
class Availability {
  int? id;
  int? providerTypeId;
  String? dayOfWeek;
  String? startTime;
  String? endTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  Availability({
    this.id,
    this.providerTypeId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    id: json["id"],
    providerTypeId: json["provider_type_id"],
    dayOfWeek: json["day_of_week"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider_type_id": providerTypeId,
    "day_of_week": dayOfWeek,
    "start_time": startTime,
    "end_time": endTime,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}