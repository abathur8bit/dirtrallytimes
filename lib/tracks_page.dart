import 'package:flutter/material.dart';
import "racetime.dart";
import "track.dart";
import "database.dart";

class TracksPage extends StatefulWidget {
  DirtDatabase db;
  TracksPage({Key? key,required this.db}) : super(key: key);

  @override
  _TracksPageState createState() => _TracksPageState();
}

class _TracksPageState extends State<TracksPage> {
  int currentSortColumn=0;
  bool sortAscending=true;
  late List<Track> filteredTracks;

  @override
  void initState() {
    super.initState();
    filteredTracks = widget.db.filteredTracks();
    filteredTracks.sort((a,b) => a.country.compareTo(b.country));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Tracks")),
      body:
      ListView(
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:DataTable(showCheckboxColumn: false,
                  sortColumnIndex: currentSortColumn,
                  sortAscending: sortAscending,
                  columns: [
                    DataColumn(label: const Text("Country"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              filteredTracks.sort((a,b) => a.country.compareTo(b.country));
                            } else {
                              filteredTracks.sort((a, b) => b.country.compareTo(a.country));
                            }
                          });
                        }),
                    DataColumn(label: const Text("Track"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              filteredTracks.sort((a,b) => a.name.compareTo(b.name));
                            } else {
                              filteredTracks.sort((a, b) => b.name.compareTo(a.name));
                            }
                          });
                        }),
                  ],
                  rows: List<DataRow>.generate(filteredTracks.length, (index) => DataRow(
                    // onSelectChanged: (selected) => onEditXXX(filteredTracks[index]),
                      cells: <DataCell>[
                        DataCell(Text(filteredTracks[index].country)),
                        DataCell(Text(filteredTracks[index].name)),
                      ]
                  )))
          ),
        ],
      ),
    );
  }
}