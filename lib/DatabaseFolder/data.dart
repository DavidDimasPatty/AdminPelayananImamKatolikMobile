import 'package:flutter_dotenv/flutter_dotenv.dart';

//Inisilisasi variabel koneksi key untuk database GerejaDB di MongoDB
var MONGO_CONN_URL = dotenv.env['mongo_url'];

///Inisialisasi variabel dengan nilai nama collection pada database GerejaDB di MongoDB
const USER_COLLECTION = "user";
const IMAM_COLLECTION = "imam";
const ADMIN_COLLECTION = "admin";
const GEREJA_COLLECTION = "Gereja";
const JADWAL_GEREJA_COLLECTION = "jadwalGereja";
const TIKET_COLLECTION = "tiket";
const BAPTIS_COLLECTION = "baptis";
const KRISMA_COLLECTION = "krisma";
const UMUM_COLLECTION = "umum";
const KOMUNI_COLLECTION = "komuni";
const USER_KOMUNI_COLLECTION = "userKomuni";
const USER_BAPTIS_COLLECTION = "userBaptis";
const USER_UMUM_COLLECTION = "userUmum";
const USER_KRISMA_COLLECTION = "userKrisma";
const PEMBERKATAN_COLLECTION = "pemberkatan";
const ATURAN_PELAYANAN_COLLECTION = "aturanPelayanan";
//data-data variabel ini digunakan oleh agen untuk mengakses collection
