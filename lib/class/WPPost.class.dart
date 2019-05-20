import 'package:flutter_html/flutter_html.dart';

/// A class to allow you to interact properly with WP_Posts
class WPPost {
  /// ID of the Post
  final int id;

  /// Date where the post has been created the first time
  final DateTime date;

  /// Date where the post has been created the first time in GMT time
  final DateTime dateGmt;

  /// Date where the post has been modified the last time
  final DateTime modified;

  /// Date where the post has been modified the last time in GMT time
  final DateTime modifiedGmt;

  /// The slug of the post, a url friendly version of the post title
  final String slug;

  /// The current status of the post. Can be set at :
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
  final String status;

  /// The post type. For a post, it will be "post", for a page "page". Can also be the name of a custom post type such as "product", "order", "comment", ...
  final String type;

  /// The URL to the post on the website
  final String link;

  /// The title of the post, containing HTML tags converted in flutter Widgets
  final Html title;

  /// The title of the post, containing the HTML tags
  final String titleRaw;

  /// The content of the post, containing HTML tags converted in flutter Widgets
  final Html content;

  /// The content of the post, containing the HTML tags
  final String contentRaw;

  /// The excerpt of the post, containing HTML tags converted in flutter Widgets
  final Html excerpt;

  /// The excerpt of the post, containing the HTML tags
  final String excerptRaw;

  /// The ID of the author who has written the article
  final int author;

  /// The WP Media used as a thumbnail of the post
  final featuredMedia;

  /// If the post is sticky, which means that the post is featured, on top of the list, ...
  final bool sticky;

  /// The format of the post. It can hold some informations of how the post should be rendered, with a specific layout for example
  final String format;

  /// The list of the meta data of the post, that can contains literally everything
  final List<dynamic> meta;

  /// The list of the categories IDs of the post
  final List<dynamic> categories;

  /// The list of the tags IDs of the post;
  final List<dynamic> tags;

  /// Create a WPPost using a JSON array, useful when you use a WordPress Rest API
  factory WPPost.fromJson(Map<String, dynamic> json) {
    return WPPost(
      id : json['id'],
      date : DateTime.parse(json['date']),
      dateGmt: DateTime.parse(json['date_gmt']),
      modified: DateTime.parse(json['modified']),
      modifiedGmt: DateTime.parse(json['modified_gmt']),
      slug: json['slug'],
      status: json['slug'],
      type: json['link'],
      title: Html(data: json['title']['rendered'] ),
      titleRaw: json['title']['rendered'],
      content : Html(data: json['content']['rendered']),
      contentRaw: json['content']['rendered'],
      excerpt: Html(data: json['excerpt']['rendered']),
      excerptRaw: json['excerpt']['rendered'],
      author: json['author'],
      featuredMedia: json['featured_media'],
      sticky: json['sticky'],
      format: json['format'],
      meta: json['meta'],
      categories: json['categories'],
      tags: json['tags']
    );
  }

  WPPost({
    this.id,
    this.date,
    this.dateGmt,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.titleRaw,
    this.content,
    this.contentRaw,
    this.excerpt,
    this.excerptRaw,
    this.author,
    this.featuredMedia,
    this.sticky,
    this.format,
    this.meta,
    this.categories,
    this.tags
  });
}
