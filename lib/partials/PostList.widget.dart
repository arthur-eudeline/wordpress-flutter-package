import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wordpress_flutter/class/WPPost.class.dart';
import 'package:wordpress_flutter/class/WPQuery.class.dart';
import 'package:wordpress_flutter/class/WPQueryArgs.class.dart';
import 'package:wordpress_flutter/services/wordpress.service.dart';


class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  List<WPPost> _items = new List<WPPost>();

  int _perPage = 10;

  int _present = 0;

  Widget loadMoreTemplate = Center(
    child : Padding(
      padding: EdgeInsets.all(15.0),
      child: CircularProgressIndicator()
    )
  );

  WPQuery _query = new WPQuery(queryArgs: new WPQueryArgs(perPage: 10));

  bool _loading = false;

  // TODO remove
  int _loadCount = 0;

  void _loadMore() async {
    setState(() {
      this._loading = true;
    });

    _loadCount++;
    print("--- Load $_loadCount ---");

    List<WPPost> fetchedPosts = await this._query.getNextPage();

    setState(() {
      this._items.addAll(fetchedPosts);
      this._present = this._present + this._perPage;
      this._loading = false;
    });
  }

  Widget _buildList() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          print("loadingStart");
          if (!this._loading) {
            this._loadMore();
          }
        }
      },
      child: ListView.builder(
        // If the current item displayed number is inferior to the number of original items, then we keep one space for the loadMore button, otherwise, just the same length
          itemCount: (this._present <= this._items.length) ? this._items.length + 1 : this._items.length,
          itemBuilder: (context, index) {
            // Display the button if we reached the end of the items list
            if (index == this._items.length ) {
              return this._buildLoadMoreRow();
            }

            // Display an item
            else {
              return this._buildRow(index);
            }
          }
      ),
    );
  }

  Widget _buildRow(int index) {
    return  Container(
      padding: EdgeInsets.all(15.0),
      child: _items[index].title
    );
  }

  Widget _buildLoadMoreRow() {
    return this.loadMoreTemplate;
  }

  final List<String> __originalItems = List<String>.generate(10000, (i) => "Item $i");
  @override
  void initState() {
    super.initState();
    this._loadMore();
  }

  @override
  Widget build(BuildContext context) {
      return this._buildList();
  }
}
