import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tp5flutter/util/dbuse.dart';  // Import the database helper
import '../models/list_etudiants.dart';
import '../models/scol_list.dart';  // Import the model for the class
class dbuse {
  final int version = 1;
  Database? db;

  static final dbuse _dbHelper = dbuse._internal();

  dbuse._internal();
factory dbuse() {
  return _dbHelper;
}

Future<Database> openDb() async {
  if (db == null) {
    db = await openDatabase(
      join(await getDatabasesPath(), 'scol.db'),
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)');
        await database.execute(
            'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, FOREIGN KEY(codClass) REFERENCES classes(codClass))');
      },
      version: version,
    );
  }
  return db!;
}

Future<List<ScolList>> getClasses() async {
  await openDb(); // Assurez-vous que la DB est ouverte
  final List<Map<String, dynamic>> maps = await db!.query('classes');
  return List.generate(maps.length, (i) {
    return ScolList(
      maps[i]['codClass'],
      maps[i]['nomClass'],
      maps[i]['nbreEtud'],
    );
  });
}

Future<int> insertClass(ScolList list) async {
  await openDb(); // Assurez-vous que la DB est ouverte
  int codClass = await db!.insert(
    'classes',
    list.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return codClass;
}

Future<int> insertEtudiants(ListEtudiants etud) async {
  await openDb(); // Assurez-vous que la DB est ouverte
  int id = await db!.insert(
    'etudiants',
    etud.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return id;
}
  Future<void> deleteList(ScolList list) async {
    final db = await openDb();
    await db.delete(
      'classes',
      where: 'codClass = ?',
      whereArgs: [list.codClass],
    );
  }


  Future<List<ListEtudiants>> getEtudiants(int codClass) async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'etudiants',
      where: 'codClass = ?',
      whereArgs: [codClass],
    );

    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'],
        maps[i]['codClass'],
        maps[i]['nom'],
        maps[i]['prenom'], // Assurez-vous que le champ 'prenom' existe dans la BDD
        maps[i]['datNais'], // Assurez-vous que le champ 'datNais' existe dans la BDD
      );
    });
  }

  }


