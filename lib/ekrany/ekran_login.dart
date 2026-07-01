import 'package:flutter/material.dart';
import '../services/service_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool loading = false;

Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    //zabezpieczenie kodu (walidacja)
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Błąd: Pola nie mogą być puste!")),
      );
      return; // Przerywa działanie, nie loguje
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Błąd: Niepoprawny format adresu e-mail!")),
      );
      return; // Przerywa działanie, bo mail nie ma @
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Błąd: Hasło musi mieć minimum 6 znaków!")),
      );
      return; 
    }

    setState(() => loading = true);

    try {
      if (isLogin) {
        await _auth.login(email, password);
      } else {
        await _auth.register(email, password);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Błąd Firebase: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Logowanie" : "Rejestracja"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Hasło"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(isLogin ? "Zaloguj" : "Zarejestruj"),
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Nie masz konta? Zarejestruj się"
                    : "Masz konto? Zaloguj się",
              ),
            ),
          ],
        ),
      ),
    );
  }
}