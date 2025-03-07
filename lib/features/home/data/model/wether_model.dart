// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     late weather = weatherFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  late Coord? coord;
  late List<WeatherElement?> weather;
  late String? base;
  late Main? main;
  late int? visibility;
  late Wind? wind;
  late Clouds? clouds;
  late int? dt;
  late Sys? sys;
  late int? timezone;
  late int? id;
  late String? name;
  late int? cod;

  Weather({
    this.coord,
    required this.weather,
    this.base = "",
    this.main,
    this.visibility = 0,
    this.wind,
    this.clouds,
    this.dt = 0,
    this.sys,
    this.timezone = 0,
    this.id = 0,
    this.name = "",
    this.cod = 0,
  });

  Weather copyWith({
    Coord? coord,
    List<WeatherElement?>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Clouds? clouds,
    int? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) {
    return Weather(
      coord: coord ?? this.coord,
      weather: weather ?? this.weather,
      base: base ?? this.base,
      main: main ?? this.main,
      visibility: visibility ?? this.visibility,
      wind: wind ?? this.wind,
      clouds: clouds ?? this.clouds,
      dt: dt ?? this.dt,
      sys: sys ?? this.sys,
      timezone: timezone ?? this.timezone,
      id: id ?? this.id,
      name: name ?? this.name,
      cod: cod ?? this.cod,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coord': coord?.toMap(),
      'weather': weather.map((x) => x?.toMap()).toList(),
      'base': base,
      'main': main?.toMap(),
      'visibility': visibility,
      'wind': wind?.toMap(),
      'clouds': clouds?.toMap(),
      'dt': dt,
      'sys': sys?.toMap(),
      'timezone': timezone,
      'id': id,
      'name': name,
      'cod': cod,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      coord: map['coord'] != null
          ? Coord.fromMap(map['coord'] as Map<String, dynamic>)
          : null,
      weather: List<WeatherElement?>.from(
        (map['weather'] as List<int>).map<WeatherElement?>(
          (x) => WeatherElement.fromMap(x as Map<String, dynamic>),
        ),
      ),
      base: map['base'] != null ? map['base'] as String : null,
      main: map['main'] != null
          ? Main.fromMap(map['main'] as Map<String, dynamic>)
          : null,
      visibility: map['visibility'] != null ? map['visibility'] as int : null,
      wind: map['wind'] != null
          ? Wind.fromMap(map['wind'] as Map<String, dynamic>)
          : null,
      clouds: map['clouds'] != null
          ? Clouds.fromMap(map['clouds'] as Map<String, dynamic>)
          : null,
      dt: map['dt'] != null ? map['dt'] as int : null,
      sys: map['sys'] != null
          ? Sys.fromMap(map['sys'] as Map<String, dynamic>)
          : null,
      timezone: map['timezone'] != null ? map['timezone'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      cod: map['cod'] != null ? map['cod'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Weather(coord: $coord, weather: $weather, base: $base, main: $main, visibility: $visibility, wind: $wind, clouds: $clouds, dt: $dt, sys: $sys, timezone: $timezone, id: $id, name: $name, cod: $cod)';
  }

  @override
  bool operator ==(covariant Weather other) {
    if (identical(this, other)) return true;

    return other.coord == coord &&
        listEquals(other.weather, weather) &&
        other.base == base &&
        other.main == main &&
        other.visibility == visibility &&
        other.wind == wind &&
        other.clouds == clouds &&
        other.dt == dt &&
        other.sys == sys &&
        other.timezone == timezone &&
        other.id == id &&
        other.name == name &&
        other.cod == cod;
  }

  @override
  int get hashCode {
    return coord.hashCode ^
        weather.hashCode ^
        base.hashCode ^
        main.hashCode ^
        visibility.hashCode ^
        wind.hashCode ^
        clouds.hashCode ^
        dt.hashCode ^
        sys.hashCode ^
        timezone.hashCode ^
        id.hashCode ^
        name.hashCode ^
        cod.hashCode;
  }
}

class Clouds {
  late int? all;
  Clouds({
    this.all = 0,
  });

  Clouds copyWith({
    int? all,
  }) {
    return Clouds(
      all: all ?? this.all,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'all': all,
    };
  }

  factory Clouds.fromMap(Map<String, dynamic> map) {
    return Clouds(
      all: map['all'] != null ? map['all'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Clouds.fromJson(String source) =>
      Clouds.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Clouds(all: $all)';

  @override
  bool operator ==(covariant Clouds other) {
    if (identical(this, other)) return true;

    return other.all == all;
  }

  @override
  int get hashCode => all.hashCode;
}

class Coord {
  late double? lon;
  late double? lat;
  Coord({
    this.lon = 0.0,
    this.lat = 0.0,
  });

  Coord copyWith({
    double? lon,
    double? lat,
  }) {
    return Coord(
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lon': lon,
      'lat': lat,
    };
  }

  factory Coord.fromMap(Map<String, dynamic> map) {
    return Coord(
      lon: map['lon'] != null ? map['lon'] as double : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coord.fromJson(String source) =>
      Coord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Coord(lon: $lon, lat: $lat)';

  @override
  bool operator ==(covariant Coord other) {
    if (identical(this, other)) return true;

    return other.lon == lon && other.lat == lat;
  }

  @override
  int get hashCode => lon.hashCode ^ lat.hashCode;
}

class Main {
  late double? temp;
  late double? feelsLike;
  late double? tempMin;
  late double? tempMax;
  late int? pressure;
  late int? humidity;
  late int? seaLevel;
  late int? grndLevel;
  Main({
    this.temp = 0.0,
    this.feelsLike = 0.0,
    this.tempMin = 0.0,
    this.tempMax = 0.0,
    this.pressure = 0,
    this.humidity = 0,
    this.seaLevel = 0,
    this.grndLevel = 0,
  });

  Main copyWith({
    double? temp,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,
    int? seaLevel,
    int? grndLevel,
  }) {
    return Main(
      temp: temp ?? this.temp,
      feelsLike: feelsLike ?? this.feelsLike,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      pressure: pressure ?? this.pressure,
      humidity: humidity ?? this.humidity,
      seaLevel: seaLevel ?? this.seaLevel,
      grndLevel: grndLevel ?? this.grndLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temp': temp,
      'feelsLike': feelsLike,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'pressure': pressure,
      'humidity': humidity,
      'seaLevel': seaLevel,
      'grndLevel': grndLevel,
    };
  }

  factory Main.fromMap(Map<String, dynamic> map) {
    return Main(
      temp: map['temp'] != null ? map['temp'] as double : null,
      feelsLike: map['feelsLike'] != null ? map['feelsLike'] as double : null,
      tempMin: map['tempMin'] != null ? map['tempMin'] as double : null,
      tempMax: map['tempMax'] != null ? map['tempMax'] as double : null,
      pressure: map['pressure'] != null ? map['pressure'] as int : null,
      humidity: map['humidity'] != null ? map['humidity'] as int : null,
      seaLevel: map['seaLevel'] != null ? map['seaLevel'] as int : null,
      grndLevel: map['grndLevel'] != null ? map['grndLevel'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Main.fromJson(String source) =>
      Main.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Main(temp: $temp, feelsLike: $feelsLike, tempMin: $tempMin, tempMax: $tempMax, pressure: $pressure, humidity: $humidity, seaLevel: $seaLevel, grndLevel: $grndLevel)';
  }

  @override
  bool operator ==(covariant Main other) {
    if (identical(this, other)) return true;

    return other.temp == temp &&
        other.feelsLike == feelsLike &&
        other.tempMin == tempMin &&
        other.tempMax == tempMax &&
        other.pressure == pressure &&
        other.humidity == humidity &&
        other.seaLevel == seaLevel &&
        other.grndLevel == grndLevel;
  }

  @override
  int get hashCode {
    return temp.hashCode ^
        feelsLike.hashCode ^
        tempMin.hashCode ^
        tempMax.hashCode ^
        pressure.hashCode ^
        humidity.hashCode ^
        seaLevel.hashCode ^
        grndLevel.hashCode;
  }
}

class Sys {
  late int? type;
  late int? id;
  late String? country;
  late int? sunrise;
  late int? sunset;
  Sys({
    this.type = 0,
    this.id = 0,
    this.country = "",
    this.sunrise = 0,
    this.sunset = 0,
  });

  Sys copyWith({
    int? type,
    int? id,
    String? country,
    int? sunrise,
    int? sunset,
  }) {
    return Sys(
      type: type ?? this.type,
      id: id ?? this.id,
      country: country ?? this.country,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'id': id,
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }

  factory Sys.fromMap(Map<String, dynamic> map) {
    return Sys(
      type: map['type'] != null ? map['type'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
      country: map['country'] != null ? map['country'] as String : null,
      sunrise: map['sunrise'] != null ? map['sunrise'] as int : null,
      sunset: map['sunset'] != null ? map['sunset'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sys.fromJson(String source) =>
      Sys.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sys(type: $type, id: $id, country: $country, sunrise: $sunrise, sunset: $sunset)';
  }

  @override
  bool operator ==(covariant Sys other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.id == id &&
        other.country == country &&
        other.sunrise == sunrise &&
        other.sunset == sunset;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        id.hashCode ^
        country.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode;
  }
}

class WeatherElement {
  late int? id;
  late String? main;
  late String? description;
  late String? icon;
  WeatherElement({
    this.id = 0,
    this.main = "",
    this.description = "",
    this.icon = "",
  });

  WeatherElement copyWith({
    int? id,
    String? main,
    String? description,
    String? icon,
  }) {
    return WeatherElement(
      id: id ?? this.id,
      main: main ?? this.main,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }

  factory WeatherElement.fromMap(Map<String, dynamic> map) {
    return WeatherElement(
      id: map['id'] != null ? map['id'] as int : null,
      main: map['main'] != null ? map['main'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherElement.fromJson(String source) =>
      WeatherElement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WeatherElement(id: $id, main: $main, description: $description, icon: $icon)';
  }

  @override
  bool operator ==(covariant WeatherElement other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.main == main &&
        other.description == description &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^ main.hashCode ^ description.hashCode ^ icon.hashCode;
  }
}

class Wind {
  late double? speed;
  late int? deg;
  Wind({
    this.speed = 0.0,
    this.deg = 0,
  });

  Wind copyWith({
    double? speed,
    int? deg,
  }) {
    return Wind(
      speed: speed ?? this.speed,
      deg: deg ?? this.deg,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'speed': speed,
      'deg': deg,
    };
  }

  factory Wind.fromMap(Map<String, dynamic> map) {
    return Wind(
      speed: map['speed'] != null ? map['speed'] as double : null,
      deg: map['deg'] != null ? map['deg'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wind.fromJson(String source) =>
      Wind.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Wind(speed: $speed, deg: $deg)';

  @override
  bool operator ==(covariant Wind other) {
    if (identical(this, other)) return true;

    return other.speed == speed && other.deg == deg;
  }

  @override
  int get hashCode => speed.hashCode ^ deg.hashCode;
}
