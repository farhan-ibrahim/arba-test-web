import 'package:arba_test_web/src/bloc/auth_cubit.dart';
import 'package:arba_test_web/src/repositories/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final authRepo = AuthRepository();
  bool hasError = false;
  bool hasRegistered = false;
  bool hasLoggedIn = false;
  String errorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _buildView(
    BuildContext context,
    TextEditingController emailCtrl,
    TextEditingController passwordCtrl,
    String title, [
    TextEditingController? nameCtrl,
  ]) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text('Join Us!'),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (title == 'Register')
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = emailCtrl.text;
                final password = passwordCtrl.text;
                final name = nameCtrl?.text ?? 'username';
                if (title == 'Login') {
                  context
                      .read<AuthCubit>()
                      .login(email.trim().toLowerCase(), password);
                } else if (title == 'Register') {
                  context
                      .read<AuthCubit>()
                      .register(email.trim().toLowerCase(), password, name);
                }
              },
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        builder: (BuildContext context, state) {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'Login'),
                Tab(text: 'Register'),
              ],
            ),
          ),
          body: TabBarView(children: [
            _buildView(context, emailController, passwordController, 'Login'),
            _buildView(context, emailController, passwordController, 'Register',
                nameController),
          ]),
        ),
      );
    }, listener: (BuildContext context, state) {
      // If the user is logged in, navigate to the home screen
      if (state.isLoggedIn) {
        Navigator.of(context).pop();
      }

      // If registration succeeds, proceed to login
      if (state.user != null && !state.isLoggedIn) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Registration successful!'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    hasRegistered = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Continue to login'),
              ),
            ],
          ),
        );
      }

      if (state.error != null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(state.error ?? "Something went wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    hasError = false;
                    errorMsg = "";
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
        context.read<AuthCubit>().clearError();
      }
    });
  }
}
