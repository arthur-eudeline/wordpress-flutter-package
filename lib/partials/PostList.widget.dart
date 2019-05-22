import 'package:flutter/material.dart';
import 'package:wordpress_flutter/class/WPPost.class.dart';
import 'package:wordpress_flutter/class/WPQuery.class.dart';
import 'package:wordpress_flutter/class/WPQueryArgs.class.dart';
import 'package:wordpress_flutter/services/wordpress.service.dart';


class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  /// Contains all the posts loaded by the PostList
  List<WPPost> postList = [];

  Widget _buildList() {
    return ListView.builder(itemBuilder: (BuildContext context, int i) {
        return FutureBuilder(
            future: this.query.getNextPage(),
            builder: (BuildContext context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Ajouter un post pour continuer');
                  break;
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  if (snapshot.hasError)
                    return new Text('Error : ${snapshot.error}');
                  else if (snapshot.data.length > 1) {
                    List<Widget> output = [];
                    for (int i = 0; i < snapshot.data.length; i ++) {
                      output.add(Divider());
                      output.add(Padding(
                          padding: EdgeInsets.all(10.0),
                          child: snapshot.data[i].title
                      ));
                    }
                    return Column(
                        children: output
                    );
                  } else {
                    Divider();
                    return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: snapshot.data[0].title
                    );
                  }
              }
            }
        );


//      if (i < this.postList.length) {
//        if (i.isOdd) {
//          return Divider();
//        }
//
//        return this._buildListRow(this.postList[i]);
//      } else {
//        this._fetchPosts();
//      }
    });
  }

  Widget _buildListRow(data) {
    return data.title;
  }

  int _fetchCounter = 0;
  void _fetchPosts() async {
    if (!this.query.isLoading()) {
      _fetchCounter++;
      print("--- FetchCount : $_fetchCounter ---");
      final posts = await this.query.getNextPage();
      setState(() {
        if (postList.length > 0) {
          postList = [...postList, ...posts];
        } else {
          postList = posts;
        }
      });
    }
  }

  WPQuery query = new WPQuery(queryArgs: new WPQueryArgs(perPage: 2));

//  loadPost() {
//    setState(() {
//      this.list.add(FutureBuilder(
//        future: query.getNextPage(),
//        builder: (BuildContext context, snapshot) {
//          switch (snapshot.connectionState) {
//            case ConnectionState.none:
//              return new Text('Ajouter un post pour continuer');
//              break;
//            case ConnectionState.waiting:
//              return new Text('Chargement...');
//              break;
//            default:
//              if (snapshot.hasError)
//                return new Text('Error : ${snapshot.error}');
//              else
//                if (snapshot.data.length > 1) {
//                  List<Widget> output = [];
//                  for (int i = 0; i < snapshot.data.length; i ++){
//                    output.add(snapshot.data[i].title);
//                  }
//                  return Column(
//                      children: output
//                  );
//                } else {
//                  return snapshot.data[0].title;
//                }
//          }
//        },
//      ));
//    });
//  }

//  void resetQuery(){
//    this.setState(() {
//      this.list = [];
//      this.query.reset();
//    });
//  }

  @override
  Widget build(BuildContext context) {
      return this._buildList();

//    return Container(
//      child: Column(
//        children: <Widget>[
//          ConstrainedBox(
//            constraints: BoxConstraints(
//                maxHeight: MediaQuery.of(context).size.height - 150),
////            child: ListView(
////              children: list,
////            ),
//            child : Column(
//              children: list,
//            )
//          ),
//          Row(
//            children: <Widget>[
//              OutlineButton(
//                onPressed: () {
//                  this.loadPost();
//                },
//                color: Colors.blue,
//                textColor: Colors.blue,
//                splashColor: Colors.blue,
//                highlightColor: Colors.blue,
//                child: Text('Ajouter un post'),
//              ),
//              OutlineButton(
//                onPressed: () {
//                  this.resetQuery();
//                },
//                child: Text('Reset Query'),
//              )
//            ],
//          )
//        ],
//      ),
//    );
  }
}
