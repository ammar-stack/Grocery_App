import 'package:flutter/material.dart';
import 'package:gorcery_app/Services/dbhelper.dart';
import 'package:gorcery_app/Services/grocerymodal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final addGroceryController = TextEditingController();
  final editGroceryController = TextEditingController();

  Future<List<GroceryModal>>? dataNew;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  refreshNotes() {
    dataNew = Dbhelper.instance.GetGroceries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Grocery App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Add a Grocery"),
              content: TextField(
                controller: addGroceryController,
                decoration: InputDecoration(hintText: 'Enter Grocery'),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    addgrocery(addGroceryController.text);
                    addGroceryController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                  ),
                  child: Text(
                    "Add Grocery",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.shopping_basket),
      ),
      body: FutureBuilder<List<GroceryModal>>(
        future: dataNew,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text("No Groceries added yet"));
          } else {
            final dataCurrent = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: dataCurrent!.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.greenAccent,
                    child: ListTile(
                      title: Text(dataCurrent[index].GroceryColumn.toString()),
                      trailing: IconButton(
                        onPressed: () {
                          Dbhelper.instance.DeleteGrocery(
                            GroceryModal(id: dataCurrent[index].id),
                          );
                          refreshNotes();
                        },
                        icon: Icon(Icons.delete),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            editGroceryController.text = dataCurrent[index]
                                .GroceryColumn
                                .toString();
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Edit Grocery"),
                                content: TextField(
                                  controller: editGroceryController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Grocery',
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Dbhelper.instance.UpdateGrocery(
                                        GroceryModal(
                                          id: dataCurrent[index].id,
                                          GroceryColumn:
                                              editGroceryController.text,
                                        ),
                                      );
                                      editGroceryController.clear();
                                      refreshNotes();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                    ),
                                    child: Text(
                                      "Edit Grocery",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  addgrocery(String Data) async {
    await Dbhelper.instance.InsertGrocery(GroceryModal(GroceryColumn: Data));
    refreshNotes();
    Navigator.pop(context);
  }
}
