import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reserve_mais_mobile/apis/services.dart';
import 'package:reserve_mais_mobile/models/reservation.dart';

class DetailsPage extends StatefulWidget {
  final int reservationId; // ID da reserva para buscar detalhes

  DetailsPage({required this.reservationId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Reservation?> futureReservation;

  @override
  void initState() {
    super.initState();
    futureReservation = fetchReservationDetails(widget.reservationId);
  }

  Future<Reservation?> fetchReservationDetails(int reservationId) async {
    final Service services = Service();
    try {
      final response = await services.getReservationsWithRequester();
      final matchingReservations =
          response.data.where((res) => res.id == reservationId);
      if (matchingReservations.isNotEmpty) {
        return matchingReservations.first;
      } else {
        return null; // Retorna null se nenhuma reserva for encontrada
      }
    } catch (e) {
      print("Erro ao buscar detalhes da reserva: $e");
      return null;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'disapproved':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getStatusTranslation(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'APROVADO';
      case 'disapproved':
        return 'REJEITADO';
      case 'pending':
        return 'PENDENTE';
      default:
        return 'Não encontrado';
    }
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
      ),
      body: FutureBuilder<Reservation?>(
        future: futureReservation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Reserva não encontrada.'));
          } else {
            final reservation = snapshot.data!;
            final requester = reservation.attributes.requester?.attributes;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Título da tela
                    Text(
                      'DETALHES',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Tabela de detalhes
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.grey, width: 1),
                      ),
                      children: [
                        _buildTableRow('SALA', reservation.attributes.title),
                        _buildTableRow(
                            'INÍCIO', formatDate(reservation.attributes.start)),
                        _buildTableRow(
                            'FIM', formatDate(reservation.attributes.end)),
                        _buildTableRow(
                          'HORÁRIO',
                          "${DateTime.parse(reservation.attributes.start).hour.toString().padLeft(2, '0')}:${DateTime.parse(reservation.attributes.start).minute.toString().padLeft(2, '0')} "
                              "ÀS "
                              "${DateTime.parse(reservation.attributes.end).hour.toString().padLeft(2, '0')}:${DateTime.parse(reservation.attributes.end).minute.toString().padLeft(2, '0')}",
                        ),
                        _buildTableRow(
                          'SOLICITANTE',
                          requester != null ? requester.username : 'N/A',
                        ),
                        _buildTableRow(
                          'SEMESTRAL',
                          reservation.attributes.isSemester ? 'SIM' : 'NÃO',
                        ),
                        _buildTableRow(
                          'STATUS',
                          getStatusTranslation(reservation.attributes.status),
                          color: getStatusColor(reservation.attributes.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  TableRow _buildTableRow(String title, String value, {Color? color}) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? Color(0xFF002F67),
            ),
          ),
        ),
      ],
    );
  }
}
