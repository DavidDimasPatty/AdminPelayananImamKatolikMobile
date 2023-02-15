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

          if (data[0][0] == "cari imam") {
            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
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

            var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await userCollection.find().length;

            var connBan = await userCollection.find({'banned': 1}).length;

            var connG = await gerejaCollection.find().length;

            var connBanG = await gerejaCollection.find({'banned': 1}).length;

            var connUnG = await gerejaCollection.find({'banned': 0}).length;

            var connI = await imamCollection.find().length;

            var connBanI = await imamCollection.find({'banned': 1}).length;

            var connUnI = await imamCollection.find({'banned': 0}).length;

            var connUn = await userCollection
                .find({'banned': 0})
                .length
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent([
                    conn,
                    result,
                    connBan,
                    connG,
                    connUnG,
                    connBanG,
                    connI,
                    connUnI,
                    connBanI
                  ]);
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
          if (data[0][0] == "cari admin") {
            var userCollection = MongoDatabase.db.collection(ADMIN_COLLECTION);
            var conn = await userCollection
                .find({'user': data[1][0], 'password': data[2][0]})
                .toList()
                .then((result) async {
                  print(result);
                  if (result != 0) {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  } else {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  }
                });
          }

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
