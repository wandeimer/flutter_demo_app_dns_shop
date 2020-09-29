import 'data_classes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'preRegistrationScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/extractArguments';
  @override
  RegistrationScreenState createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final String _url =
        'https://vacancy.dns-shop.ru/api/candidate/test/summary';
    SummaryResponse _summaryResponse;
    String _name = args.name;
    String _surname = args.name;
    String _mail = args.mail;
    String _phone = args.phone;
    String _token = args.token;
    String _github;
    String _resume;

    _getTokenButton() async {
      try {
        var response = await http.post(_url,
            body: jsonEncode({
              "firstName": _name,
              "lastName": _surname,
              "phone": _phone,
              "email": _mail,
              "githubProfileUrl": _github,
              "summary": _resume
            }),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              'Authorization': 'Bearer $_token',
            });

        if (response.statusCode == 200) {
          _summaryResponse =
              SummaryResponse.fromJson(jsonDecode(response.body));
          print("message: ${_summaryResponse.message}");
        } else {
          print("response status code: ${response.statusCode}");
        }
      } catch (error) {
        print("error: $error");
      }
      setState(() {}); //reBuildWidget
    } //_sendRequestPos

    return Scaffold(
      appBar: AppBar(
        title: Text('Отправка данных'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
              key: _formState,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Ссылка на github'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите сслыку на github';
                        } else {
                          _github = value;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Ссылка на резюие'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите сслыку на резюие';
                        } else {
                          _resume = value;
                        }
                        return null;
                      },
                    ),
                  ])),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              onPressed: () {
                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                if (_formState.currentState.validate()) {
                  _getTokenButton();
                  Navigator.pushNamed(
                    context,
                    PreRegistrationScreen.routeName,
                  );
                }
              },
              child: Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
            ),
          )
        ],
      ),
    );
  }
}
