import 'dart:async';
import 'package:admin_pelayanan_katolik/Agen/Message.dart';
import 'package:admin_pelayanan_katolik/Agen/MessagePassing.dart';
import 'package:admin_pelayanan_katolik/Agen/Task.dart';
import 'package:admin_pelayanan_katolik/Agen/agenPage.dart';
import 'package:admin_pelayanan_katolik/view/logIn.dart';
import 'package:flutter/material.dart';

Future callDb() async {
  Completer<void> completer = Completer<void>();
  Messages message = Messages('Agent Page', 'Agent Setting', "REQUEST", Tasks('setting user', null));

  MessagePassing messagePassing = MessagePassing();
  var data = await messagePassing.sendMessage(message);
  var hasilPencarian = await AgentPage.getData();

  completer.complete();

  await completer.future;
  return await hasilPencarian;
}

void main() async {
  var hasil = await callDb();
  if (hasil == "oke") {
    runApp(await MaterialApp(
      title: 'Navigation Basics',
      home: logIn(),
    ));
  } else {
    print("Application setting error");
  }
}
