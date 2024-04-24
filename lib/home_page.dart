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
  FilterValue filterValue = FilterValue();
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
    List<RaceTime> filteredTimes = filteredList(filterValue);
    return Scaffold(
        appBar: AppBar(title:Text("Dirt Rally 2.0 Times"),
            //   backgroundColor: Colors.blueGrey,
            actions: [
              //filter_alt_outlined no filter
              //filter_alt filter active
              IconButton(iconSize: 28,icon:Icon(filterValue.isEmpty() ? Icons.filter_alt_outlined:Icons.filter_alt),onPressed: onFilter),
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

  int filteredLength(FilterValue filter) {
    return filteredList(filter).length;
  }

  RaceTime filteredAt(FilterValue filter,int index) {
    List<RaceTime> filtered = filteredList(filter);
    return filtered[index];
  }

  List<RaceTime> filteredList(FilterValue filter) {
    //first by country, then by track
    List<RaceTime> filteredByCountry = [];
    for(final rt in db.raceTimes) {
      if(filterValue.country.isEmpty) {
        filteredByCountry.add(rt);
      } else if(rt.country == filterValue.country) {
        filteredByCountry.add(rt);
      }
    }
    List<RaceTime> filteredByTrack = [];
    for(final rt in filteredByCountry) {
      if(filterValue.track.isEmpty) {
        filteredByTrack.add(rt);
      } else if(filterValue.track == rt.track) {
        filteredByTrack.add(rt);
      }
    }
    List<RaceTime> filteredByCar = [];
    for(final rt in filteredByTrack) {
      if(filterValue.carName.isEmpty) {
        filteredByCar.add(rt);
      } else if(filterValue.carName == rt.carName) {
        filteredByCar.add(rt);
      }
    }
    return filteredByCar;
  }

  void onFilter() async {
    final bool result = await Navigator.push(context,MaterialPageRoute(builder: (context) => Filter(db:db,filterValue:filterValue)));
    if(result) {
      setState(() {
        //TODO filter race times
      });
    }
  }

  void onAddTime() async {
    final RaceTime? time = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditTime(db:db,editTime:previousTime,newTrack: true,)));
    if(time != null) {
      setState(() {
        previousTime = time;
      });
    }
  }

  void onEditTime(RaceTime rt) async {
    RaceTime? parent = findParent(rt);
    if(parent == null) {
      print("not able to find parent for ${rt.toString()}");
    } else {
      final RaceTime? time = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditTime(db:db,editTime:parent,newTrack: false,)));
      if(time != null) {
        setState(() {
          previousTime = time;
        });
      }
    }
  }

  //finds the given race time in the db list
  RaceTime? findParent(RaceTime rt) {
    for(final time in db.raceTimes) {
      if(rt.equals(time)) return time;
    }
    return null;
  }
}