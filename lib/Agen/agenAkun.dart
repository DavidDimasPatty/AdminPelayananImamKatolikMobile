import 'dart:developer';

import 'package:admin_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';

class AgenAkun {
  AgenAkun() {
    ResponsBehaviour();
  }

  ResponsBehaviour() async {
    Messages msg = Messages();

    var data = await msg.receive();
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (await data[0][0] == "cari admin") {
            // var userCollection =
            //     await MongoDatabase.db.collection(ADMIN_COLLECTION);

            await MongoDatabase.db
                .collection(ADMIN_COLLECTION)
                .find({'user': data[1][0], 'password': data[2][0]})
                .toList()
                .then((result) async {
                  if (await result != 0) {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    msg.send();
                  } else {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    msg.send();
                  }
                });
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "ready") {
          print("Agen Pencarian Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
