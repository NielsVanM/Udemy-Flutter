import 'package:flutter/material.dart';
import 'package:great_places/providers/places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: Provider.of<PlacesProvider>(context, listen: false).fetch(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? CircularProgressIndicator()
              : Consumer<PlacesProvider>(
                  builder: (context, places, child) => places.items.length <= 0
                      ? child
                      : ListView.builder(
                          itemCount: places.items.length,
                          itemBuilder: (context, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(places.items[i].image),
                            ),
                            title: Text(places.items[i].title),
                            subtitle: Row(
                              children: [
                                Text(
                                  "Lat: ${places.items[i].location.lat}",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Lon: ${places.items[i].location.lon}",
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            ),
                            onTap: () {
                              // TODO: Navigate to detail page
                            },
                          ),
                        ),
                  child: Center(child: Text("Got no places yet.")),
                ),
        ),
      ),
    );
  }
}
