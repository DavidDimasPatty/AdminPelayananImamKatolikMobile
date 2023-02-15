import 'dart:developer';

import 'package:admin_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';

class AgenPendaftaran {
  AgenPendaftaran() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data[0][0] == "update user") {
          var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
          try {
            var update = await userCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('banned', data[2][0]))
                .then((result) async {
              if (result.isSuccess) {
                msg.addReceiver("agenPage");
                msg.setContent('oke');
                await msg.send();
              } else {
                msg.addReceiver("agenPage");
                msg.setContent('failed');
                await msg.send();
              }
            });
          } catch (e) {
            msg.addReceiver("agenPage");
            msg.setContent('fail');
            await msg.send();
          }
        }

        if (data[0][0] == "update gereja") {
          var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
          try {
            var update = await userCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('banned', data[2][0]))
                .then((result) async {
              if (result.isSuccess) {
                msg.addReceiver("agenPage");
                msg.setContent('oke');
                await msg.send();
              } else {
                msg.addReceiver("agenPage");
                msg.setContent('failed');
                await msg.send();
              }
            });
          } catch (e) {
            msg.addReceiver("agenPage");
            msg.setContent('fail');
            await msg.send();
          }
        }

        if (data[0][0] == "add gereja") {
          var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
          try {
            var hasil = await userCollection.insertOne({
              "nama": data[1][0],
              "address": data[2][0],
              "paroki": data[3][0],
              "lingkungan": data[4][0],
              "deskripsi": data[5][0],
              "lat": data[6][0],
              "lng": data[7][0],
              "banned": 0
            }).then((result) async {
              if (result.isSuccess) {
                msg.addReceiver("agenPage");
                msg.setContent('oke');
                await msg.send();
              } else {
                msg.addReceiver("agenPage");
                msg.setContent('failed');
                await msg.send();
              }
            });
          } catch (e) {
            msg.addReceiver("agenPage");
            msg.setContent('fail');
            await msg.send();
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
