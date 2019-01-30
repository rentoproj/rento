import 'package:flutter/material.dart';
import 'package:rento/components/itemBlock1.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home Page'),
                onTap: (){Navigator.of(context).pushReplacementNamed('/SearchPage');},
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Rental Histroy'),
                onTap: (){Navigator.of(context).pushReplacementNamed('/RentalHistory');},
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: (){Navigator.of(context).pushReplacementNamed('/LoginScreen2');},
              ),
            ],
          ),
        ),
      body: new Item1("")

    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final recentSearch = ["bicycle", "raincoeat"];
  final search = ["bicycle", "raincoeat"];
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icons
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // results
    if (!(query.length == 0 || recentSearch.contains(query)))
      recentSearch.add(query);
    return  Item1(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty
        ? recentSearch
        : search.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          query = suggestionList[index];
          showResults(context);
        },
        leading: Icon(Icons.history),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey)),
                ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}