import 'package:firebaserealtimedatabase/main.dart';
import 'package:firebaserealtimedatabase/models/post_model.dart';
import 'package:firebaserealtimedatabase/pages/detail_page.dart';
import 'package:firebaserealtimedatabase/services/auth_service.dart';
import 'package:firebaserealtimedatabase/services/hive_DB.dart';
import 'package:firebaserealtimedatabase/services/realtime_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<Post> list = [];

  Future<void> _openDetailPage() async {
    bool? saveButtonIsPressed = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DetailPage()));
    if(saveButtonIsPressed != null && saveButtonIsPressed){
      loadData();
    }
  }

  void loadData() async {
    String id = await HiveDB.getUser();  // To get the user's ID
    RealtimeDB.GET(id).then((value) {
      setState(() {
        list = value;
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemRed,
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: (){
                AuthenticationService.signOut(context);
              }
          )
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            isThreeLine: true,
            title: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Text(list[index].fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Text('${list[index].date} \n${list[index].content}', maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          _openDetailPage();
        },
      ),
    );
  }
}
