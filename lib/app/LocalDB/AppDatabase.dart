import 'dart:async';
import 'dart:io';
import "package:flutter/widgets.dart";
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase   {

  late Database _database;
  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await Directory.current;
    String path = (documentsDirectory.path+ "/jogador.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Jogador ("
          "id INTEGER PRIMARY KEY,"
          "nome TEXT,"
          "pontos TEXT,"
          "faseAtual TEXT"
          ")");
    });
  }


  setJogador(Jogador jogador) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into Jogador (id,nome)"
            " VALUES (${jogador.id},${jogador.nome})");
    return res;
  }

  getJogador(int id) async {
    final db = await database;
    var res =await  db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Jogador.fromMap(res.first) : Null ;
  }

}