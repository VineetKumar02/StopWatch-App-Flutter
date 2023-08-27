import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  Future.delayed(const Duration(milliseconds: 500), () {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  //Logic Of App
  late Stopwatch stopwatch;
  late Timer t;

  String ms = "00", s = "00", m = "00", h = "00";
  bool started = false, reseted = true;

  //Initialization of App
  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    t = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  List laps = [], mlaps = [];
  ItemScrollController _scrollController = ItemScrollController();

  //Display Time by returning milliseconds
  int print_time() {
    var milli = stopwatch.elapsed.inMilliseconds;
    ms = (milli % 100).toString().padLeft(2, "0");
    s = (milli ~/ 1000 % 60).toString().padLeft(2, "0");
    m = (milli ~/ 1000 ~/ 60 % 60).toString().padLeft(2, "0");
    h = (milli ~/ 1000 ~/ 60 ~/ 60).toString().padLeft(2, "0");
    // return "$h:$m:$s:$ms";
    return milli;
  }

  //Creating Reset Function
  void reset() {
    stopwatch.reset();
    reseted = true;
    stopwatch.stop();
    started = false;
  }

  //Aad new Lap to ListView
  void addLaps() {
    String lap = "$h:$m:$s.";
    String mlap = ms;
    setState(() {
      laps.add(lap);
      mlaps.add(mlap);
    });
    if (laps.length > 5) {
      _scrollController.scrollTo(
          index: laps.length, duration: Duration(seconds: 1));
    }
  }

  //Empty the ListView
  void removeLaps() {
    setState(() {
      laps = [];
      mlaps = [];
    });
  }

  //Function To Start and Stop StopWatch
  void handleStartStop() {
    if (reseted) {
      removeLaps();
    }
    if (stopwatch.isRunning) {
      stopwatch.stop();
      started = false;
    } else {
      stopwatch.start();
      started = true;
    }
    reseted = false;
  }

  //Start Button
  String start_button() {
    if ((started) && (!reseted)) {
      return "Pause";
    } else if ((!started) && (!reseted)) {
      return "Resume";
    } else if ((reseted) && (!started)) {
      return "Start";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      // backgroundColor: Color(E9E9E9),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 35.0, bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Stop Watch",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 0.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (print_time() ~/ 1000 ~/ 60 ~/ 60)
                              .toString()
                              .padLeft(2, "0") +
                          ":" +
                          (print_time() ~/ 1000 ~/ 60 % 60)
                              .toString()
                              .padLeft(2, "0") +
                          ":" +
                          (print_time() ~/ 1000 % 60)
                              .toString()
                              .padLeft(2, "0"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    SizedBox(
                      height: 60,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          (print_time() % 100).toString().padLeft(2, "0"),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 41.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 300.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF323F68),
                    borderRadius: BorderRadius.circular(10.0),
                    // border: Border(bottom: BorderSide()),
                  ),
                  child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: laps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 19,
                            right: 19,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 17.0, bottom: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Lap ${index + 1}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${laps[index]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 21,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${mlaps[index]}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      elevation: 10.0,
                      child: const Icon(
                        Icons.flag,
                        size: 35,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: () => {addLaps()},
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    FloatingActionButton(
                      elevation: 10.0,
                      child: const Icon(
                        Icons.cancel,
                        size: 50,
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: () => {removeLaps()},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xFF1C2757),
                        splashColor: Colors.black,
                        onPressed: () {
                          handleStartStop();
                        },
                        shape: const StadiumBorder(
                            side: BorderSide(color: Colors.blue, width: 4)),
                        elevation: 10.0,
                        child: Text(
                          start_button(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        splashColor: Colors.black,
                        onPressed: () {
                          reset();
                        },
                        shape: const StadiumBorder(
                            side: BorderSide(color: Colors.blue, width: 4)),
                        elevation: 10.0,
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
