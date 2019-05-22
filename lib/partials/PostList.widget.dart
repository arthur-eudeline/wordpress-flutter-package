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

  List<String> _items = new List<String>();

  int _perPage = 10;

  int _present = 0;

  Widget loadMoreTemplate = Center(
    child : Padding(
      padding: EdgeInsets.all(15.0),
      child: CircularProgressIndicator()
    )
  );

  WPQuery _query = new WPQuery(queryArgs: new WPQueryArgs(perPage: 2));

  bool _loading = false;

  // TODO remove
  int _loadCount = 0;

  void _loadMore() async {
    setState(() {
      this._loading = true;
    });

    _loadCount++;
    print("--- Load $_loadCount ---");

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      if((_present + _perPage ) > __originalItems.length) {
        _items.addAll(
            __originalItems.getRange(_present, __originalItems.length));
      } else {
        _items.addAll(
            __originalItems.getRange(_present, _present + _perPage));
      }
      _present = _present + _perPage;
      _loading = false;
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
    return ListTile(
      title : Text(_items[index])
    );
  }

  Widget _buildLoadMoreRow() {
    return this.loadMoreTemplate;
  }

  final List<String> __originalItems = List<String>.generate(10000, (i) => "Item $i");
  @override
  void initState() {
    super.initState();
    setState(() {
      _items.addAll(__originalItems.getRange(_present, _present + _perPage));
      _present = _present + _perPage;
    });
  }

  @override
  Widget build(BuildContext context) {
      return this._buildList();
  }
}
