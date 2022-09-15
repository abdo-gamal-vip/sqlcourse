import 'package:flutter/material.dart';
import 'package:sqlcourse/sqldb.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb _sqlDb = SqlDb();
  bool isLoading = true;
  List notess = [];

  Future<List<Map>> readData() async {
    List<Map> response = await _sqlDb.readData("SELECT * FROM 'notes'");
    notess.addAll(response);
    isLoading = false;

    if (mounted) {
      setState(() {});
    }
    return response;
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: Text("boody"),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: notess.length,
                          itemBuilder: ((context, index) {
                            if (notess.isNotEmpty) {
                              return Card(
                                child: ListTile(
                                    title: Text("${notess[index].toString()}")),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          })),
                      HomeTest(),
                    ],
                  ),
                ),
              )),
    );
  }
}

class HomeTest extends StatefulWidget {
  HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  SqlDb sqlDb = SqlDb();
  TextEditingController controller = TextEditingController();
  Home home = Home();
  Future get readData async {
    if (readData == null) {
      print(null);
    }
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 400,
        width: double.infinity,
        child: Column(children: [
          TextFormField(controller: controller, key: formkey),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  int response = await sqlDb.insertData(
                      "INSERT INTO 'notes' ('note' , 'color') VALUES ('note two','yellow')");
                  print(response);
                },
                child: Text("insert button")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  List<Map> response =
                      await sqlDb.readData("SELECT * FROM 'notes'");
                  print(response);
                },
                child: Text("show data ")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  int response = await sqlDb.updateData(
                      "UPDATE 'notes' SET `note` = 'one two f' WHERE `id` = ${controller.text}");
                  if (response > 0) {
                    // home.notess.removewhere((element)=> element['id']==home.notess[i][])
                  }
                  print(response);
                },
                child: Text("update data ")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  int response = await sqlDb.deleteData(
                      "DELETE FROM 'notes' WHERE `id` = ${controller.text}");
                  setState(() {
                    RefreshIndicator(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        onRefresh: () async {
                          setState(() async {});
                        });
                  });

                  print(response);
                },
                child: Text("delete Data ")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await sqlDb.mydeleteDatabase();
                },
                child: Text("DELETE DATA BASE ")),
          ),
        ]),
      ),
    ]);
  }
}
