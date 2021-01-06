import 'package:flutter/material.dart';

class FoursquareLocation {
  final String address; // = "891 N Higley Rd"
  final String crossStreet; // = "Guadalupe"
  final double lat; // = 33.366570672685384
  final double lng; // = -111.72017133486581
// "labeledLatLngs": [
// {
// final label; // = "display"
// final lat; // = 33.366570672685384
// "lng": -111.72017133486581
// }
// ],
  final String postalCode; // = "85234"
  final String cc; // = "US"
  final String city; // = "Gilbert"
  final String state; // = "AZ"
  final String country; // = "United States"
  final List<String> formattedAddress;

  factory FoursquareLocation.of(map) {
    if (map is FoursquareLocation) return map;
    return FoursquareLocation.fromMap(map as Map<String, dynamic>);
  }

  const FoursquareLocation({
    @required this.address,
    @required this.crossStreet,
    @required this.lat,
    @required this.lng,
    @required this.postalCode,
    @required this.cc,
    @required this.city,
    @required this.state,
    @required this.country,
    @required this.formattedAddress,
  });

  factory FoursquareLocation.fromMap(Map<String, dynamic> map) {
    return FoursquareLocation(
      address: map['address'] as String,
      crossStreet: map['crossStreet'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      postalCode: map['postalCode'] as String,
      cc: map['cc'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
      formattedAddress: (map['formattedAddress'] as List).cast(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'address': this.address,
      'crossStreet': this.crossStreet,
      'lat': this.lat,
      'lng': this.lng,
      'postalCode': this.postalCode,
      'cc': this.cc,
      'city': this.city,
      'state': this.state,
      'country': this.country,
      'formattedAddress': this.formattedAddress,
    } as Map<String, dynamic>;
  }

// : [
// "891 N Higley Rd (Guadalupe)",
// "Gilbert, AZ 85234",
// "United States"
// ]

}

class Venue {
  final String id; // = "4cbe4f1eca4aa1cdeeb713b4"
  final String name; // = "Rancho de Tia Rosa"
  final FoursquareLocation location;
  final List<FoursquareCategory> categories;

// : [
// {
//
// }
// ],
  final FoursquareVenuePage venuePage;

// final lFou"venuePage": {
// "id": "76729800"
// },
  final String referralId; // = "v-1605253589"
  final bool hasPerk;

  const Venue({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.categories,
    @required this.venuePage,
    @required this.referralId,
    @required this.hasPerk,
  });

  static Venue fromJson(map) {
    return Venue(
      id: map['id'] as String,
      name: map['name'] as String,
      location: FoursquareLocation.of(map['location']),
      categories: FoursquareCategory.fromList(map['categories']),
      venuePage: FoursquareVenuePage.fromJson(map['venuePage']),
      referralId: map['referralId'] as String,
      hasPerk: map['hasPerk'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'location': this.location,
      'categories': this.categories,
      'venuePage': this.venuePage,
      'referralId': this.referralId,
      'hasPerk': this.hasPerk,
    } as Map<String, dynamic>;
  }

  static List<Venue> listOf(resp) {
    resp ??= [];
    assert(resp is List);
    final list = resp as List;
    return list.map(Venue.fromJson).toList();
  }

//: false
}

class FoursquareVenuePage {
  final String id;

  const FoursquareVenuePage({@required this.id});

  factory FoursquareVenuePage.fromMap(Map<String, dynamic> map) {
    return FoursquareVenuePage(
      id: map['id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
    };
  }

  static FoursquareVenuePage fromJson(dynamic map) {
    if (map == null) return null;
    return FoursquareVenuePage(id: map["id"] as String);
  }

  static List<FoursquareVenuePage> listOf(dynamic list) {
    list ??= [];
    assert(list is List, "Must be a list or null");
    final source = list as List;
    return source.map(FoursquareVenuePage.fromJson).toList();
  }
}

class FoursquareImage {
  final String prefix;
  final String suffix;

  const FoursquareImage({
    @required this.prefix,
    @required this.suffix,
  });

  static FoursquareImage fromMap(map) {
    return FoursquareImage(
      prefix: map['prefix'] as String,
      suffix: map['suffix'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'prefix': this.prefix,
      'suffix': this.suffix,
    } as Map<String, dynamic>;
  }
}

class FoursquareCategory {
  final String id;
  final String name;
  final String pluralName;
  final String shortName;
  final List<FoursquareCategory> categories;

// = "Mexican"
//   final FoursquareImage icon; //": {
//   final bool primary;

  static FoursquareCategory fromJson(json) {
    if (json != null && json is Map<String, dynamic>) {
      return FoursquareCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        pluralName: json['pluralName'] as String,
        shortName: json['shortName'] as String,
        categories: [
          ...(json['categories'] as List ?? [])
              .map((e) => FoursquareCategory.fromJson(e))
        ],
      );
    } else {
      return null;
    }
  }

  FoursquareCategory(
      {this.id,
      this.name,
      this.pluralName,
      this.shortName,
      this.categories = const []});

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'pluralName': this.pluralName,
      'shortName': this.shortName,
      'categories': this.categories.map((e) => e.toMap()),
    } as Map<String, dynamic>;
  }

  static List<FoursquareCategory> fromList(dynamic d) {
    final l = ((d ?? <dynamic>[]) as List).cast<Map<String, dynamic>>();
    return l.map(FoursquareCategory.fromJson).toList();
  }
}
