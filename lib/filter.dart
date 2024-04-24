import 'package:flutter/material.dart';
import "edittime.dart";
import 'package:axorion/axorion.dart';
import "database.dart";
import "UIFactory.dart";

class FilterValue {
  String country;
  String track;
  String carName;

  FilterValue({this.country="",this.track="",this.carName=""});

  bool isEmpty() {
    return country.isEmpty;
  }
}

class Filter extends StatefulWidget {
  Filter({Key? key,required this.db,required this.filterValue}) : super(key: key);

  DirtDatabase db;
  FilterValue filterValue;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> tracks = [];
  List<String> cars = [];
  var insets =  const EdgeInsets.all(8.0);

  @override
  void initState() {
    super.initState();
    tracks.add("");
    cars.add("");
    updateTracks(widget.filterValue.country);
    for(final car in widget.db.cars) {
      cars.add(car.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text("Filter"),
            actions: [
              IconButton(iconSize: 28,icon: const Icon(Icons.clear),onPressed: onClear),
              IconButton(iconSize: 28,icon: const Icon(Icons.save),onPressed: onSave),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
                children: [
                  Padding(padding: insets,child: UIFactory.createRowDropdown("Country", widget.filterValue.country, countrys, onCountry)),
                  Padding(padding: insets,child: UIFactory.createRowDropdown("Track", widget.filterValue.track, tracks, onTrack)),
                  Padding(padding: insets,child: UIFactory.createRowDropdown("Car",widget.filterValue.carName,cars, onCar)),
                ]
            )
        )
    );
  }

  void onSave() {
    Navigator.of(context).pop(true);
  }
  void onCountry(String country) {
    print("Selected $country");
    setState(() {
      widget.filterValue.country = country;
      widget.filterValue.track = "";
      updateTracks(country);
    });
  }

  void updateTracks(String country) {
    tracks.clear();
    tracks.add("");
    for(final track in widget.db.tracks) {
      if(track.country == country) {
        tracks.add(track.name);
      }
    }
  }

  void onTrack(String track) {
    setState(() {
      widget.filterValue.track = track;
    });
  }

  void onCar(String carName) {
    setState(() {
      widget.filterValue.carName = carName;
    });
  }

  void onClear() {
    setState(() {
      widget.filterValue.country="";
      widget.filterValue.track="";
      widget.filterValue.carName="";
    });
    onSave();
  }
}