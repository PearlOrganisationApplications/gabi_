class CommentModel {
  String _comment;
  String _peerId;

  CommentModel(this._comment, this._peerId);

  String get peerId => _peerId;

  set peerId(String value) {
    _peerId = value;
  }

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
  }
}