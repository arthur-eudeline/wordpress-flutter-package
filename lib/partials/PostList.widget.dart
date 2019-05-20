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
      if (i <= this.postList.length) {
        if (i.isOdd) {
          return Divider();
        }

        // If we reach the end of the list
        final int index = i ~/ 2;
        if (index >= this.postList.length) {
          // TODO ajouter posts
          this._fetch();
          print('fin');
        }

        return this._buildListRow(this.postList[index]);
      } else {
        this._fetch();
      }
    });
  }

  Widget _buildListRow(data) {
    return data.title;
  }

  void _fetch() async {
    final posts = await WordPress.getLastPosts();
    setState(() {
      if (postList.length > 0) {
        postList = [...postList, ...posts];
      } else {
        postList = posts;
      }
    });
  }

  List<Widget> list = [];
  WPQuery query = new WPQuery(queryArgs: new WPQueryArgs(perPage: 2));

  loadPost() {
    setState(() {
      this.list.add(FutureBuilder(
        future: query.getNextPage(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Ajouter un post pour continuer');
              break;
            case ConnectionState.waiting:
              return new Text('Chargement...');
              break;
            default:
              if (snapshot.hasError)
                return new Text('Error : ${snapshot.error}');
              else
                if (snapshot.data.length > 1) {
                  List<Widget> output = [];
                  for (int i = 0; i < snapshot.data.length; i ++){
                    output.add(snapshot.data[i].title);
                  }
                  return Column(
                      children: output
                  );
                } else {
                  return snapshot.data[0].title;
                }
          }
        },
      ));
    });
  }

  void resetQuery(){
    this.setState(() {
      this.list = [];
      this.query.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
//    if (postList.length > 0) {
//      return this._buildList();
//    } else {
//      this._fetch();
//      return Text('test');
//    }

    return Container(
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 150),
//            child: ListView(
//              children: list,
//            ),
            child : Column(
              children: list,
            )
          ),
          Row(
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  this.loadPost();
                },
                color: Colors.blue,
                textColor: Colors.blue,
                splashColor: Colors.blue,
                highlightColor: Colors.blue,
                child: Text('Ajouter un post'),
              ),
              OutlineButton(
                onPressed: () {
                  this.resetQuery();
                },
                child: Text('Reset Query'),
              )
            ],
          )
        ],
      ),
    );
  }
}
