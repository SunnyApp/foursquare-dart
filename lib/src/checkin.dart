class Checkin {
  Checkin(
      {this.checkinId,
      this.type,
      this.createdAt,
      this.private,
      this.shout,
      this.venueId});

  final String checkinId;
  final String type;
  final int createdAt;
  final bool private;
  final String shout;
  final String venueId;

  factory Checkin.fromJson(map) {
    return Checkin(
      checkinId: map['id'] as String,
      type: map['type'] as String,
      createdAt: map['createdAt'] as int,
      private: map['private'] as bool,
      shout: map['shout'] as String,
      venueId: map['venueId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.checkinId,
      'type': this.type,
      'createdAt': this.createdAt,
      'private': this.private,
      'shout': this.shout,
      'venueId': this.venueId,
    };
  }
}
