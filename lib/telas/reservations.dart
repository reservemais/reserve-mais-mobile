import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:reserve_mais_mobile/apis/services.dart';
import 'package:reserve_mais_mobile/models/reservation.dart';

class ReservationsCalendarPage extends StatefulWidget {
  @override
  _ReservationsCalendarPageState createState() =>
      _ReservationsCalendarPageState();
}

class _ReservationsCalendarPageState extends State<ReservationsCalendarPage> {
  late Future<ReservationResponse> futureReservations;
  final Service service = Service();

  @override
  void initState() {
    super.initState();
    futureReservations = service.getReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Reservas'),
      ),
      body: FutureBuilder<ReservationResponse>(
        future: futureReservations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text('Nenhuma reserva encontrada'));
          } else {
            final events = snapshot.data!.data.map((reserva) {
              return CalendarEventData(
                title: reserva.attributes.title,
                date: DateTime.parse(reserva.attributes.start),
                startTime: DateTime.parse(reserva.attributes.start),
                endTime: DateTime.parse(reserva.attributes.end),
                color: Color(int.parse(
                    reserva.attributes.color.replaceFirst('#', '0xff'))),
              );
            }).toList();

            return MonthView(
              controller: EventController()..addAll(events),
            );
          }
        },
      ),
    );
  }
}
