import 'dart:developer';

import 'package:admin_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';

class AgenPendaftaran {
  static var dataPencarian;
  AgenPendaftaran() {
    ReadyBehaviour();
    ResponsBehaviour();
    ReceiveBehaviour();
  }
  setDataTampilan(data) async {
    dataPencarian = await data;
  }

  receiverTampilan() async {
    return await dataPencarian;
  }

  ReceiveBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<Map<String, Object?>>) {
          await setDataTampilan(data);
        }
      } catch (e) {
        return null;
      }
    }
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

        if (data[0][0] == "update imam") {
          var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
          var GerejarCollection =
              MongoDatabase.db.collection(GEREJA_COLLECTION);
          try {
            await msg.addReceiver("agenPencarian");
            await msg.setContent([
              ["cari gereja daftar"]
            ]);
            await msg.send();
            print(await receiverTampilan());

            var update = await userCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('banned', data[2][0]))
                .then((result) async {
              if (result.isSuccess) {
                await msg.addReceiver("agenPage");
                await msg.setContent('oke');
                await msg.send();
              } else {
                await msg.addReceiver("agenPage");
                await msg.setContent('failed');
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
          var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
          var aturanCollection =
              MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
          try {
            var hasil = await gerejaCollection.insertOne({
              "nama": data[1][0],
              "address": data[2][0],
              "paroki": data[3][0],
              "lingkungan": data[4][0],
              "deskripsi": data[5][0],
              "lat": data[6][0],
              "lng": data[7][0],
              "gambar": "",
              "banned": 0,
              "createdAt": DateTime.now(),
            }).then((result) async {
              try {
                var find = await gerejaCollection
                    .find(where.sortBy("createdAt", descending: true).limit(1))
                    .toList()
                    .then((result2) async {
                  print("objectaWWDDDDDDDDDDD");
                  print(result2);
                  var addAturan = await aturanCollection.insertOne({
                    "idGereja": result2[0]['_id'],
                    "baptis": "",
                    "komuni": "",
                    "krisma": "",
                    "perkawinan": "",
                    "perminyakan": "",
                    "tobat": "",
                    "pemberkatan": "",
                    "updatedAt": DateTime.now(),
                    "updatedBy": ObjectId(),
                  }).then((result3) async {
                    if (result3.isSuccess) {
                      msg.addReceiver("agenPage");
                      msg.setContent('oke');
                      await msg.send();
                    } else {
                      msg.addReceiver("agenPage");
                      msg.setContent('failed');
                      await msg.send();
                    }
                  });
                });
              } catch (e) {
                print(e);
                msg.addReceiver("agenPage");
                msg.setContent('fail');
                await msg.send();
              }
            });
          } catch (e) {
            msg.addReceiver("agenPage");
            msg.setContent('fail');
            await msg.send();
          }
        }

        if (data[0][0] == "add imam") {
          var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
          try {
            var hasil = await userCollection.insertOne({
              "email": data[1][0],
              "password": data[2][0],
              "idGereja": data[3][0],
              "name": data[4][0],
              "picture": "",
              "notelp": "",
              "statusPemberkatan": 0,
              "statusPerminyakan": 0,
              "statusTobat": 0,
              "statusPerkawinan": 0,
              "banned": 0,
              "notif": true
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
