
class Settings {
  int id;
  String _emailAdress;

  Settings(this._emailAdress);

  Settings.map(dynamic obj) {
    this._emailAdress = obj["email_address"];
  }

  String get emailAddress => _emailAdress;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["email_address"] = _emailAdress;
    return map;
  }

  
}
