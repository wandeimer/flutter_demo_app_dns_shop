import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data_classes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Navigation with Arguments',
        home: PreRegistrationScreen(),
        routes: {
          RegistrationScreen.routeName: (context) => RegistrationScreen(),
          PreRegistrationScreen.routeName: (context) => PreRegistrationScreen(),
        });
  }
}

class PreRegistrationScreen extends StatefulWidget {
  static const routeName = '/PreRegistrationScreen';

  @override
  PreRegistrationScreenState createState() {
    return PreRegistrationScreenState();
  }
}

class PreRegistrationScreenState extends State<PreRegistrationScreen> {
  final _formState = GlobalKey<FormState>();
  final String _url = 'https://vacancy.dns-shop.ru/api/candidate/token';
  String _body;
  int _status;
  TokenResponse _tokenResponse;
  String _token;
  String name;
  String surname;
  String mail;
  String phone;
  String text;

  _sendRequestPostBodyHeadersKEY() async {
    try {
      var response = await http.post(_url,
          body: jsonEncode({
            "firstName": "test",
            "lastName": "test",
            "phone": "88005553535",
            "email": "test@example.com"
          }),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          });

      _status = response.statusCode;
      _body = response.body;
      //print("body:  ${response.body}");
      _tokenResponse = TokenResponse.fromJson(jsonDecode(_body));
      _token = _tokenResponse.data;
    } catch (error) {
      _status = 0;
      print("error: $error");
      _body = error.toString();
    }
    setState(() {}); //reBuildWidget
    return _status;
  } //_sendRequestPos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ввод данных'),
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
                      decoration: InputDecoration(labelText: 'Имя'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите имя';
                        } else {
                          name = value;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Фамилия'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите фамилию';
                        } else {
                          surname = value;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'e-mail'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите e-mail';
                        } else {
                          mail = value;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Телефон'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите номер телефона';
                        } else {
                          phone = value;
                        }
                        return null;
                      },
                    ),
                    Text(text == null ? 'no' : text.toString()),
                  ])),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              onPressed: () {
                if (_formState.currentState.validate()) {
                  var code = _sendRequestPostBodyHeadersKEY();
                  print(_token);
                  text = _token;
                  print("token: $_token");
                  _formState.currentState.save();
                  /*Navigator.pushNamed(
                    context,
                    RegistrationScreen.routeName,
                    arguments: ScreenArguments(name, surname, mail, phone, _token),
                  );*/
                }
              },
              child: Text('ПОЛУЧИТЬ КЛЮЧ'),
            ),
          )
        ],
      ),
    );
  }
}

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
    String name = args.name;
    String surname = args.name;
    String mail = args.mail;
    String phone = args.phone;
    String token;
    String github;
    String resume;

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
                          name = value;
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
                          surname = value;
                        }
                        return null;
                      },
                    ),
                    Text(token),
                  ])),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              onPressed: () {
                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                if (_formState.currentState.validate()) {
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

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}) : url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
}

class TestHttpState extends State<TestHttp> {
  final _formKey = GlobalKey<FormState>();

  String _url, _body;
  int _status;
  TokenResponse _token;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestPostBodyHeadersKEY() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //update form data

      try {
        var response = await http.post(_url,
            body: jsonEncode({
              "firstName": "test",
              "lastName": "test",
              "phone": "88005553535",
              "email": "test@example.com"
            }),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            });

        _status = response.statusCode;
        _body = response.body;
        _token = TokenResponse.fromJson(jsonDecode(_body));
      } catch (error) {
        _status = 0;
        _body = error.toString();
      }
      setState(() {}); //reBuildWidget
    }
  } //_sendRequestPos

  _sendRequestPostSummary() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //update form data

      try {
        var response = await http.post(_url,
            body: jsonEncode({
              "firstName": "test",
              "lastName": "test",
              "phone": "88005553535",
              "email": "test@example.com"
            }),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
            });

        _status = response.statusCode;
        _body = response.body;
        _token = TokenResponse.fromJson(jsonDecode(_body));
      } catch (error) {
        _status = 0;
        _body = error.toString();
      }
      setState(() {}); //reBuildWidget
    }
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                child: Text('API url',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                padding: EdgeInsets.all(10.0)),
            Container(
                child: TextFormField(
                    initialValue: _url,
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) return 'API url isEmpty';
                    },
                    onSaved: (value) {
                      _url = value;
                    },
                    autovalidate: true),
                padding: EdgeInsets.all(10.0)),
            SizedBox(height: 20.0),
            RaisedButton(
                child: Text('Send request POST to get '),
                onPressed: _sendRequestPostBodyHeadersKEY),
            SizedBox(height: 20.0),
            Text('Response status',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            Text(_status == null ? '' : _status.toString()),
            SizedBox(height: 20.0),
            Text('Response body',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            //Text(_body == null ? '' : _body),
            Text(_body == null ? '' : _token.data),
          ],
        )));
  } //build
}
