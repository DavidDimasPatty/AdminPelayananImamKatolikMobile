import 'dart:async';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class agenPencarian extends Agent {
  agenPencarian() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "cari Gereja": _estimatedTime,
    "cari gereja terakhir": _estimatedTime,
    "cari Imam": _estimatedTime,
    "cari User": _estimatedTime,
    "cari jumlah": _estimatedTime
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "cari Gereja":
        return _cariGereja(sender);

      case "cari Imam":
        return _cariImam(sender);

      case "cari User":
        return _cariUser(sender);

      case "cari jumlah":
        return _cariJumlah(sender);

      case "cari gereja terakhir":
        return _cariGerejaTerakhir(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _cariGereja(String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find().toList();
    Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Messages> _cariGerejaTerakhir(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find(where.sortBy("createdAt", descending: true).limit(1)).toList();
    Completer<void> completer = Completer<void>();

    Messages message2 = Messages(agentName, sender, "INFORM", Tasks('add aturan pelayanan', [data, conn]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message2);
    Messages message = Messages(agentName, sender, "INFORM", Tasks('done', null));
    completer.complete();

    await completer.future;
    return message;
  }

  Future<Messages> _cariImam(String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    final pipeline4 = AggregationPipelineBuilder().addStage(Lookup(from: 'Gereja', localField: 'idGereja', foreignField: '_id', as: 'imamGereja')).build();
    var conn = await userCollection.aggregateToStream(pipeline4).toList();
    Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Messages> _cariUser(String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn = await userCollection.find().toList();
    Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Messages> _cariJumlah(String sender) async {
    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.find().length;

    var connBan = await userCollection.find({'banned': 1}).length;

    var connG = await gerejaCollection.find().length;

    var connBanG = await gerejaCollection.find({'banned': 1}).length;

    var connUnG = await gerejaCollection.find({'banned': 0}).length;

    var connI = await imamCollection.find().length;

    var connBanI = await imamCollection.find({'banned': 1}).length;

    var connUnI = await imamCollection.find({'banned': 0}).length;

    var connUn = await userCollection.find({'banned': 0}).length;

    Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', [conn, connUn, connBan, connG, connUnG, connBanG, connI, connUnI, connBanI]));
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  void _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Pencarian";
    //nama agen
    plan = [Plan("cari Gereja", "REQUEST"), Plan("cari gereja terakhir", "REQUEST"), Plan("cari Imam", "REQUEST"), Plan("cari User", "REQUEST"), Plan("cari jumlah", "REQUEST")];
    //Perencanaan agen
    goals = [
      Goals("cari Gereja", List<Map<String, Object?>>, _timeAction["cari Gereja"]),
      Goals("cari gereja terakhir", String, _timeAction["cari gereja terakhir"]),
      Goals("cari Imam", List<Map<String, Object?>>, _timeAction["cari Imam"]),
      Goals("cari User", List<Map<String, Object?>>, _timeAction["cari User"]),
      Goals("cari jumlah", List<dynamic>, _timeAction["cari jumlah"])
    ];
  }
}
