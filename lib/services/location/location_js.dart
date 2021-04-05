@JS('navigator.geolocation') // navigator.geolocation namespace
library jslocation; // library name can be whatever youwant

import "package:js/js.dart";

@JS('getCurrentPosition') // Accessing method

external void getCurrentPosition(Future<void> success(GeolocationPosition pos));

@JS()
@anonymous
class GeolocationCoordinates {
  external double get latitude;
  external double get longitude;

  external factory GeolocationCoordinates({
    double latitude,
    double longitude,
  });
}

@JS()
@anonymous
class GeolocationPosition {
  external GeolocationCoordinates get coords;

  external factory GeolocationPosition({GeolocationCoordinates coords});
}
