import 'package:flutter/material.dart';
import '../models/scol_list.dart';
import '../util/dbuse.dart'; // Assurez-vous que ce chemin est correct

class ScolListDialog {
  final txtNonClass = TextEditingController();
  final txtNbreEtud = TextEditingController();

  Widget buildDialog(BuildContext context, ScolList list, bool isNew) {
    dbuse helper = dbuse();

    // Pré-remplissage des champs si l'élément existe déjà
    if (!isNew) {
      txtNonClass.text = list.nomClass;
      txtNbreEtud.text = list.nbreEtud.toString();
    }

    return AlertDialog(
      title: Text(isNew ? ' Class List' : 'Edit Class List'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtNonClass,
              decoration: InputDecoration(hintText: 'Class List Name'),
            ),
            TextField(
              controller: txtNbreEtud,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Number of Students'),
            ),
            ElevatedButton( // Utilisation de ElevatedButton
              child: Text('Save Class List'),
              onPressed: () {
                list.nomClass = txtNonClass.text;
                list.nbreEtud = int.parse(txtNbreEtud.text);
                if (isNew) {
                  helper.insertClass(list);
                } else {
                  // Handle updating the class here if necessary
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
