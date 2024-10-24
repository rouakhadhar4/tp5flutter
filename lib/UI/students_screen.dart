import 'package:flutter/material.dart';
import '../models/list_etudiants.dart';
import '../models/scol_list.dart';
import '../util/dbuse.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  StudentsScreen(this.scolList);

  @override
  _StudentsScreenState createState() => _StudentsScreenState(this.scolList);
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScolList scolList;
  late dbuse helper; // Declare helper with late to initialize it later
  List<ListEtudiants> students = []; // Initialize the list

  _StudentsScreenState(this.scolList);

  @override
  void initState() {
    super.initState();
    helper = dbuse(); // Initialize helper in initState
    showData(this.scolList.codClass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scolList.nomClass),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(students[index].nom),
            subtitle: Text(
              'Prenom: ${students[index].prenom} - Date Nais: ${students[index].datNais}',
            ),
            onTap: () {},
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }

  Future<void> showData(int idList) async {
    await helper.openDb();
    students = await helper.getEtudiants(idList);
    setState(() {
      students = students;
    });
  }
}
