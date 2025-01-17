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
  final Service services = Service();
  final EventController<CalendarEventData> _eventController =
      EventController<CalendarEventData>();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    futureReservations = services.getReservationsWithApproved();
  }

  void _showEventsForDay(
      DateTime selectedDay, List<CalendarEventData<Object>> events) {
    final eventsForDay = events.where((event) {
      return event.date.year == selectedDay.year &&
          event.date.month == selectedDay.month &&
          event.date.day == selectedDay.day;
    }).toList();

    eventsForDay.sort((a, b) => a.startTime!.compareTo(b.startTime!));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: Color(0xFF002F67),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'TÍTULO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'HORÁRIO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (eventsForDay.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Nenhum agendamento para este dia.",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: eventsForDay.length,
                      itemBuilder: (context, index) {
                        final event = eventsForDay[index];
                        return Container(
                          color:
                              index % 2 == 0 ? Color(0xFFF3F4F6) : Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Color(0xFF002F67),
                              ),
                              Expanded(
                                child: Text(
                                  "${event.startTime?.hour.toString().padLeft(2, '0')}:${event.startTime?.minute.toString().padLeft(2, '0')} "
                                  "ÀS "
                                  "${event.endTime?.hour.toString().padLeft(2, '0')}:${event.endTime?.minute.toString().padLeft(2, '0')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Fechar",
                style: TextStyle(color: Color(0xFF002F67), fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário de Reservas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 4.0, left: 8.0, right: 8.0, bottom: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar pelo nome',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<ReservationResponse>(
              future: futureReservations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return Center(child: Text('Nenhuma reserva encontrada'));
                } else {
                  final filteredReservations = snapshot.data!.data
                      .where((reservation) => reservation.attributes.title
                          .toLowerCase()
                          .contains(_searchText))
                      .toList();

                  final events = filteredReservations.map((reservation) {
                    return CalendarEventData<CalendarEventData>(
                      title: reservation.attributes.title,
                      date: DateTime.parse(reservation.attributes.start),
                      startTime: DateTime.parse(reservation.attributes.start),
                      endTime: DateTime.parse(reservation.attributes.end),
                      color: Color(int.parse(reservation.attributes.color
                          .replaceFirst('#', '0xff'))),
                    );
                  }).toList();

                  _eventController.removeAll(_eventController
                      .events); // Limpa todos os eventos existentes
                  _eventController.addAll(events); // Adiciona os novos eventos

                  return MonthView(
                    controller: _eventController,
                    onCellTap: (events, date) =>
                        _showEventsForDay(date, events),
                    onEventTap: (event, date) =>
                        _showEventsForDay(date, events),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
