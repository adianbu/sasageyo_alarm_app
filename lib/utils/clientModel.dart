/// ClientModel.dart
import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  int id;
  String time;
  int vibrate;
  String ringtone;
  String label;
  // bool blocked;

  Client({
    this.id,
    this.time,
    this.vibrate,
    this.ringtone,
    this.label,
  });

  // blocked: json["blocked"] == 1,
  factory Client.fromMap(Map<String, dynamic> json) => new Client(
        id: json["id"],
        time: json["time"],
        vibrate: json["vibrate"],
        ringtone: json["ringtone"],
        label: json["label"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "time": time,
        "vibrate": vibrate,
        "ringtone": ringtone,
        "label": label,
      };

  //     newClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.rawInsert(
  //     "INSERT Into Client (id,first_name)"
  //     " VALUES (${newClient.id},${newClient.firstName})");
  //   return res;
  // }
}
