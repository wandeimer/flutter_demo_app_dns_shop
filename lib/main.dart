import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Navigation with Arguments',
        home: PreRegistrationScreen(),
        routes: {
          RegistrationScreen.routeName: (context) =>
              RegistrationScreen(),
          PreRegistrationScreen.routeName: (context) =>
              PreRegistrationScreen(),
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
  String name;
  String surname;
  String mail;
  String phone;
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
                      decoration: InputDecoration(
                          labelText: 'Имя'
                      ),
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
                      decoration: InputDecoration(
                          labelText: 'Фамилия'
                      ),
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
                      decoration: InputDecoration(
                          labelText: 'e-mail'
                      ),
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
                      decoration: InputDecoration(
                          labelText: 'Телефон'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите номер телефона';
                        } else {
                          phone = value;
                        }
                        return null;
                      },
                    ),
                  ])),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: RaisedButton(
              onPressed: () {
                if (_formState.currentState.validate()) {
                  Navigator.pushNamed(
                    context,
                    RegistrationScreen.routeName,
                    arguments: ScreenArguments(name, surname, mail, phone),
                  );
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
                      decoration: InputDecoration(
                          labelText: 'Ссылка на github'
                      ),
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
                      decoration: InputDecoration(
                          labelText: 'Ссылка на резюие'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите сслыку на резюие';
                        } else {
                          surname = value;
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

class ScreenArguments {
  final String name;
  final String surname;
  final String mail;
  final String phone;

  ScreenArguments(this.name, this.surname, this.mail, this.phone);
}
