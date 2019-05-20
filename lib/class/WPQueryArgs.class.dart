
/// A class to allow you to define specific arguments for your WPQuery instances in order to have a clean and efficient code
class WPQueryArgs {

  /// Scope under which the request is made; determines fields present in response.
  ///
  /// Allowed values :
  /// - `view`
  /// - `embed`
  /// - `editing`
  String context = "view";

  /// Current page of the collection.
  int page = 1;

  /// Maximum number of items to be returned in result set. Displays all posts if set to -1
  int perPage = 10;

  /// Limit results to those matching a string.
  String search;

  /// Limit response to posts published after a given ISO8601 compliant date.
  DateTime after;

  /// Limit response to posts published before a given ISO8601 compliant date.
  DateTime before;

  /// Limit result set to posts assigned to specific authors.
  List<int> author = [];

  /// Ensure result set excludes posts assigned to specific authors.
  List<int> authorExclude = [];

  /// Ensure result set excludes specific IDs.
  List<int> exclude = [];

  /// Limit result set to specific IDs.
  List<int> include = [];

  /// Offset the result set by a specific number of items.
  int offset;

  /// Order sort attribute ascending or descending.
  ///
  /// Allowed values :
  /// - `asc`
  /// - `desc`
  String order = "desc";

  /// Sort collection by object attribute.
  ///
  /// Allowed values :
  /// - `author`
  /// - `date`
  /// - `id`
  /// - `include`
  /// - `modified`
  /// - `parent`
  /// - `relevance`
  /// - `slug`
  /// - `include_slug`
  /// - `title`
  String orderBy = "date";

  /// Limit result set to posts with one or more specific slugs.
  List<String> slug;

  /// Limit result set to posts assigned one or more statuses.
  ///
  /// Allowed values :
  /// - `publish`
  /// - `future`
  /// - `draft`
  /// - `pending`
  /// - `private`
  /// - `trash`
  /// - `auto-draft`
  /// - `inherit`
  /// - `request-pending`
  /// - `request-confirmed`
  /// - `request-failed`
  /// - `request-completed`
  /// - `any`
  String status = "publish";

  /// Limit result set to all items that have the specified term assigned in the categories taxonomy.
  List<int> categories;

  /// Limit result set to all items except those that have the specified term assigned in the categories taxonomy.
  List<int> categoriesExclude;

  /// Limit result set to all items that have the specified term assigned in the tags taxonomy.
  List<int> tags;

  /// Limit result set to all items except those that have the specified term assigned in the tags taxonomy.
  List<int> tagsExclude;

  /// Limit result set to items that are sticky.
  bool sticky;

  WPQueryArgs({
    this.context = "view",
    this.perPage = 10,
    this.search,
    this.after,
    this.before,
    this.author,
    this.categories,
    this.sticky,
    this.status = "publish",
    this.slug,
    this.authorExclude,
    this.categoriesExclude,
    this.exclude,
    this.include,
    this.offset,
    this.order = "desc",
    this.orderBy = "date",
    this.tags,
    this.tagsExclude,
    this.page = 1
  });

  /// Convert all parameters to Object
  Object toObject(){
    return {
      "context" : (this.context != null) ? this.context : null,
      "per_page" : (this.perPage >= -1) ? this.perPage : 10,
      "search" : (this.search != null) ? this.search : null,
      "after" : (this.after != null) ? this.after : null,
      "before" : (this.before != null) ? this.before : null,
      "author" : (this.author != null) ? this.author : null,
      "categories" : (this.categories != null) ? this.categories : null,
      "sticky" : (this.sticky != null) ? this.sticky : null,
      "status" : (this.status != null) ? this.status : "publish",
      "slug" : (this.slug != null) ? this.slug : null,
      "author_exclude" : (this.authorExclude != null) ? this.authorExclude : null,
      "categories_exclude" : (this.categoriesExclude != null) ? this.categoriesExclude : null,
      "exclude" : (this.exclude != null) ? this.exclude : null,
      "include" : (this.include != null) ? this.include : null,
      "offest" : (this.offset != null) ? this.offset : null,
      "order" : (this.order != null) ? this.order : "desc",
      "orderby" : (this.orderBy != null) ? this.orderBy : "date",
      "tags" : (this.tags != null) ? this.tags : null,
      "tags_exclude" : (this.tagsExclude != null) ?this.tagsExclude : null,
      "page" : (this.page >= 1) ? this.page : 1
    };
  }

}