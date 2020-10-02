import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'data_classes.dart';
import 'package:flutter/material.dart' show AlertDialog, AppBar, AsyncSnapshot, BuildContext, Center, CircularProgressIndicator, Colors, Column, CrossAxisAlignment, EdgeInsets, FlatButton, Form, FormState, FutureBuilder, GlobalKey, Icon, Icons, InputDecoration, MainAxisAlignment, ModalRoute, Navigator, Padding, RaisedButton, Scaffold, ScaffoldState, SizedBox, State, StatefulWidget, Text, TextFormField, TextInputType, Theme, Widget, showDialog;

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/extractArguments';
  @override
  RegistrationScreenState createState() {
    return RegistrationScreenState();
  }
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    String _notificationTitle;
    String _notificationText;
    Future<String> _response;

    String text = "no";

    Future<String> _getTokenButton() async {
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
      return _summaryResponse.message;
    } //_sendRequestPos

    return Scaffold(
      key: _scaffoldKey,
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
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        var gitUrlPattern =
                            r"(http(s)?)(:(\/\/)?)(github\.com\/.+)";
                        if (value.isEmpty) {
                          return 'Введите сслыку на github';
                        } else {
                          if (RegExp(gitUrlPattern, caseSensitive: false)
                              .hasMatch(value)) {
                            _github = value;
                          } else {
                            return 'Введите корректную ссылку на github';
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Ссылка на резюме'),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        var summaryUrlPattern =
                            r"^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)";
                        if (value.isEmpty) {
                          return 'Введите сслыку на резюме';
                        } else {
                          if (RegExp(
                            summaryUrlPattern,
                            caseSensitive: false,
                          ).hasMatch(value)) {
                            _resume = value;
                          } else {
                            return 'Введите корректную сслыку на резюме';
                          }
                        }
                        return null;
                      },
                    ),
                    Text(text),
                  ])),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              textColor: Theme.of(context).accentColor,
              onPressed: () async {
                if (_formState.currentState.validate()) {
                  _response = (await _getTokenButton()) as Future<String>;
                  /*
                  if (_response == "") {
                    text = "success";
                  } else {
                    text = _response as String;
                  }
                  _showDialog(text);

                   */
                  //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text), backgroundColor: DNSColor.shade500));
                }
              },
              child: Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
            ),
          ),
        FutureBuilder<String>(
        future: _response, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: ${snapshot.data}'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          }
          else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        }
        ),
        ],
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showLoadingCircle(String _title, String _text) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(_title),
        content: Text(_text
        ),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

}
