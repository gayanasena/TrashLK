// ignore_for_file: public_member_api_docs, sort_constructors_first

class DetailModel {
  final String id;
  final String title;
  final String location;
  final String locationCategory;
  final String category;
  final String season;
  final double rating;
  final List<String> imageUrls;
  final String description;
  final String suggestionNote;
  final bool isFavourite;
  final String? mapUrl;
  final String? videoUrl;

  DetailModel({
    required this.id,
    required this.title,
    required this.location,
    required this.locationCategory,
    required this.category,
    required this.season,
    required this.rating,
    required this.imageUrls,
    required this.description,
    required this.suggestionNote,
    required this.isFavourite,
    this.mapUrl,
    this.videoUrl,
  });

  // Factory method to create a DetailModel from JSON
  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      locationCategory: json['locationCategory'] as String,
      category: json['category'] as String,
      season: json['season'] as String,
      rating: (json['rating'] as num).toDouble(), // Ensure it's a double
      imageUrls:
          List<String>.from(json['imageUrls'] ?? []), // List<String> conversion
      description: json['description'] as String,
      suggestionNote: json['suggestionNote'] as String,
      isFavourite: json['isFavourite'] as bool,
      mapUrl: json['mapUrl'] as String?, // Ensure null safety
      videoUrl:
          json['videoUrl'] as String?, // Corrected from mapUrl to videoUrl
    );
  }

  // Convert the object to a Map<String, dynamic> that Firebase can store
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'locationCategory': locationCategory,
      'category': category,
      'season': season,
      'rating': rating,
      'imageUrls': imageUrls, // This is a List<String>
      'description': description,
      'suggestionNote': suggestionNote,
      'isFavourite': isFavourite,
      'mapUrl': mapUrl,
      'videoUrl': videoUrl,
    };
  }
}
