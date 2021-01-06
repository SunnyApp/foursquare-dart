import 'package:foursquare/src/checkin.dart';
import 'package:foursquare/src/user.dart';
import 'package:foursquare/src/venue.dart';

import 'foursquare.dart';

class UserApi {
  final Foursquare api;

  static const self = 'self';

  UserApi(this.api) : assert(api != null);

  Future<User> get({userId = UserApi.self}) async {
    return User.fromJson((await api.get('users/$userId'))['user']);
  }

  Future<List<User>> friends({userId = UserApi.self}) async {
    List items = (await api.get(
      'users/$userId/friends',
      params: {'limit': 10000},
    ))['friends']['items'] as List;
    return items.map((item) => User.fromJson(item)).toList();
  }

  Future<List<Checkin>> checkins({userId = UserApi.self}) async {
    List items = (await api.get('users/$userId/checkins',
        params: {'limit': 250}))['checkins']['items'] as List;
    return items.map((item) => Checkin.fromJson(item)).toList();
  }
}

enum Intent { checkin, browse, global }

extension IntentExt on Intent {
  String get value {
    switch (this) {
      case Intent.checkin:
        return "checkin";
      case Intent.browse:
        return "browse";
      case Intent.global:
        return "global";
      default:
        throw "Unknown extent";
    }
  }
}

class VenueApi {
  final Foursquare api;

  VenueApi(this.api) : assert(api != null);

  Future<Venue> get(String venueId) async {
    return Venue.fromJson((await api.get('venues/$venueId'))['venue']);
  }

  Future<Location> _resolveLocation(double lat, double lon) async {
    return Location.nullable(lat: lat, lon: lon) ?? await api.currentLocation;
  }

  Future<List<FoursquareCategory>> categories() async {
    List items = (await api.get('venues/categories'))['categories'] as List;
    return items.map((item) => FoursquareCategory.fromJson(item)).toList();
  }

  Future<List<Venue>> search(
      {double lat,
      String query,
      double lon,
      String near,
      int limit,
      double radius = 999999,
      Intent intent = Intent.browse,
      Map<String, String> parameters = const {}}) async {
    /// Use passed in location, or attempt to get current location
    final loc = await _resolveLocation(lat, lon);
    List items = (await api.get('venues/search', params: {
      if (limit != null) 'limit': '$limit',
      if (near == null) 'll': loc.value else 'near': near,
      'intent': intent.value,
      'query': query,
      'radius': radius,
      ...?parameters,
    }))['venues'] as List;
    return items.map((item) => Venue.fromJson(item)).toList();
  }

  Future<Venue> current({double lat, double lon}) async {
    return (await search(lat: lat, lon: lon, limit: 1)).firstWhere(
      (element) => true,
      orElse: () => null,
    );
  }

  Future<List<Venue>> recommendations(
      {double latitude,
      double longitude,
      Map<String, String> params = const {}}) async {
    final loc = await _resolveLocation(latitude, longitude);

    List items = (await api.get('search/recommendations', params: {
      'll': loc.value,
      ...?params,
    }))['group']['results'] as List;
    return items.map((item) => Venue.fromJson(item['venue'])).toList();
  }

  Future<List<Venue>> liked({userId = 'self'}) async {
    List items = (await api.get('lists/$userId/venuelikes',
        params: {'limit': '10000'}))['list']['listItems']['items'] as List;
    return items
        .where((item) => item['type'] == 'venue')
        .map((item) => Venue.fromJson(item['venue']))
        .toList();
  }

  Future<List<Venue>> saved({userId = 'self'}) async {
    List items =
        (await api.get('lists/$userId/todos', params: {'limit': 10000}))['list']
            ['listItems']['items'] as List;
    return items
        .where((item) => item['type'] == 'venue')
        .map((item) => Venue.fromJson(item['venue']))
        .toList();
  }
}

extension FoursquareApiMethods on Foursquare {
  VenueApi get venues => VenueApi(this);

  UserApi get users => UserApi(this);
}
