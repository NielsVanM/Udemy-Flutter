import 'dart:io';
import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double lat;
  final double lon;
  final String address;

  PlaceLocation({
    @required this.lat,
    @required this.lon,
    this.address,
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image,
  });

  Place copyWith({
    id,
    title,
    location,
    image,
  }) {
    return Place(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      image: image ?? this.image,
    );
  }
}
