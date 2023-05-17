

class TrendingModel {
  int? _id;
  String? _title;
  String? _img;
  String? _url;
  String? _createdAt;
  String? _updatedAt;

  TrendingModel({int? id,
    String? title,
    String? img,
    String? url,
    String? createdAt,
    String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (img != null) {
      this._img = img;
    }
    if (url != null) {
      this._url = url;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int? get id => _id;

  set id(int? id) => _id = id;

  String? get title => _title;

  set title(String? title) => _title = title;

  String? get img => _img;

  set img(String? img) => _img = img;

  String? get url => _url;

  set url(String? url) => _url = url;

  String? get createdAt => _createdAt;

  set createdAt(String? createdAt) => _createdAt = createdAt;

  String? get updatedAt => _updatedAt;

  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  TrendingModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _img = json['img'];
    _url = json['url'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
}