# dirtrallytimer

Track times from Dirt Rally races. Allows you to 
filter the races by location, track and car.

It allows you to view the best time for a track
independant of what type of car you drove. So if 
you had a better time in you Opel Adam R2 then 
your Ford Fiesta R5 MKII, you can see them 
next to each other.


# Hive
Using [Hive](https://pub.dev/packages/hive) and [hive_flutter](https://pub.dev/packages/hive_flutter) for local database storage.
The track objects use a [TypeAdapter](https://docs.hivedb.dev/#/custom-objects/generate_adapter). Run the following to generate part files (ie `car.g.dart`).

```
dart run build_runner build
```


# TODO
Some things to take care of.

## Bugs
- [x] Automatic is sometimes set to yes after saving a new track time
- [ ] *med* Double times when inspecting a time. *Doesn't happen all the time.*
- [ ] *low* When adding track time, scroll to show the entry you just made. LIkely also need to resort the list, as when I have date sorted newest first, it put the new entry at the bottom of the list
- [ ] Dropdowns the same color and size as text fields `ATextField`.

## Features
- [x] Need to be able to delete an entry
- [ ] Show time difference on race times screen
- [ ] Create new car screen
- [ ] Create new track screen
- [ ] Move stuff in UIFactory to a class in axorion lib. 
- [ ] Create a message box so I don't have to use `showDialog<>()` which requires a lot of extra lines. Just want a single liner to show a message.
- [ ] Create drawer to select Times, Tracks, Cars, About

# Location of database file
On Android and iOS, file is pretty much hidden anyway, so knowing it's location is pretty useless. 

On **Windows**, the file is located in the users documents directory, and is called `dirtrallytimesdatabase.hive`, 
where **dirtrallytimesdatabase** is the name passed in on the call to `Hive.box()`.

In `database.dart`:

```
import 'package:hive_flutter/hive_flutter.dart';
const DBNAME = "DirtRallyTimesDatabase";
class DirtDatabase {
  Box mybox = Hive.box(DBNAME);
  ...
}
```

# Main screen (Times)
Shows times of tracks.



# Track screen
Show list of tracks, tracks with times are shown first by default. *Sorted by last raced first?*
- Track Name, Last raced, Fasted time & car
- Has filter, to filter by car
- Graph showing times



```
| Track | Last Raced | Time | Car |
```

