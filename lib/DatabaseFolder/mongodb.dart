import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import './data.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
  }

  static findUser(email, password) async {
    userCollection = db.collection(ADMIN_COLLECTION);
    var conn = await userCollection
        .find({'user': email, 'password': password}).toList();
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

  static userTerdaftar() async {
    userCollection = db.collection(USER_COLLECTION);
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

  static callJumlah() async {
    userCollection = db.collection(USER_COLLECTION);
    var conn = await userCollection.find().length;

    userCollection = db.collection(USER_COLLECTION);
    var connBan = await userCollection.find({'banned': 1}).length;

    userCollection = db.collection(USER_COLLECTION);
    var connUn = await userCollection.find({'banned': 0}).length;

    return [conn, connUn, connBan];
  }

  static callJumlahGereja() async {
    var gerejaCollection = db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().length;

    var connBan = await gerejaCollection.find({'banned': 1}).length;

    var connUn = await gerejaCollection.find({'banned': 0}).length;

    return [conn, connUn, connBan];
  }

  static gerejaTerdaftar() async {
    userCollection = db.collection(GEREJA_COLLECTION);
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

  static updateStatusUser(id, status) async {
    var userCollection = db.collection(USER_COLLECTION);

    var update = await userCollection.updateOne(
        where.eq('_id', id), modify.set('banned', status));

    if (!update.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static updateStatusGereja(id, status) async {
    var userCollection = db.collection(GEREJA_COLLECTION);

    var update = await userCollection.updateOne(
        where.eq('_id', id), modify.set('banned', status));

    if (!update.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static UserPATerdaftar(idPA) async {
    var userUmumCollection = db.collection(USER_UMUM_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userPA'))
        .addStage(
            Match(where.eq('idKegiatan', idPA).eq('status', 0).map['\$query']))
        .build();
    var conn = await userUmumCollection.aggregateToStream(pipeline).toList();
    print(conn);
    return conn;
  }

  static addPemberkatan(idUser, nama, paroki, lingkungan, notelp, alamat, jenis,
      tanggal, note) async {
    var pemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);
    var checkEmail;

    var hasil = await pemberkatanCollection.insertOne({
      'idUser': idUser,
      'namaLengkap': nama,
      'paroki': paroki,
      'lingkungan': lingkungan,
      'notelp': notelp,
      'alamat': alamat,
      'jenis': jenis,
      'tanggal': DateTime.parse(tanggal),
      'note': note,
      'status': 0
    });

    if (!hasil.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }

  static acceptPemberkatan(idKegiatan) async {
    var pemberkatanCollection = db.collection(PEMBERKATAN_COLLECTION);

    var update = await pemberkatanCollection.updateOne(
        where.eq('_id', idKegiatan), modify.set('status', 1));

    if (!update.isSuccess) {
      print('Error detected in record insertion');
      return 'fail';
    } else {
      return 'oke';
    }
  }
}
