import 'package:flutter/material.dart';
import 'package:axorion/axorion.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "database.dart";
import "edittime.dart";
import "racetime.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DirtDatabase db = DirtDatabase();
  RaceTime? previousTime;
  int currentSortColumn=0;
  bool sortAscending=true;
  int pageNum=0;
  @override
  void initState() {
    super.initState();
    db.loadData();
    previousTime = db.previousTime;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title:Text("Dirt Rally 3.0 Times")),
      //   backgroundColor: Colors.blueGrey,
        body:
        ListView(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:DataTable(showCheckboxColumn: false,
                  sortColumnIndex: currentSortColumn,
                  sortAscending: sortAscending,
                  columns: [
                    DataColumn(label: const Text("Date"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              db.raceTimes.sort((a,b) => a.raceDate.compareTo(b.raceDate));
                            } else {
                              db.raceTimes.sort((a, b) => b.raceDate.compareTo(a.raceDate));
                            }
                          });
                        }),
                    DataColumn(label: const Text("Country"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              db.raceTimes.sort((a,b) => a.country.compareTo(b.country));
                            } else {
                              db.raceTimes.sort((a, b) => b.country.compareTo(a.country));
                            }
                          });
                        }),
                    DataColumn(label: const Text("Track"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              db.raceTimes.sort((a,b) => a.track.compareTo(b.track));
                            } else {
                              db.raceTimes.sort((a, b) => b.track.compareTo(a.track));
                            }
                          });
                        }),
                    DataColumn(label: const Text("Car"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              db.raceTimes.sort((a,b) => a.carName.compareTo(b.carName));
                            } else {
                              db.raceTimes.sort((a, b) => b.carName.compareTo(a.carName));
                            }
                          });
                        }),
                    DataColumn(label: const Text("Class"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              db.raceTimes.sort((a,b) => a.carPerformanceClass(db.cars).compareTo(b.carPerformanceClass(db.cars)));
                            } else {
                              db.raceTimes.sort((a, b) => b.carPerformanceClass(db.cars).compareTo(a.carPerformanceClass(db.cars)));
                            }
                          });
                        }),
                    DataColumn(label: const Text("Time"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            if (ascending) {
                              db.raceTimes.sort((a,b) => a.time.compareTo(b.time));
                            } else {
                              db.raceTimes.sort((a, b) => b.time.compareTo(a.time));
                            }
                          });
                        }),
                  ],
                  rows: List<DataRow>.generate(db.raceTimes.length, (index) => DataRow(
                    onSelectChanged: (selected) => onEditTime(index),
                      cells: <DataCell>[
                        DataCell(Text(DirtDatabase.dateTimeYYYYMMDDHHMM(db.raceTimes[index].raceDate))),
                        DataCell(Text(db.raceTimes[index].country)),
                        DataCell(Text(db.raceTimes[index].track)),
                        DataCell(Text(db.raceTimes[index].carName)),
                        DataCell(Text(db.raceTimes[index].carPerformanceClass(db.cars))),
                        DataCell(Text(db.raceTimes[index].timeFormatted())),
                      ]
                  )))
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onAddTime,
          tooltip: 'Add time',
          child: const Icon(Icons.add),
        ),
    );
  }

  void onAddTime() async {
    final RaceTime? time = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditTime(db:db,editTime:previousTime,newTrack: true,)));
    if(time != null) {
      setState(() {
        previousTime = time;
      });
    }
  }

  void onEditTime(int index) async {
    final RaceTime? time = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditTime(db:db,editTime:db.raceTimes[index],newTrack: false,)));
    if(time != null) {
      setState(() {
        previousTime = time;
      });
    }
  }
}