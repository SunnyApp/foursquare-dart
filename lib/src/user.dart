import 'api.dart';
import 'checkin.dart';

class User {
  User(
      {this.userId,
      this.firstName,
      this.lastName,
      this.photoPrefix,
      this.photoSuffix,
      this.homeCity});

  final String userId;
  final String firstName;
  final String lastName;
  final String photoPrefix;
  final String photoSuffix;
  final String homeCity;

  factory User.fromJson(map) {
    return User(
      userId: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      photoPrefix: map['photo']['prefix'] as String,
      photoSuffix: map['photo']['suffix'] as String,
      homeCity: map['homeCity'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'photoPrefix': this.photoPrefix,
      'photoSuffix': this.photoSuffix,
      'homeCity': this.homeCity,
    };
  }

  @deprecated
  static Future<User> get(API api, {userId = 'self'}) async {
    return User.fromJson((await api.get('users/$userId'))['user']);
  }

  @deprecated
  static Future<List<User>> friends(API api, {userId = 'self'}) async {
    List items = (await api.get(
        'users/$userId/friends', '&limit=10000'))['friends']['items'] as List;
    return items.map((item) => User.fromJson(item)).toList();
  }

  @deprecated
  static Future<List<Checkin>> checkins(API api, {userId = 'self'}) async {
    List items = (await api.get(
        'users/$userId/checkins', '&limit=250'))['checkins']['items'] as List;
    return items.map((item) => Checkin.fromJson(item)).toList();
  }
}
