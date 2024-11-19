import 'package:flutter/material.dart';
import 'package:reserve_mais_mobile/telas/reservations.dart';
import 'package:reserve_mais_mobile/telas/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserve Mais App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => ReservationsCalendarPage(),
      },
    );
  }
}












// import 'dart:ui';

// import 'package:calendar_view/calendar_view.dart';
// import 'package:flutter/material.dart';

// DateTime get _now => DateTime.now();

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return CalendarControllerProvider(
//       controller: EventController()..addAll(_events),
//       child: MaterialApp(
//         home: Scaffold(
//           body: MonthView(),
//         ),
//       ),
//     );
//   }
// }

// List<CalendarEventData> _events = [
//   CalendarEventData(
//       date: _now,
//       title: "teste",
//       description: "Today is project meeting.",
//       startTime: DateTime.parse("2024-05-22T15:10:00.000Z"),
//       endTime: DateTime.parse("2024-05-22T15:20:00.000Z"),
//       color: const Color(0xFF039BE5))
// ];
