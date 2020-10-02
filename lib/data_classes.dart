class ScreenArguments {
  final String name;
  final String surname;
  final String mail;
  final String phone;
  final String token;

  ScreenArguments(this.name, this.surname, this.mail, this.phone, this.token);
}

class TokenResponse {
  int code;
  String message;
  String data;

  TokenResponse(this.code, this.message, this.data);

  factory TokenResponse.fromJson(dynamic json) {
    return TokenResponse(
        json['code'] as int, json['message'] as String, json['data'] as String);
  }

  @override
  String toString() {
    return '{ ${this.code}, ${this.message}, ${this.data} }';
  }
}

class SummaryResponse {
  int code;
  String message;

  SummaryResponse(this.code, this.message);

  factory SummaryResponse.fromJson(dynamic json) {
    return SummaryResponse(json['code'] as int, json['message'] as String);
  }

  @override
  String toString() {
    return '{ ${this.code}, ${this.message}}';
  }
}
