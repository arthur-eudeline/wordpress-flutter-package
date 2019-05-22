import 'package:wordpress_flutter/class/WPPost.class.dart';
import 'package:wordpress_flutter/class/WPQueryArgs.class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO gérer les exceptions
// TODO gérer les errors HTTP 
class WPQuery {

  /// The number of posts that have been displayed until now
  int _postCount;

  /// The number of posts that have been found with the parameters passed to the query
  int _foundPost;

  /// The number of the last page of results
  int _maxNumPage;

  /// The current page of the query
  int _currentPage = 1;

  /// If the query has posts or not
  bool _havePost = true;

  /// The list of errors encountered by the query
  List<Object> _errors = [];

  /// If the query is currently loading or not
  bool _loading = false;

  /// The URL corresponding to the query
  String _query = "";

  /// The type of posts that the query should returns
  String postType = "posts";

  /// The args used by the query
  WPQueryArgs queryArgs;

  /// The http client of the query, used to make HTTP calls
  http.Client _http = new http.Client();

  /// If the query has posts or not
  bool havePost() {
    return this._havePost;
  }

  /// Get an argument of the query
  dynamic get(String argName) {}

  /// Set an argument of the query
  void set(String argName, argValue){}

  /// If the current query has errors
  bool hasError(){
    if (this._errors.length > 1) {
      return true;
    } else {
      return false;
    }
  }

  /// Get a list of WPPost from the next result page of the query
  Future<List<WPPost>> getNextPage() async{
    return await this.getPage(this._currentPage + 1);
  }

  /// Get a list of WPPost from the previous result page of the query
  Future<List<WPPost>> getPrevPage() async{
    return await this.getPage(this._currentPage - 1);
  }

  /// Get a list of WPPost from the given result page.
  Future<List<WPPost>> getPage(int pageNum) async{

    // TODO: put it in an env file or whatever
    const String _siteDomain = "www.starwars.com";
    const String _siteUrl = "https://$_siteDomain/news/";
    const String _restUrl = "${_siteUrl}wp-json/wp/v2/";

    // Write of the URL request and update of the Query _currentPage
    this._currentPage = pageNum;
    String url = _restUrl + "${this.postType}/${this.buildQuery()}${this._currentPage}";

    this._loading = true;

    // HTTP call
    final response = await this._http.get(url);

    // If the response is OK
    if (response.statusCode == 200) {
      var results = json.decode(response.body);

      // Creation of the WPPost list
      List<WPPost> output = [];
      for (int i = 0; i < results.length; i++){
        output.add(WPPost.fromJson(results[i]));
      }

      this._loading = false;
      return output;
    }

    /// Else there is en error
    else {
      this._loading = false;
      // TODO handle errors
      throw Exception('error');
    }
  }

  /// If the current query is loading
  bool isLoading(){
    return this._loading;
  }

  /// Add an error to the errors list
  void _addError(Object errorData){
    this._errors.add(errorData);
  }

  Future<List<WPPost>> getResults() async{
    // TODO code and document getResults()
  }

  /// Build the URI request from the WPQueryArgs of the current WPQuery and stock it into this._query. If the query has already been built, the method simply returns it. Otherwise, if it's not built or if the build is forced, the request is built again
  String buildQuery({bool forceRewrite = false}){
    if (forceRewrite || this._query == "") {
      String output = "?";

      var argsObject = Map.from(this.queryArgs.toObject());
      argsObject.forEach((paramName, paramValue) {
        if (paramValue != null && paramName != "page") {
          // If the value is an array, like author or tags, we format it like that : {key}[]=1&{key}[]=2
          if (paramValue is List<dynamic>) {
            paramValue.forEach((subValue) {
              output = "$output$paramName[]=$subValue";
            });
          }
          // Else we just add it to the query string with {key}={value} format
          else {
            output = "$output$paramName=$paramValue";
          }

          // Add the & between each parameter
          output = "$output&";
        }
      });

      // Save the Query Page number
      this._currentPage = argsObject['page'];

      output = "${output}page=";

      this._query = output;

      return output;
    } else {
      return this._query;
    }
  }

  /// Reset the query
  void reset(){
    this._currentPage = queryArgs.page;
    this._errors = [];
    this._loading = false;
    this._havePost = true;
  }

  int getPerPage() {
    return this.queryArgs.perPage;
  }

  WPQuery({
    this.queryArgs,
    this.postType = "posts",
  });
}