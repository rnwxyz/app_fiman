import 'package:app_fiman/blocs/auth/auth_bloc.dart';
import 'package:app_fiman/utils/constants/contant.dart';
import 'package:app_fiman/views/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/validator/validator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final nameController = TextEditingController();
  final Validator validator = Validator();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _nameSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthLogin(nameController.text));
      nameController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StartScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'welcome',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'swipe',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.swipe_left_sharp,
                        size: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'hello',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'swipe',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.swipe_left_sharp,
                        size: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Name',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: validator.nameValidator,
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              hintStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _nameSubmit();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            'START',
                            style: button,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
