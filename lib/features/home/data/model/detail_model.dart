// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

class CommonDetailModel {
  final String id;
  final String title;
  final String? location;
  final String? subLocation;
  final String? category;
  final String? price;
  final double? percentage;
  final List<String>? imageUrls;
  final String? description;
  final String? notes;
  final bool? isFlag;
  final String? url_1;
  final String? url_2;
  final String? uId;
  final String? BUId;

  CommonDetailModel({
    required this.id,
    required this.title,
    this.location = "",
    this.subLocation = "",
    this.category = "",
    this.price = "",
    this.percentage = 0.0,
    this.imageUrls = const [],
    this.description = "",
    this.notes = "",
    this.isFlag = false,
    this.url_1 = "",
    this.url_2 = "",
    this.uId = "",
    this.BUId = "",
  });

  // Factory method to create a DetailModel from JSON
  factory CommonDetailModel.fromJson(Map<String, dynamic> json) {
    return CommonDetailModel(
      id: json['id'] as String? ?? "", // Ensure non-null
      title: json['title'] as String? ?? "",
      location: json['location']?.toString() ?? "",
      subLocation: json['subLocation']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
      price: json['price']?.toString() ?? "",
      percentage:
          (json['percentage'] as num?)?.toDouble() ?? 0.0, // Safe conversion
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description']?.toString() ?? "",
      notes: json['notes']?.toString() ?? "",
      isFlag: json['isFlag'] as bool? ?? false,
      url_1: json['url_1']?.toString() ?? "",
      url_2: json['url_2']?.toString() ?? "",
      uId: json['uId']?.toString() ?? "",
      BUId: json['BUId']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'subLocation': subLocation,
      'category': category,
      'price': price,
      'percentage': percentage,
      'imageUrls': imageUrls, // This is a List<String>
      'description': description,
      'notes': notes,
      'isFlag': isFlag,
      'url_1': url_1,
      'url_2': url_2,
      'uId': uId,
      'BUId': BUId,
    };
  }
}
