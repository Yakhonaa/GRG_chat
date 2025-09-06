import 'package:flutter/material.dart';
import 'package:flutter_application_1/back/controller.dart';
import 'package:flutter_application_1/data/constants.dart';
import 'package:flutter_application_1/data/notifiers.dart';
import 'package:flutter_application_1/pages/contact_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController controllerU2 = TextEditingController();
  TextEditingController controllerU1 = TextEditingController();
  String someProblem = "";
  List<double> sizedBoxes = [RegSizedBoxes.sizedBox1, RegSizedBoxes.sizedBox2];
  List<String> textFields = [
    RegTextFields.textFiled1,
    RegTextFields.textFiled2,
  ];
  List<String> buttons = ["Sign in", "Log in"];

  @override
  Widget build(BuildContext context) {
    List controllers = [controllerU1, controllerU2];
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(
                  height: 300.0,
                  width: 300,
                  child: Image.asset('assets/images/grg_logo.png'),
                ),
                if (someProblem != "")
                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 17, 24, 21),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            width: 3,
                            color: Color.fromARGB(255, 200, 0, 100),
                          ),
                        ),
                        child: Text(
                          someProblem,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                if (someProblem == "") SizedBox(height: 80),

                ...List.generate(textFields.length, (index) {
                  print(sizedBoxes.elementAt(index));
                  return Column(
                    children: [
                      TextField(
                        controller: controllers.elementAt(index),
                        decoration: InputDecoration(
                          hintText: textFields.elementAt(index),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxes.elementAt(index)),
                    ],
                  );
                }),
                ...List.generate(textFields.length, (index) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          index == 0 ? onRegPressed() : onLogPressed();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 65.0),
                        ),
                        child: Text(
                          buttons.elementAt(index),
                          style: TextStyles.buttonStyle1,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }),
                // In your widget's build method, you can use it like this:
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onRegPressed() async {
    String regResponse = await register(controllerU1.text, controllerU2.text);
    print(regResponse);
    if (regResponse == "User registered successfully") {
      currentUserId.value = await getUserId(controllerU1.text);
      contacts.value = await login(controllerU1.text, controllerU2.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactPage()),
      );
      setState(() {
        someProblem = "";
      });
    }
    if (regResponse == "Username already exists") {
      setState(() {
        someProblem = "Account with this username already exists";
      });
    }
    controllerU1.text = '';
    controllerU2.text = '';
  }

  void onLogPressed() async {
    contacts.value = await login(controllerU1.text, controllerU2.text);
    if (contacts.value.elementAt(0) != "UserDoesNotExists") {
      currentUserId.value = await getUserId(controllerU1.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactPage()),
      );
      setState(() {
        someProblem = "";
      });
    }
    if (contacts.value.elementAt(0) == "UserDoesNotExists") {
      setState(() {
        someProblem = "Username or Password is wrong";
      });
    }
    controllerU1.text = '';
    controllerU2.text = '';
  }
}
