import 'package:flutter/material.dart';
import 'package:reserve_mais_mobile/telas/reservations.dart';
import 'package:reserve_mais_mobile/telas/solicitations.dart';
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
        '/home': (context) => HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista de telas associadas à barra de navegação
  final List<Widget> _screens = [
    ReservationsCalendarPage(), // Tela do calendário de reservas
    SolicitationsPage(), // Tela de solicitações
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice ao selecionar um ícone
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Solicitações',
          ),
        ],
      ),
    );
  }
}
