import 'dart:convert';

class Bin {
  final String reference;
  final String location;
  final String type;
  final int capacity;
  final bool inService;
  final double lang;
  final double long;
  final String ownerId;
  final bool isOpen;

  Bin({
    required this.capacity,
    required this.inService,
    required this.lang,
    required this.long,
    required this.location,
    required this.ownerId,
    required this.reference,
    required this.type,
    required this.isOpen,
  });

  // From Map / JSON
  factory Bin.fromMap(Map<String, dynamic> map) {
    return Bin(
      capacity: map['capacity'] ?? 0,
      inService: map['inService'] ?? false,
      lang: (map['lang'] ?? 0).toDouble(),
      long: (map['long'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      ownerId: map['ownerId'] ?? '',
      reference: map['reference'] ?? '',
      type: map['type'] ?? '',
      isOpen: map['isOpen'] ?? false,
    );
  }

  // To Map / JSON
  Map<String, dynamic> toMap() {
    return {
      'capacity': capacity,
      'inService': inService,
      'lang': lang,
      'long': long,
      'location': location,
      'ownerId': ownerId,
      'reference': reference,
      'type': type,
      'isOpen': isOpen,
    };
  }

  // From JSON string
  factory Bin.fromJson(String source) => Bin.fromMap(json.decode(source));

  // To JSON string
  String toJson() => json.encode(toMap());
}
