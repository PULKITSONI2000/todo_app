import 'package:flutter/material.dart';
import 'dart:async';
import '../database_helper.dart';
import '../Note.dart';
import 'note_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';


class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;



  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: (){
          navigateToDetails(Note('','',2), 'Add Note');
        },
      ),
    drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("PULKITSONI"),
              accountEmail: Text("pulkitsoni2000@gmial.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("images/avatar.jpg"),
              ),
            ),            
            
            ListTile(
              title: Text("Contact Developer",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              // leading: Icon(Icons.devices),
            ),
              ListTile(
              title: Text("Pulkit Soni"),
              leading: Icon(Icons.person),
            ),
            ListTile(
              title: Text("pulkitsoni2000@gmail.com"),
              leading: Icon(Icons.email),
            ),
            ListTile(
              title: Text("+91 8619006876"),
              leading: Icon(Icons.phone),
            ),

            Divider(),
            ListTile(
              title: Text("GitHub"),
              leading: Icon(Icons.code),
              onTap: _launchURL,
            ),

            Divider(),

            ListTile(
              title: Text("Close"),
              trailing: Icon(Icons.close),
              onTap: ()=> Navigator.of(context).pop(),
            )
          ],
        ),
      )
    );  
  }

  _launchURL() async {
  const url = 'https://github.com/PULKITSONI2000';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  ListView getNoteListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context,position){
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.deepPurple,
          elevation: 4.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/avatar.jpg'),
            ),
            title: Text(this.noteList[position].title,
            style: TextStyle(
              color: Colors.white,
              fontWeight:FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          subtitle: Text(this.noteList[position].date,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: GestureDetector(
            child: Icon(
              Icons.open_in_new,
              color: Colors.white,
            ),
            onTap: (){
              navigateToDetails(this.noteList[position], 'Edit ToDo');
            }
          ),
          ),
        );
      }
    );
  }

  void navigateToDetails(Note note,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return NoteDetail(title,note);
      }
    ));
    if (result == true) {
      updateListView();
    }
  }
  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}