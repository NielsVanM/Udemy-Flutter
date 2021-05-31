import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/models/place.dart';
import 'package:location/location.dart';

class PlacesProvider extends ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> fetch() async {
    var data = await DBHelper.get('user_places');

    _items = data
        .map((e) => Place(
              id: e['id'],
              title: e['title'],
              image: File(e['image']),
              location: PlaceLocation(lat: e['lat'], lon: e['lon']),
            ))
        .toList();

    notifyListeners();
  }

  void add(Place p) {
    _items.add(p);
    notifyListeners();

    DBHelper.insert(
      'user_places',
      {
        'id': p.id,
        'title': p.title,
        'image': p.image.path,
        'lat': p.location.lat,
        'lon': p.location.lon
      },
    );
  }

  void remove(Place p) {
    _items.removeWhere((element) => element.id == p.id);
    notifyListeners();
  }
}
