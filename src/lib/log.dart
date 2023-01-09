import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:localstorage/localstorage.dart';



Color primaryColor = Colors.yellow.shade800;

class log extends StatelessWidget {
  DateTime today = DateTime.now();
  void onDaySelected(DateTime day, DateTime focusedDay) {
    today = day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log your emotions"),

        backgroundColor: primaryColor,
      ),
      body: logWidget(),
    );
  }
}



class logWidget extends StatefulWidget {
  @override
  logState createState() => logState();
}

class logState extends State<logWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};
  HashMap hashMap = new HashMap<int, int>();
  final LocalStorage store = new LocalStorage('myapp');

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  String dayWeek(int day) {
    if (day == 1) {
      return "Monday";
    } else if (day == 2) {
      return "Tuesday";
    } else if (day == 3) {
      return "Wednesday";
    } else if (day == 4) {
      return "Thursday";
    } else if (day == 5) {
      return "Friday";
    } else if (day == 6) {
      return "Saturday";
    } else if (day == 7) {
      return "Sunday";
    }
    return "";
  }

  List<Color> mapColor(int choice){
    if (choice == 1) {
      return [Color.fromRGBO(253, 184, 19, 1),
        Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 0)
      ];
    } else if (choice == 2) {
      return [Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 1),
        Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 0)
      ];
    } else if (choice == 3) {
      return [Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 1),
        Color.fromRGBO(253, 184, 19, 0)
      ];
    } else if (choice == 4){
      return [Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 0),
        Color.fromRGBO(253, 184, 19, 1)
      ];
    }
    return [Color.fromRGBO(253, 184, 19, 0),
      Color.fromRGBO(253, 184, 19, 0),
      Color.fromRGBO(253, 184, 19, 0),
      Color.fromRGBO(253, 184, 19, 0)
    ];
  }

  @override
  void initState() {
    loadData();
    refreshColors();
    _selectedDay = _focusedDay;
    super.initState();
  }

  Color color1 = Color.fromRGBO(253, 184, 19, 0);
  Color color2 = Color.fromRGBO(253, 184, 19, 0);
  Color color3 = Color.fromRGBO(253, 184, 19, 0);
  Color color4 = Color.fromRGBO(253, 184, 19, 0);

  saveData() async {
    await store.ready;
    store.setItem('map', hashMap);
  }

  loadData() async {
    await store.ready;
    hashMap = store.getItem('map');
  }

  void refreshColors() {
    // Saves the map

    List<Color> dayColors = [
      Color.fromRGBO(253, 184, 19, 0),
      Color.fromRGBO(253, 184, 19, 0),
      Color.fromRGBO(253, 184, 19, 0),
      Color.fromRGBO(253, 184, 19, 0)
    ];
    if (hashMap.containsKey(_focusedDay.millisecondsSinceEpoch)) {
      dayColors = mapColor(hashMap[_focusedDay.millisecondsSinceEpoch]);
    } else {
      dayColors = mapColor(-1);
    }
    setState(() {
      color1 = dayColors[0];
      color2 = dayColors[1];
      color3 = dayColors[2];
      color4 = dayColors[3];
    });
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    refreshColors();

    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2021, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                eventLoader: getEventForDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              SizedBox(
                  height: 50
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(238, 237, 231, .8),
                  ),
                  child:Column(
                    children: [
                      Container(
                          child: Text("How did you feel on " +
                              dayWeek(_focusedDay.weekday) + " " +
                              _focusedDay.month.toString() + "/" +
                              _focusedDay.day.toString(),
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: color1,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                hashMap[_focusedDay.millisecondsSinceEpoch] = 1;
                                refreshColors();
                                saveData();
                              },
                              child: Image.asset("assets/happy.png", scale: 2),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: color2,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                hashMap[_focusedDay.millisecondsSinceEpoch] = 2;
                                refreshColors();
                                saveData();
                              },
                              child: Image.asset("assets/sad.png", scale: 2),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: color3,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                hashMap[_focusedDay.millisecondsSinceEpoch] = 3;
                                refreshColors();
                                saveData();
                              },
                              child: Image.asset("assets/angry.png", scale: 2),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: color4,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                hashMap[_focusedDay.millisecondsSinceEpoch] = 4;
                                refreshColors();
                                saveData();
                              },
                              child: Image.asset("assets/neutral.png", scale: 2),
                            ),
                          )
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
        )


    );
  }
}
