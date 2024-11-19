import 'package:flutter/material.dart';
import 'package:reserve_mais_mobile/apis/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Service services = Service();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _attemptLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    bool success = await services.login(
      _identifierController.text,
      _passwordController.text,
    );

    if (success) {
      // Login bem-sucedido: redireciona para a página principal
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Login falhou: exibe mensagem de erro
      setState(() {
        _errorMessage = 'Falha no login. Verifique suas credenciais.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _identifierController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _attemptLogin,
                      child: Text('Entrar'),
                    ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
