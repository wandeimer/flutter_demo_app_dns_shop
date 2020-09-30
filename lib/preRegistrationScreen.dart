import 'package:flutter_demo_app_dns_shop/registrationScreen.dart';

import 'data_classes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class PreRegistrationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод данных'),
      ),
      body: PreRegistrationScreen2(),
    );
  }

}

class PreRegistrationScreen2 extends StatefulWidget {

  @override
  PreRegistrationScreen2State createState() {
    return PreRegistrationScreen2State();
  }
}

class PreRegistrationScreen2State extends State<PreRegistrationScreen2> {
  final _formState = GlobalKey<FormState>();
  final String _url = 'https://vacancy.dns-shop.ru/api/candidate/token';
  TokenResponse _tokenResponse;
  String _token;
  String _name;
  String _surname;
  String _mail;
  String _phone;

  _getTokenButton() async {
    try {
      var response = await http.post(_url,
          body: jsonEncode({
            "firstName": _name,
            "lastName": _surname,
            "phone": _phone,
            "email": _mail
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          });

      if (response.statusCode == 200) {
        _tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
        if (_tokenResponse.message == '') {
          _token = _tokenResponse.data;
          Navigator.pushNamed(
            context,
            RegistrationScreen.routeName,
            arguments: ScreenArguments(_name, _surname, _mail, _phone, _token),
          );
        }
        else {
          print("message: ${_tokenResponse.message}");
        }
      }
      else {
        print("response status code: ${response.statusCode}");
      }
    } catch (error) {
      print("error: $error");
    }
    setState(() {}); //reBuildWidget
  } //_sendRequestPos

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
              key: _formState,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Имя'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите имя';
                        } else {
                          _name = value;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Фамилия'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите фамилию';
                        } else {
                          _surname = value;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'e-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        var mailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        if (value.isEmpty) {
                          return 'Введите e-mail';
                        }
                        else {
                          if (RegExp(mailPattern, caseSensitive: false).hasMatch(value)) {
                            _mail = value;
                          }
                          else {
                            return 'Введите корректный e-mail';
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Телефон'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        var phonePattern = r"(\+7|7|8)?[\s\-]?\(?[489][0-9]{2}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$";
                        if (value.isEmpty) {
                          return 'Введите номер телефона';
                        } else {
                          if (RegExp(phonePattern, caseSensitive: false).hasMatch(value)) {
                            _phone = value;
                          }
                          else {
                            return 'Введите корректный номер телефона';
                          }
                        }
                        return null;
                      },
                    ),
                  ])),
          Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: RaisedButton(
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                if (_formState.currentState.validate()) {
                  _getTokenButton();
                  _formState.currentState.save();
                }
              },
              child: Text('ПОЛУЧИТЬ КЛЮЧ'),
            ),
          )
        ],
    );
  }
}