import 'dart:convert';

ExploreAllBook exploreAllBookFromJson(String str) =>
    ExploreAllBook.fromJson(json.decode(str));

String exploreAllBookToJson(ExploreAllBook data) => json.encode(data.toJson());

class ExploreAllBook {
  ExploreAllBook({
    required this.ebookApp,
  });

  final List<EbookApp> ebookApp;

  factory ExploreAllBook.fromJson(Map<String, dynamic> json) => ExploreAllBook(
        ebookApp: List<EbookApp>.from(
            json["EBOOK_APP"].map((x) => EbookApp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EBOOK_APP": List<dynamic>.from(ebookApp.map((x) => x.toJson())),
      };
}

class EbookApp {
  EbookApp({
    required this.id,
    required this.catId,
    required this.aid,
    required this.bookTitle,
    required this.bookDescription,
    required this.bookCoverImg,
    required this.bookBgImg,
    required this.bookFileType,
    required this.bookFileUrl,
    required this.totalRate,
    required this.rateAvg,
    required this.bookViews,
    required this.authorId,
    required this.authorName,
    required this.authorDescription,
    required this.cid,
    required this.categoryName,
    required this.categoryImage,
  });

  final String id;
  final String catId;
  final String aid;
  final String bookTitle;
  final String bookDescription;
  final String bookCoverImg;
  final dynamic bookBgImg;
  final BookFileType? bookFileType;
  final String bookFileUrl;
  final String totalRate;
  final String rateAvg;
  final String bookViews;
  final String authorId;
  final String authorName;
  final String authorDescription;
  final String cid;
  final String categoryName;
  final String categoryImage;

  factory EbookApp.fromJson(Map<String, dynamic> json) => EbookApp(
        id: json["id"],
        catId: json["cat_id"],
        aid: json["aid"],
        bookTitle: json["book_title"],
        bookDescription: json["book_description"],
        bookCoverImg: json["book_cover_img"],
        bookBgImg: json["book_bg_img"],
        bookFileType: bookFileTypeValues.map[json["book_file_type"]],
        bookFileUrl: json["book_file_url"],
        totalRate: json["total_rate"],
        rateAvg: json["rate_avg"],
        bookViews: json["book_views"],
        authorId: json["author_id"],
        authorName: json["author_name"],
        authorDescription: json["author_description"],
        cid: json["cid"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id": catId,
        "aid": aid,
        "book_title": bookTitle,
        "book_description": bookDescription,
        "book_cover_img": bookCoverImg,
        "book_bg_img": bookBgImg,
        "book_file_type": bookFileTypeValues.reverse[bookFileType],
        "book_file_url": bookFileUrl,
        "total_rate": totalRate,
        "rate_avg": rateAvg,
        "book_views": bookViews,
        "author_id": authorId,
        "author_name": authorName,
        "author_description": authorDescription,
        "cid": cid,
        "category_name": categoryName,
        "category_image": categoryImage,
      };
}

enum BookFileType { SERVER_URL, LOCAL }

final bookFileTypeValues = EnumValues(
    {"local": BookFileType.LOCAL, "server_url": BookFileType.SERVER_URL});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
