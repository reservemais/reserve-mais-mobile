import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reserve_mais_mobile/models/reservation.dart';

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
      return true;
    } else {
      return false;
    }
  }
}
