import 'dart:async';

import 'data_classes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registrationScreen';
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
        'https://vacancy.dns-shop.ru/api/candidate/summary';
    SummaryResponse _summaryResponse;
    String _name = args.name;
    String _surname = args.surname;
    String _mail = args.mail;
    String _phone = args.phone;
    String _token = args.token;
    String _github;
    String _resume;

    _sendRegistrationData() async {
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
          setState(() {}); //reBuildWidget
          return _summaryResponse.message;
        } else {
          print("response status code: ${response.statusCode}");
          setState(() {}); //reBuildWidget
          return "Ошибка сервера. Код ответа: ${response.statusCode}";
        }
      } catch (error) {
        print("error: $error");
        setState(() {}); //reBuildWidget
        return "Ошибка при отправке запроса. ERROR: $error";
      }
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
                            //r"(http(s)?)(:(\/\/)?)(\/.+)";
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
                  ])),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                if (_formState.currentState.validate()) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Отправка данных"),
                    backgroundColor: DNSColor.shade500,
                    duration: Duration(seconds: 1),
                  ));
                  Future<String> _message = _sendRegistrationData();
                  _message.then((value) {
                    if (value == "") {
                      _showDialog("Регистрация завершена",
                          "Регистрация завершена успешно. Наш сотрудник свяжется с вами");
                    } else {
                      _showDialog("Ошибка", value);
                    }
                  });
                }
              },
              child: Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(String _title, String _message) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(_title),
        content: Text(_message),
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
