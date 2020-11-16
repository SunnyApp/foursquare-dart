import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Location {
  final double lat;
  final double lon;

  const Location({
    this.lat,
    this.lon,
  });

  factory Location.nullable({double lat, double lon}) {
    return (lat != null && lon != null) ? Location(lat: lat, lon: lon) : null;
  }

  @override
  String toString() {
    return '$lat,$lon';
  }
}

extension LocationExt on Location {
  String get value => this == null ? null : '$lat,$lon';
}

typedef FoursquareLocationProvider = FutureOr<Location> Function();

class Foursquare {
  static const defaultVersion = '20190101';
  static const defaultTimeoutDuration = Duration(seconds: 5);
  final String authParameters;
  final bool isAuthed;
  final Duration defaultTimeout;
  final String version;
  final FoursquareLocationProvider locationProvider;

  Foursquare.userless(
      {@required String clientId,
      @required String clientSecret,
      this.version = defaultVersion,
      this.defaultTimeout = defaultTimeoutDuration,
      this.locationProvider})
      : assert(clientId != null),
        assert(clientSecret != null),
        authParameters =
            '?client_id=$clientId&client_secret=$clientSecret&v=$version',
        isAuthed = false;

  Foursquare.authed({
    String accessToken,
    this.version = defaultVersion,
    this.defaultTimeout = defaultTimeoutDuration,
    this.locationProvider,
  })  : authParameters = '?oauth_token=$accessToken&v=$version',
        isAuthed = true;

  const Foursquare._({
    this.authParameters,
    this.isAuthed,
    this.defaultTimeout,
    this.version,
    this.locationProvider,
  });

  Foursquare withLocationProvider(FoursquareLocationProvider location) {
    return copyWith(locationProvider: location);
  }

  // Nullable
  Future<Location> get currentLocation async {
    return await locationProvider?.call();
  }

  Foursquare copyWith({
    String authParameters,
    bool isAuthed,
    Duration defaultTimeout,
    String version,
    FoursquareLocationProvider locationProvider,
  }) {
    return Foursquare._(
      authParameters: authParameters ?? this.authParameters,
      isAuthed: isAuthed ?? this.isAuthed,
      defaultTimeout: defaultTimeout ?? this.defaultTimeout,
      version: version ?? this.version,
      locationProvider: locationProvider ?? this.locationProvider,
    );
  }

  /// Performs a GET request to Foursquare API.
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic> params, Duration timeout}) async {
    var query = (params ?? {})
        .entries
        .where((e) => e.value != null)
        .map((e) => "${e.key}=${Uri.encodeQueryComponent(e.value?.toString())}")
        .join("&");
    if (query.isNotEmpty) query = "&$query";
    var requestUrl =
        'https://api.foursquare.com/v2/$endpoint$authParameters$query';
    final response =
        await http.get(requestUrl).timeout(timeout ?? defaultTimeout);
    if (response.statusCode == 200) {
      return json.decode(response.body)['response'] as Map<String, dynamic>;
    } else {
      try {
        final body = json.decode(response.body);
        throw FoursquareApiException.fromMap(body['meta']);
      } on FoursquareApiException {
        rethrow;
      } catch (e) {
        throw FoursquareApiException(
            code: response.statusCode, errorType: "unknown", errorDetail: "$e");
      }
    }
  }

  // Performs a POST request to Foursquare API.
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, String> params, Duration timeout}) async {
    final response = await http
        .post(
          'https://api.foursquare.com/v2/$endpoint$authParameters',
          body: params,
        )
        .timeout(timeout ?? defaultTimeout);
    if (response.statusCode == 200) {
      return json.decode(response.body)['response'] as Map<String, dynamic>;
    } else {
      try {
        final body = json.decode(response.body);
        throw FoursquareApiException.fromMap(body['meta']);
      } catch (e) {
        throw FoursquareApiException(code: response.statusCode);
      }
    }
  }
}

class FoursquareApiException {
  final int code;
  final String errorType;
  final String errorDetail;
  final String requestId;

  const FoursquareApiException({
    this.code,
    this.errorType,
    this.errorDetail,
    this.requestId,
  });

  factory FoursquareApiException.fromMap(dynamic map) {
    return FoursquareApiException(
      code: map['code'] as int,
      errorType: map['errorType'] as String,
      errorDetail: map['errorDetail'] as String,
      requestId: map['requestId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': this.code,
      'errorType': this.errorType,
      'errorDetail': this.errorDetail,
      'requestId': this.requestId,
    };
  }

  @override
  String toString() {
    return 'FoursquareApiException{code: $code, errorType: $errorType, errorDetail: $errorDetail, requestId: $requestId}';
  }
}
