import 'dart:math';

import 'package:dirtrallytimer/database.dart';
import 'package:flutter/material.dart';
import 'package:axorion/axorion.dart';
import "database.dart";
import "racetime.dart";
import "UIFactory.dart";

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
							Padding(padding: insets,child: UIFactory.createRowDropdown("Country", widget.editTime!.country, countrys, onCountry)),
							Padding(padding: insets,child: UIFactory.createRowDropdown("Track", widget.editTime!.track, tracks, onTrack)),
							Padding(padding: insets,child: UIFactory.createRowDropdown("Car",widget.editTime!.carName,cars, onCar)),
							Padding(padding: insets,child: UIFactory.createRowDropdown("Automatic",widget.editTime!.isAutomatic ? YES:NO,yesNo,onAutomatic)),
							Padding(padding: insets,child: UIFactory.createRowDropdown("Wheel",widget.editTime!.steeringWheel ? YES:NO,yesNo,onSteeringWheel)),
							Padding(padding: insets,child: ATextField(label: "Minutes",controller: minuteController,number: true)),
							Padding(padding: insets,child: ATextField(label: "Seconds",controller: secondController,number: true)),
							Padding(padding: insets,child: ATextField(label: "Export",
									controller: formattedController,)),
						],
					),
				)
		);
	}


}