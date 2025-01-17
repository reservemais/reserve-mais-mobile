import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reserve_mais_mobile/models/reservation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final URL_SERVICE = Uri.parse("http://10.0.2.2");

final URL_RESERVATIONS = "${URL_SERVICE.toString()}:1337/api/reservations";
final URL_LOGIN = "${URL_SERVICE.toString()}:1337/api/auth/local";

class Service {
  Future<ReservationResponse> getReservations() async {
    final response =
        await http.get(Uri.parse("${URL_RESERVATIONS.toString()}"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ReservationResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar reservas');
    }
  }

  Future<ReservationResponse> getReservationsByUser(int userId) async {
    // URL com filtro para buscar reservas do usuário logado
    final url = Uri.parse(
      "${URL_RESERVATIONS.toString()}?populate=%2A&filters[requester][id][\$eq]=$userId&pagination[page]=1&pagination[pageSize]=999",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ReservationResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar reservas do usuário');
    }
  }

  Future<ReservationResponse> getReservationsWithApproved() async {
    final url = Uri.parse(
      "${URL_RESERVATIONS.toString()}?populate=%2A&filters[\$or][0][status]=approved&pagination[page]=1&pagination[pageSize]=999",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ReservationResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar reservas');
    }
  }

  Future<ReservationResponse> getReservationsWithRequester() async {
    final url = Uri.parse(
      "${URL_RESERVATIONS.toString()}?populate[ambience][populate]=responsibles&populate[requester][populate]=*&filters[ambience][responsibles][id][\$eq]=1&pagination[page]=1&pagination[pageSize]=1000000",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return ReservationResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Falha ao carregar reservas com requester');
    }
  }

  Future<bool> login(String identifier, String password) async {
    final url = Uri.parse(URL_LOGIN);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "identifier": identifier,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['user']['id'];
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('loggedUserId', userId);
      });
      return true;
    } else {
      return false;
    }
  }
}
