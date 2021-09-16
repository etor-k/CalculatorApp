import 'dart:io';
import 'package:calculator/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatelessWidget
//Open up a widget which does not change
{
  @override
  Widget build(BuildContext context)
  //override from stateless to stateful
  {
    return MaterialApp(
        home: HomeView(),
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false);
  }
}

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> keypads = [
    "AC",
    "+/-",
    "%",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "0",
    ".",
    "="
  ];
  bool isOperator({required String label}) {
    return label == "/" ||
        label == "*" ||
        label == "-" ||
        label == "+" ||
        label == "=";
  }

  String answer = "";
  String input = "";

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("WomanRising"),
          centerTitle: true,
          actions: [
            Icon(
              Icons.history,
              color: Colors.white,
            ),
            SizedBox(width: 20),
          ],
        ),
        drawer: Drawer(),
        body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                answer,
                style: TextStyle(
                  color: Colors.black12,
                  fontSize: 42,
                ),
              ),
              SizedBox(height: 20),
              Text(
                input,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 100),
              Expanded(
                  child: GridView.builder(
                      itemCount: keypads.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        final String keypad = keypads[index];
                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: isOperator(label: keypad)
                                ? Colors.amber
                                : Colors.blueGrey,
                            shape: isOperator(label: keypad)
                                ? CircleBorder()
                                : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                          ),
                          onPressed: () {
                            handleKeyOnPressed(keypad: keypad);
                          },
                          child: Text(
                            keypad,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }))
            ])));
  }

  String calcInput() {
    print("inputValue: $input");
    final result = buildParser().parse(input);
    if (result.isSuccess) {
      print(result.value);
      setState(() {
        answer = result.value.toStrip();
      });
      return result.value.toString();
    } else {
      setState(() {
        answer = 'Error';
      });
    }
    print("Error $result");
    return "Error";
  }

  void handleKeyOnPressed({required String keypad}) {
    setState(() {
      if (keypad == "AC") {
        input = "";
        answer = "";
      } else if (keypad == "<" && input.isNotEmpty)
        input = input.substring(0, input.length - 1);
      else if (keypad == "0") {
        if (input.isEmpty)
          input = keypad;
        else if (input.length == 1 && input == keypad)
          return;
        else
          input += keypad;
      } else if (keypad == ".") {
        if (input.isEmpty)
          input = "0";
        else if (!input.contains(".")) input += keypad;
      } else if (keypad == "=") {
        calcInput();
      } else {}
    });
  }
}
