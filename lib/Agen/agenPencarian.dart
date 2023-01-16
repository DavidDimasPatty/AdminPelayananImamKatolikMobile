import 'dart:developer';

import 'package:admin_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';

class AgenPencarian {
  AgenPencarian() {
    ReadyBehaviour();
    ResponsBehaviour();
    UpdateBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data.runtimeType == List<List<String>>) {
          if (data[0][0] == "cari user") {
            print("cari user");
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var conn =
                await userCollection.find().toList().then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari gereja") {
            var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
            var conn =
                await userCollection.find().toList().then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari jumlah") {
            print("masukkkkk!!@");
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var gerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var conn = await userCollection.find().length;

            var connBan = await userCollection.find({'banned': 1}).length;

            var connG = await gerejaCollection.find().length;

            var connBanG = await gerejaCollection.find({'banned': 1}).length;

            var connUnG = await gerejaCollection.find({'banned': 0}).length;

            var connUn = await userCollection
                .find({'banned': 0})
                .length
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(
                      [conn, result, connBan, connG, connUnG, connBanG]);
                  await msg.send();
                });
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  UpdateBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "cari Baptis") {
            var userBaptisCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            await userBaptisCollection
                .find({'idGereja': data[1][0], 'status': 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "update user") {
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            try {
              var update = await userCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('banned', data[2][0]))
                  .then((result) async {
                msg.addReceiver("agenPage");
                msg.setContent('oke');
                await msg.send();
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
                msg.addReceiver("agenPage");
                msg.setContent('oke');
                await msg.send();
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('fail');
              await msg.send();
            }
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
