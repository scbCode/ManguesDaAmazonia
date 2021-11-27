import 'dart:async';
import 'dart:html';
import 'dart:io';
import "package:flutter/widgets.dart";
import 'package:mangues_da_amazonia/app/Models/Jogador.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase   {

  late Database _database;
  Jogador jogador = Jogador(pontos: 0,nome: "teste",faseAtual: "0", id: 100);

  initDB() async {
    Directory documentsDirectory = await Directory.current;
    String path = (documentsDirectory.path+ "/jogador.db");
    _database = await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("""CREATE TABLE Jogador ("
          "id INTEGER PRIMARY KEY,"
          "nome TEXT,"
          "pontos TEXT,"
          "faseAtual TEXT"
          """);
    });
    setJogador(jogador);

  }

  setJogador(Jogador jogador) async {
    final db = await _database;
    var res = await db.insert("Jogador",jogador.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
    return res;
  }

  dynamic getJogador(int id) async {
    final db = await _database;
    var res =await  db.query("Jogador");
    return res.isNotEmpty ? Jogador.fromMap(res.first) : Null ;
  }

}