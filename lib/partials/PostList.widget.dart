import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wordpress_flutter/class/WPPost.class.dart';
import 'package:wordpress_flutter/class/WPQuery.class.dart';
import 'package:wordpress_flutter/class/WPQueryArgs.class.dart';
import 'package:wordpress_flutter/services/wordpress.service.dart';

// TODO tester tous les paramètres
// TODO faire une classe mère pour hériter
// TODO écrire les tests
// TODO écrire la doc
// TODO checker les imports
class PostList extends StatefulWidget {
  /// The number of items to display at each loading
  int perPage = 10;

  /// The Widget used to render the _buildLoadMoreRow() during the loading of new posts
  Widget loadMoreTemplate = Center(
      child : Padding(
          padding: EdgeInsets.all(15.0),
          child: CircularProgressIndicator()
      )
  );

  /// The query used to get Posts
  WPQuery query;


  PostList({
    Key key,
    this.perPage = 10,
    this.query,
    this.loadMoreTemplate
  }): super(key: key);
  
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  /// The array where all items are stored
  List<WPPost> _items = new List<WPPost>();

  /// The number of items to display at each loading
  int _perPage;

  /// Counts the number the posts currently displayed into the list
  int _present = 0;

  WPQuery _query;
  
  /// Fetch the posts
  void _loadMore() async {
    List<WPPost> fetchedPosts = await this._query.getNextPage();

    setState(() {
      this._items.addAll(fetchedPosts);
      this._present = this._present + this.widget.perPage;
    });
  }

  /// Build the ListView
  Widget _buildList() {
    // Detects if the users has reached the end of the current list and call _loadMore();
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !this._query.isLoading()) {
          this._loadMore();
        }
      },
      child: ListView.builder(
          itemCount: (this._present <= this._items.length) ? this._items.length + 1 : this._items.length,

          // If the current item displayed number is inferior to the number of original items, then we keep one space for the loadMore, otherwise, just the same lengthitemCount: (this._present <= this._items.length) ? this._items.length + 1 : this._items.length,
          itemBuilder: (context, index) {
            // Display the loadMore if we reached the end of the items list
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

  /// Render the template used for building a row
  Widget _buildRow(int rowIndex) {
    return  Container(
      padding: EdgeInsets.all(15.0),
      child: this._items[rowIndex].title
    );
  }

  /// Display the loadMore template as a row of the list
  Widget _buildLoadMoreRow() {
    return this.widget.loadMoreTemplate;
  }

  /// Init the state of the widget and call _loadMore() at the first rendering of the Widget
  @override
  void initState() {
    super.initState();
    if (this._query != null) {
      this._query = this._query;
    } else {
      this._query = new WPQuery(queryArgs: new WPQueryArgs(perPage: 10));
    }
    this._perPage = this._query.getPerPage();

    this._loadMore();
  }

  /// Build the widget
  @override
  Widget build(BuildContext context) {
      return this._buildList();
  }
}
