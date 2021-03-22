class ApiResponse {
  bool batchcomplete;
  Query query;

  ApiResponse({this.batchcomplete, this.query});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        batchcomplete: json["batchcomplete"],
        query: Query.fromJson(json["query"]),
      );

  Map<String, dynamic> toJson() => {
        "batchcomplete": batchcomplete,
        "query": query.toJson(),
      };
}

class Query {
  List<Page> pages;

  Query({this.pages});

  factory Query.fromJson(Map<String, dynamic> json) => Query(
      pages: json != null
          ? List<Page>.from(json["pages"].map((x) => Page.fromJson(x)))
          : null);

  Map<String, dynamic> toJson() =>
      {"pages": List<dynamic>.from(pages.map((x) => x.toJson()))} ;
}

class Page {
  int pageid;
  int ns;
  String title;
  int index;
  Thumbnail thumbnail;
  Terms terms;

  Page(
      {this.pageid,
      this.ns,
      this.title,
      this.index,
      this.thumbnail,
      this.terms});

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        pageid: json["pageid"],
        ns: json["ns"],
        title: json["title"],
        index: json["index"],
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
        terms: Terms.fromJson(json["terms"]),
      );

  Map<String, dynamic> toJson() => {
        "pageid": pageid,
        "ns": ns,
        "title": title,
        "index": index,
        "thumbnail": thumbnail.toJson(),
        "terms": terms.toJson()
      };
}

class Thumbnail {
  String source;
  int width;
  int height;

  Thumbnail({this.source, this.width, this.height});

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        source: json != null ? json["source"] ?? null : "",
        width: json != null ? json["width"] ?? 0 : 0,
        height: json != null ? json["height"] ?? 0 : 0,
      );

  Map<String, dynamic> toJson() => {
        "source": source,
        "width": width,
        "height": height,
      };
}

class Terms {
  List<String> description;

  Terms({this.description});

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
        description: json != null
            ? List<String>.from(json["description"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "description": List<String>.from(description.map((x) => x ?? "")),
      };
}
