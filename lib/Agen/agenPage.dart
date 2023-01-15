import 'package:admin_pelayanan_katolik/login.dart';
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
  setDataTampilan(data) {
    dataTampilan = data;
  }

  receiverTampilan() {
    return dataTampilan;
  }

  ResponsBehaviour() async {
    Messages msg = Messages();
    var data = msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<Map<String, Object?>>) {
          setDataTampilan(data);
        }
        if (data.runtimeType == String) {
          setDataTampilan(data);
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
        if (data == "Done") {
          return data;
        }

        if (data == "ready") {
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
