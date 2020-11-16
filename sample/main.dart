import 'package:foursquare/foursquare.dart';

Future main() async {
  // Used for userless requests
  Foursquare userless = Foursquare.userless(
    clientId: 'FOURSQUARE_CLIENT_ID',
    clientSecret: 'FOURSQUARE_CLIENT_SECRET',
  );

  // Used for authenticated requests
  Foursquare authed = Foursquare.authed(accessToken: 'OAUTH_ACCESS_TOKEN');

  Venue current = await userless.venues.current(lat: 43.6532, lon: -79.3832);

  Foursquare locationAware = userless.withLocationProvider(() {
    /// This could use a device to provide location info each time.
    return Location(lat: 33, lon: -111.45432);
  });

  /// This call doesn't need the lat/lng provided, because it gets it from the location
  /// provider
  Venue current2 = await locationAware.venues.current();

  print('I am at ${current.name}.');

  User self = await authed.users.get();
  print('I am ${self.firstName} ${self.lastName}.');
}
