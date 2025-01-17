import 'package:flutter/material.dart';
import 'package:reserve_mais_mobile/apis/services.dart';
import 'package:reserve_mais_mobile/models/reservation.dart';
import 'package:reserve_mais_mobile/telas/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolicitationsPage extends StatefulWidget {
  @override
  _SolicitationsPageState createState() => _SolicitationsPageState();
}

class _SolicitationsPageState extends State<SolicitationsPage> {
  Future<ReservationResponse> futureReservations = Future.value(
    ReservationResponse(
        data: [],
        meta: Meta(
            pagination:
                Pagination(page: 1, pageSize: 0, pageCount: 0, total: 0))),
  );
  final Service services = Service();
  String? selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final userId =
        prefs.getInt('loggedUserId'); // Recupera o ID do usuário logado
    if (userId != null) {
      setState(() {
        futureReservations = services.getReservationsByUser(userId);
      });
    } else {
      setState(() {
        futureReservations = Future.error('Usuário não logado.');
      });
    }
  }

  void updateFilter(String status) {
    setState(() {
      selectedStatus = status;
    });
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
      case 'all':
        return 'Todos';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitações'),
      ),
      body: Column(
        children: [
          // Filtro de Status
          Padding(
            padding: const EdgeInsets.only(
                top: 0.1, left: 8.0, right: 8.0, bottom: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.1,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF002F67)),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: null,
                  icon: Icon(Icons.filter_list),
                  hint: Text(
                    getStatusTranslation(selectedStatus ?? 'all'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedStatus == 'all',
                            onChanged: (bool? value) {
                              if (value == true) {
                                updateFilter('all');
                                Navigator.pop(context); // Fecha o menu
                              }
                            },
                          ),
                          Text(
                            'Todos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      value: 'all',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedStatus == 'approved',
                            onChanged: (bool? value) {
                              if (value == true) {
                                updateFilter('approved');
                                Navigator.pop(context);
                              }
                            },
                          ),
                          Text(
                            'Aprovado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getStatusColor('approved'),
                            ),
                          ),
                        ],
                      ),
                      value: 'approved',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedStatus == 'disapproved',
                            onChanged: (bool? value) {
                              if (value == true) {
                                updateFilter('disapproved');
                                Navigator.pop(context);
                              }
                            },
                          ),
                          Text(
                            'Rejeitado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getStatusColor('disapproved'),
                            ),
                          ),
                        ],
                      ),
                      value: 'disapproved',
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedStatus == 'pending',
                            onChanged: (bool? value) {
                              if (value == true) {
                                updateFilter('pending');
                                Navigator.pop(context);
                              }
                            },
                          ),
                          Text(
                            'Pendente',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getStatusColor('pending'),
                            ),
                          ),
                        ],
                      ),
                      value: 'pending',
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      updateFilter(value);
                    }
                  },
                  isExpanded: true,
                ),
              ),
            ),
          ),
          // Lista de Reservas
          Expanded(
            child: FutureBuilder<ReservationResponse>(
              future: futureReservations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return Center(child: Text('Nenhuma solicitação encontrada'));
                } else {
                  // Aplica o filtro de status
                  final filteredReservations = selectedStatus == 'all'
                      ? snapshot.data!.data
                      : snapshot.data!.data
                          .where((reservation) =>
                              reservation.attributes.status.toLowerCase() ==
                              selectedStatus)
                          .toList();

                  if (filteredReservations.isEmpty) {
                    return Center(
                        child: Text(
                            'Nenhuma solicitação com o status selecionado'));
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Cabeçalho da tabela
                        Container(
                          color: Color(0xFF002F67),
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'TÍTULO',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Color(0xFF002F67),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'STATUS',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Lista de reservas
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredReservations.length,
                          itemBuilder: (context, index) {
                            final reservation = filteredReservations[index];
                            return Container(
                              color: index % 2 == 0
                                  ? Colors.grey[200]
                                  : Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        reservation.attributes.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Color(0xFF002F67),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          getStatusTranslation(
                                              reservation.attributes.status),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: getStatusColor(
                                                reservation.attributes.status),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(Icons.visibility,
                                              color: Color(0xFF002F67)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                        reservationId:
                                                            reservation.id),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
