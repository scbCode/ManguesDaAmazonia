import 'dart:async';
import 'dart:io';
import "package:flutter/widgets.dart";
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase   {

  static Database? _database;
  Jogador jogador = Jogador(nome: "-",fase_atual: "0", id: 1, som:1);

  Future initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jogador_mangue_.db");
    return await openDatabase(path, version: 8, onOpen: (db) {
      print("onOpen database");
      _database = db;
      }, onCreate: (Database db, int version) async {
      print("create database");
      await db.execute("CREATE TABLE Jogador ("
          "id INTEGER PRIMARY KEY,"
          "nome TEXT,"
          "som INTEGER,"
          "fase_atual TEXT"
          ")");
    });
  }

  setJogador(Jogador jogador) async {
    print("setJogador database");
    final db = await _database;
    var res = await db?.insert("Jogador", jogador.toMap()).onError((error, stackTrace) => resp(error));
    return res;
  }

  resp (var msg){
    print(msg);
  }

  getJogador(int id) async {
     final db = await _database;
     if (db==null)
       await initDB();
     print(db);
     var res = await db?.query("Jogador", where: "id = ?", whereArgs: [id]);
     print(res);
     return res!.isNotEmpty ? Jogador.fromMap(res.first) : null ;
  }

  updateJogador(Jogador jogador) async {
    final db = await _database;
    var res = await db?.update("Jogador", jogador.toMap(),
        where: "id = ?", whereArgs: [jogador.id]);
    return res;
  }
  updateSom(Jogador jogador) async {
    final db = await _database;
    var res = await db?.update("Jogador", jogador.toMap(),
        where: "id = ?", whereArgs: [jogador.id]);
    return res;
  }
}