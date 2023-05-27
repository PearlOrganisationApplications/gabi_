

class ChannelDataModel {
  int _userId;
  String _channelName;
  String _status;
  String _createdAt;
  int _channelId;

  ChannelDataModel(this._userId, this._channelName, this._status,
      this._createdAt, this._channelId);

  int get channelId => _channelId;

  String get createdAt => _createdAt;

  String get status => _status;

  String get channelName => _channelName;

  int get userId => _userId;
}