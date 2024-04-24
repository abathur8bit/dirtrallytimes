import 'dart:math';

import 'package:dirtrallytimer/database.dart';
import 'package:flutter/material.dart';
import 'package:axorion/axorion.dart';
import "database.dart";
import "racetime.dart";

const double SEPARATION = 15;
const double MARGIN = 15;
const double EDITABLE_BORDER_WIDTH = 2.0;
const double READONLY_BORDER_WIDTH = 2.0;
const Color EDITABLE_BORDER_COLOR = Colors.black;
const Color READONLY_BORDER_COLOR = Colors.grey;
const Color RED_BORDER_COLOR = Colors.red;
const String ON = "On";
const String OFF = "Off";
const String YES = "Yes";
const String NO = "No";

class EditTime extends StatefulWidget {
	final DirtDatabase db;
	RaceTime? editTime;
	bool newTrack;
	EditTime({Key? key, required this.db, this.editTime,this.newTrack=true}) : super(key: key);

	@override
	_EditTimeState createState() => _EditTimeState();
}

class _EditTimeState extends State<EditTime> {
	TextEditingController dateController = TextEditingController();
	TextEditingController minuteController = TextEditingController();
	TextEditingController secondController = TextEditingController();
	TextEditingController formattedController = TextEditingController();

	List<String> countrys = [
		"",
		"Argentina",
		"Australia",
		"Belguim",
		"New Zealand",
		"Poland",
		"USA",
		"Spain",
		"Unknown",
	];

	DateTime raceDate = DateTime.now();
	List<String> tracks = [""];
	List<String> cars = [""];
	List<String> yesNo = [YES,NO];
	String selectedCountry="USA";
	String selectedTrack = "";
	String selectedCar = "";
	bool automatic=false;
	double minutes=0;
	double seconds=0;

	@override
	void initState() {
		super.initState();
		widget.editTime ??= RaceTime(
				raceDate: DateTime.now(),
				time: 0,
				country:"",
				track:"",
				carName:"",
				isAutomatic: false);
		if(widget.newTrack) {
			widget.editTime!.raceDate = DateTime.now();
		}
		dateController.text = DirtDatabase.dateTimeYYYYMMDDHHMM(widget.editTime!.raceDate);
		minuteController.text = widget.editTime!.minutes().toString();
		secondController.text = widget.editTime!.seconds().toStringAsFixed(3);
		selectedCountry = widget.editTime!.country ?? "";
		updateTracks(selectedCountry);
		for(final car in widget.db.cars) {
			cars.add(car.name);
		}
	}

	void onCountry(String country) {
		print("Selected $country");
		setState(() {
			widget.editTime?.country = country;
			widget.editTime?.track = "";
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
			widget.editTime?.track = track;
		});
	}

	void onAutomatic(String auto) {
		setState(() {
			widget.editTime?.isAutomatic = auto==YES;
		});
	}

	void onSteeringWheel(String used) {
		setState(() {
			widget.editTime?.steeringWheel = used==YES;
		});
	}

	void onCar(String carName) {
		setState(() {
			widget.editTime?.carName = carName;
		});
	}

	void onSave() {
		print("save clicked");
		if(widget.newTrack) {
			RaceTime rt = RaceTime(
					raceDate: raceDate,
					time: (double.tryParse(minuteController.text) ?? 0) * 60 + (double.tryParse(secondController.text) ?? 0),
					country: widget.editTime!.country,
					track: widget.editTime!.track,
					carName: widget.editTime!.carName,
					isAutomatic: widget.editTime!.isAutomatic,
					steeringWheel: widget.editTime!.steeringWheel
			);
			print("new race time: ${rt.toString()}");
			widget.db.appendRaceTime(rt);
		} else {
			widget.editTime!.time = (double.tryParse(minuteController.text) ?? 0) * 60 + (double.tryParse(secondController.text) ?? 0);
			print("edited race time: ${widget.editTime.toString()}");
			widget.db.previousTime = widget.editTime;
			widget.db.updateData();
		}
		Navigator.of(context).pop(widget.editTime);
	}

