import 'dart:async';
import 'dart:io';
import "package:flutter/widgets.dart";
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase   {

  Database? _database;
  Jogador jogador = Jogador(nome: "-",fase_atual: "0", id: 1);

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jogador_mangue_.db");
    return await openDatabase(path, version: 7, onOpen: (db) {
      print("onOpen database");
      // db.rawInsert(
      // "INSERT Into Jogador (id,nome,fase_atual,pontos)"+
      // " VALUES (${jogador.id},${jogador.nome},${jogador.fase_atual.toString()},${jogador.pontos.toString()})",
      //     [jogador.id,jogador.nome,jogador.fase_atual,jogador.pontos]);
      _database = db;
      }, onCreate: (Database db, int version) async {
      print("create database");
      await db.execute("CREATE TABLE Jogador ("
          "id INTEGER PRIMARY KEY,"
          "nome TEXT,"
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
     var res = await db?.query("Jogador", where: "id = ?", whereArgs: [id]);
     return res!.isNotEmpty ? Jogador.fromMap(res.first) : null ;
  }

  updateJogador(Jogador jogador) async {
    final db = await _database;
    var res = await db?.update("Jogador", jogador.toMap(),
        where: "id = ?", whereArgs: [jogador.id]);
    return res;
  }

}