import 'package:admin_pelayanan_katolik/view/login.dart';
import 'package:flutter/material.dart';

import 'messages.dart';

class AgenPage {
  static var dataTampilan;
  AgenPage() {
    //measure
    ReadyBehaviour();
    //SendBehaviour();
    ResponsBehaviour();
  }
  setDataTampilan(data) async {
    dataTampilan = await data;
  }

  receiverTampilan() async {
    return await dataTampilan;
  }

  ResponsBehaviour() async {
    Messages msg = Messages();
    var data = await msg.receive();
    action() async {
      try {
        if (data.runtimeType == List<Map<String, Object?>>) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == String) {
          await setDataTampilan(data);
        }

        if (data.runtimeType == List<dynamic>) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == List<List<dynamic>>) {
          await setDataTampilan(data);
        }
      } catch (error) {
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
        if (data == "Application Setting Ready") {
          runApp(MaterialApp(
            title: 'Navigation Basics',
            home: Login(),
          ));
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }
}
