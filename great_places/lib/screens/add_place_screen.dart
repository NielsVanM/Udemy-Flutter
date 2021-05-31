import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add_place/";

  AddPlaceScreen({Key key}) : super(key: key);

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  TextEditingController _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _placeLocation;

  void _selectImage(File file) {
    _pickedImage = file;
  }

  void _selectLocation(double lat, double lon) {
    _placeLocation = PlaceLocation(lat: lat, lon: lon);
    print(_placeLocation);
  }

  void _save(BuildContext context) {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _placeLocation == null) {
      return;
    }

    Provider.of<PlacesProvider>(context, listen: false).add(
      Place(
        id: DateTime.now().toString(),
        image: _pickedImage,
        title: _titleController.text,
        location: _placeLocation,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      controller: _titleController,
                    ),
                    SizedBox(height: 10),
                    ImageInput(
                      saveImage: _selectImage,
                    ),
                    SizedBox(height: 10),
                    LocationInput(
                      saveLocation: _selectLocation,
                    ),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
            onPressed: () => _save(context),
          ),
        ],
      ),
    );
  }
}

class ImageInput extends StatefulWidget {
  final Function saveImage;

  ImageInput({Key key, this.saveImage}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    PickedFile pf = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    setState(() {
      _storedImage = File(pf.path);
    });

    var baseDir = await getApplicationDocumentsDirectory();
    var fileName = basename(_storedImage.path);
    var savedImage = await _storedImage.copy('${baseDir.path}/$fileName');

    widget.saveImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(_storedImage, fit: BoxFit.cover)
              : Text("No Image Picked", textAlign: TextAlign.center),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Take Picture"),
            color: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        )
      ],
    );
  }
}

class LocationInput extends StatefulWidget {
  final Function saveLocation;

  LocationInput({Key key, this.saveLocation}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  double _lon;
  double _lat;

  bool _retrievingLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _retrievingLocation = true;
    });
    LocationData locData = await Location().getLocation();
    setState(() {
      _lon = locData.longitude;
      _lat = locData.latitude;
    });
    widget.saveLocation(locData.latitude, locData.longitude);

    setState(() {
      _retrievingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _lon == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Row(
                  children: [
                    Text(
                      "Lat: ${_lat}",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Lon: ${_lon}",
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _retrievingLocation
                ? CircularProgressIndicator()
                : FlatButton.icon(
                    icon: Icon(Icons.location_on),
                    label: Text('Current Location'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _getCurrentLocation,
                  ),
          ],
        )
      ],
    );
  }
}
