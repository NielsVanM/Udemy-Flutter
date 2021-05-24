import 'package:flutter/material.dart';
import 'package:meals/widgets/maindrawer.dart';

class FiltersScreen extends StatefulWidget {
  static String routeName = "/filter/";
  final Function setFilters;
  final Map<String, bool> currentFilters;

  const FiltersScreen({Key key, this.setFilters, this.currentFilters})
      : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  bool _glutenFree = false;
  bool _vegetarian = false;
  bool _vegan = false;
  bool _lactoseFree = false;

  @override
  void initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _vegetarian = widget.currentFilters['vegetarian'];
    _vegan = widget.currentFilters['vegan'];
    _lactoseFree = widget.currentFilters['lactose'];

    super.initState();
  }

  Widget _buildSwitchListTile(String text, bool val, Function updateVal) {
    return SwitchListTile(
      title: Text(text),
      value: val,
      onChanged: updateVal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Filters"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => widget.setFilters({
              'gluten': _glutenFree,
              'lactose': _lactoseFree,
              'vegan': _vegan,
              'vegetarian': _vegetarian,
            }),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text("Adjust your meal selection",
                style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchListTile("Gluten-Free", _glutenFree, (value) {
                  setState(() {
                    _glutenFree = value;
                  });
                }),
                _buildSwitchListTile("Vegetarian", _vegetarian, (value) {
                  setState(() {
                    _vegetarian = value;
                  });
                }),
                _buildSwitchListTile("Vegan", _vegan, (value) {
                  setState(() {
                    _vegan = value;
                  });
                }),
                _buildSwitchListTile("Lactose Free", _lactoseFree, (value) {
                  setState(() {
                    _lactoseFree = value;
                  });
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
