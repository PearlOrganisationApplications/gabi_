

class RecentlyPlayedModel {
  int? _id;
  String? _title;
  String? _uploadedBy;
  String? _publishedBy;
  String? _duration;
  String? _description;
  String? _img;
  String? _file;
  String? _createdAt;
  String? _updatedAt;

  RecentlyPlayedModel(
      {int? id,
        String? title,
        String? uploadedBy,
        String? publishedBy,
        String? duration,
        String? description,
        String? img,
        String? file,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (uploadedBy != null) {
      this._uploadedBy = uploadedBy;
    }
    if (publishedBy != null) {
      this._publishedBy = publishedBy;
    }
    if (duration != null) {
      this._duration = duration;
    }
    if (description != null) {
      this._description = description;
    }
    if (img != null) {
      this._img = img;
    }
    if (file != null) {
      this._file = file;
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
  String? get uploadedBy => _uploadedBy;
  set uploadedBy(String? uploadedBy) => _uploadedBy = uploadedBy;
  String? get publishedBy => _publishedBy;
  set publishedBy(String? publishedBy) => _publishedBy = publishedBy;
  String? get duration => _duration;
  set duration(String? duration) => _duration = duration;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get img => _img;
  set img(String? img) => _img = img;
  String? get file => _file;
  set file(String? file) => _file = file;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  RecentlyPlayedModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _uploadedBy = json['uploaded_by'];
    _publishedBy = json['published_by'];
    _duration = json['duration'];
    _description = json['description'];
    _img = json['img'];
    _file = json['file'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['uploaded_by'] = this._uploadedBy;
    data['published_by'] = this._publishedBy;
    data['duration'] = this._duration;
    data['description'] = this._description;
    data['img'] = this._img;
    data['file'] = this._file;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}