	void onDelete() async {
		var result = await showDialog<bool>(
			context: context,
			builder: (context) {
				return AlertDialog(
					content: Text("Confirm delete time?"),
					actions: [
						TextButton(
							onPressed: () => Navigator.of(context).pop(false),
							child: const Text('Cancel'),
						),
						TextButton(
							onPressed: () => Navigator.of(context).pop(true),
							child: const Text('OK'),
						),
					],
				);
			},
		);
		if(result == true) {
			widget.db.delete(widget.editTime!);
			Navigator.of(context).pop(widget.editTime);
		}
	}

	@override
	Widget build(BuildContext context) {
		var insets =  const EdgeInsets.all(8.0);
		formattedController.text = "${dateController.text}\t${widget.editTime!.country}\t${widget.editTime!.track}\t${widget.editTime!.carName}\t${widget.editTime!.isAutomatic ? "Y":"N"}\t${widget.editTime!.steeringWheel ? "Y":"N"}\t${minuteController.text}\t${secondController.text}";
		return Scaffold(
				appBar: AppBar(
					title:Text(widget.newTrack ? "New Track Time":"Edit Track Time"),
					actions: [
						IconButton(iconSize: 28,icon: const Icon(Icons.delete),onPressed: widget.newTrack ? null : onDelete) ,
						IconButton(iconSize: 28,icon: const Icon(Icons.save),onPressed: onSave),
					],
				),
				body: Padding(
					padding: const EdgeInsets.all(8.0),
					child: ListView(
						children: [
							Padding(padding: insets,child: ATextField(label: "Date",controller: dateController)),
							Padding(padding: insets,child: createRowDropdown("Country", widget.editTime!.country, countrys, onCountry)),
							Padding(padding: insets,child: createRowDropdown("Track", widget.editTime!.track, tracks, onTrack)),
							Padding(padding: insets,child: createRowDropdown("Car",widget.editTime!.carName,cars, onCar)),
							Padding(padding: insets,child: createRowDropdown("Automatic",widget.editTime!.isAutomatic ? YES:NO,yesNo,onAutomatic)),
							Padding(padding: insets,child: createRowDropdown("Wheel",widget.editTime!.steeringWheel ? YES:NO,yesNo,onSteeringWheel)),
							Padding(padding: insets,child: ATextField(label: "Minutes",controller: minuteController,number: true)),
							Padding(padding: insets,child: ATextField(label: "Seconds",controller: secondController,number: true)),
							Padding(padding: insets,child: ATextField(label: "Export",
									controller: formattedController,)),
						],
					),
				)
		);
	}

	static BoxDecoration roundedRect(bool editable) {
		return roundedRectColored(editable ? EDITABLE_BORDER_COLOR : READONLY_BORDER_COLOR,editable ? EDITABLE_BORDER_WIDTH : READONLY_BORDER_WIDTH);
		// return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: editable ? EDITABLE_BORDER_WIDTH : READONLY_BORDER_WIDTH, color: editable ? EDITABLE_BORDER_COLOR : READONLY_BORDER_COLOR));
	}

	static BoxDecoration roundedRectColored(Color color,double width) {
		return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: width, color: color));
	}

	static Widget createRowDropdown(String label, String value, List<String> itemList, void Function(String) selectHandler) {
		final double colWidth = 150;
		return Padding(padding: EdgeInsets.only(bottom: SEPARATION), child: Container(decoration: roundedRect(true), child: Row(
			children: [
				//label
				Padding(padding: EdgeInsets.only(left: MARGIN), child: Container(width: colWidth, child: Text(label, textAlign: TextAlign.left))),
				//field
				Expanded(
						child: DropdownButton<String>(
								value: value,
								icon: const Icon(Icons.arrow_downward),
								onChanged: (String? newValue) => selectHandler(newValue!),
								items: itemList.map<DropdownMenuItem<String>>((String value) {
									return DropdownMenuItem<String>(
										value: value,
										child: Text(value),
									);
								}).toList()))
			],
		)));
	}
}