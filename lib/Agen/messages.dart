import 'package:admin_pelayanan_katolik/Agen/agenAkun.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPendaftaran.dart';
import 'package:admin_pelayanan_katolik/Agen/agenSetting.dart';

import 'agenPage.dart';

class Messages {
  static var Agen = [];
  static var Data = [];

  addReceiver(agen) {
    if (Agen.length >= 1) {
      Agen.add(agen);
      Agen.removeAt(0);
    } else {
      Agen.add(agen);
    }
  }

  setContent(data) {
    if (Data.length >= 1) {
      Data.add(data);
      Data.removeAt(0);
    } else {
      Data.add(data);
    }
  }

  send() async {
    if (Agen.last == "agenPage") {
      await AgenPage();
    }
    if (Agen.last == "agenPendaftaran") {
      await AgenPendaftaran();
    }
    if (Agen.last == "agenAkun") {
      await AgenAkun();
    }
    if (Agen.last == "agenSetting") {
      await AgenSetting();
    }
  }

  receive() {
    return Data.last;
  }
}
