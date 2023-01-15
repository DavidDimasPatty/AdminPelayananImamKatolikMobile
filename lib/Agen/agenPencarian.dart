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

          if (data[0][0] == "cari user") {
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var conn = await userCollection.find().toList();
            try {
              print(conn[0]);
              if (conn[0]['id'] != "") {
                return conn;
              } else {
                return "failed";
              }
            } catch (e) {
              return "failed";
            }
          }

          if (data[0][0] == "cari gereja") {
            var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
            var conn = await userCollection.find().toList();
            try {
              print(conn[0]);
              if (conn[0]['id'] != "") {
                return conn;
              } else {
                return "failed";
              }
            } catch (e) {
              return "failed";
            }
          }

          if (data[0][0] == "cari jumlah user") {
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            var conn = await userCollection.find().length;

            var connBan = await userCollection.find({'banned': 1}).length;

            var connUn = await userCollection.find({'banned': 0}).length;

            return [conn, connUn, connBan];
          }

          if (data[0][0] == "cari jumlah gereja") {
            var gerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var conn = await gerejaCollection.find().length;

            var connBan = await gerejaCollection.find({'banned': 1}).length;

            var connUn = await gerejaCollection.find({'banned': 0}).length;

            return [conn, connUn, connBan];
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

            var update = await userCollection.updateOne(
                where.eq('_id', data[1][0]), modify.set('banned', data[2][0]));

            if (!update.isSuccess) {
              print('Error detected in record insertion');
              return 'fail';
            } else {
              return 'oke';
            }
          }

          if (data[0][0] == "update gereja") {
            var userCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

            var update = await userCollection.updateOne(
                where.eq('_id', data[1][0]), modify.set('banned', data[2][0]));

            if (!update.isSuccess) {
              print('Error detected in record insertion');
              return 'fail';
            } else {
              return 'oke';
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
