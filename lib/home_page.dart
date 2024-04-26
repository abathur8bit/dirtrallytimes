import "package:dirtrallytimer/dirtdrawer.dart";
import 'package:flutter/material.dart';
import 'package:axorion/axorion.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "database.dart";
import "edittime.dart";
import "racetime.dart";
import "filter.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DirtDatabase db = DirtDatabase();
  late List<RaceTime> filteredTimes = [];
  RaceTime? previousTime;
  int currentSortColumn=0;
  bool sortAscending=true;
  int pageNum=0;

  @override
  void initState() {
    super.initState();
    db.loadData();
    previousTime = db.previousTime;
    filteredTimes = db.filteredTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DirtDrawer.create(context,db),
      appBar: AppBar(title:Text("Dirt Rally 2.0 Times"),
          //   backgroundColor: Colors.blueGrey,
          actions: [
            //filter_alt_outlined no filter
            //filter_alt filter active
            IconButton(iconSize: 28,icon:Icon(db.filter.isEmpty() ? Icons.filter_alt_outlined:Icons.filter_alt),onPressed: onFilter),
          ]
      ),
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
                            updateTimes();
                          });
                        }),
                    DataColumn(label: const Text("Country"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            updateTimes();
                          });
                        }),
                    DataColumn(label: const Text("Track"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            updateTimes();
                          });
                        }),
                    DataColumn(label: const Text("Car"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            updateTimes();
                          });
                        }),
                    DataColumn(label: const Text("Class"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            updateTimes();
                          });
                        }),
                    DataColumn(label: const Text("Time"),
                        onSort: (columnIndex,ascending) {
                          setState(() {
                            currentSortColumn = columnIndex;
                            sortAscending = ascending;
                            updateTimes();
                          });
                        }),
                  ],
                  rows: List<DataRow>.generate(filteredTimes.length, (index) => DataRow(
                    onSelectChanged: (selected) => onEditTime(filteredTimes[index]),
                      cells: <DataCell>[
                        DataCell(Text(DirtDatabase.dateTimeYYYYMMDDHHMM(filteredTimes[index].raceDate))),
                        DataCell(Text(filteredTimes[index].country)),
                        DataCell(Text(filteredTimes[index].track)),
                        DataCell(Text(filteredTimes[index].carName)),
                        DataCell(Text(filteredTimes[index].carPerformanceClass(db.cars))),
                        DataCell(Text(filteredTimes[index].timeFormatted())),
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

  void onFilter() async {
    var result = await Navigator.push(context,MaterialPageRoute(builder: (context) => Filter(db:db,filterValue:db.filter)));
    if(result != null) {
      setState(() {
        updateTimes();
      });
    }
  }

  void onAddTime() async {
    final RaceTime? time = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditTime(db:db,editTime:previousTime,newTrack: true,)));
    if(time != null) {
      setState(() {
        previousTime = time;
        updateTimes();
      });
    }
  }

  //edit and delete time
  void onEditTime(RaceTime rt) async {
    RaceTime? parent = db.findParent(rt);
    if(parent == null) {
      print("not able to find parent for ${rt.toString()}");
    } else {
      final RaceTime? time = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditTime(db:db,editTime:parent,newTrack: false,)));
      if(time != null) {
        setState(() {
          previousTime = time;
          updateTimes();
        });
      }
    }
  }

  void updateTimes() {
    filteredTimes = db.filteredTimes();
    switch(currentSortColumn) {
      case 0: filteredTimes.sort((a,b) => sortAscending ? a.raceDate.compareTo(b.raceDate) : b.raceDate.compareTo(a.raceDate)); break;
      case 1: filteredTimes.sort((a,b) => sortAscending ? a.country.compareTo(b.country) : b.country.compareTo(a.country)); break;
      case 2: filteredTimes.sort((a,b) => sortAscending ? a.track.compareTo(b.track) : b.track.compareTo(a.track)); break;
      case 3: filteredTimes.sort((a,b) => sortAscending ? a.carName.compareTo(b.carName) : b.carName.compareTo(a.carName)); break;
      case 4: filteredTimes.sort((a,b) => sortAscending ? a.carPerformanceClass(db.cars).compareTo(b.carPerformanceClass(db.cars)) : b.carPerformanceClass(db.cars).compareTo(a.carPerformanceClass(db.cars))); break;
      case 5: filteredTimes.sort((a,b) => sortAscending ? a.time.compareTo(b.time) : b.time.compareTo(a.time)); break;
    }
  }
}