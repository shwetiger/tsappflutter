// @dart=2.9
class AppVersion {
  String versionCode;
  String douwnloadLink;
  String lowestVersion;
  String versionDesc;
  String internalTestingLink;
  String appName;
  String fileSize;

  AppVersion({
    this.versionCode,
    this.douwnloadLink,
    this.lowestVersion,
    this.versionDesc,
    this.internalTestingLink,
    this.appName,
    this.fileSize,
  });

  AppVersion.fromJson(Map<String, dynamic> json) {
    versionCode = json['versionCode'];
    douwnloadLink = json['douwnloadLink'];
    lowestVersion = json['lowestVersion'];
    versionDesc = json['versionDesc'];
    internalTestingLink = json['internalTestingLink'];
    appName = json['appName'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['versionCode'] = this.versionCode;
    data['douwnloadLink'] = this.douwnloadLink;
    data['lowestVersion'] = this.lowestVersion;
    data['versionDesc'] = this.versionDesc;
    data['internalTestingLink'] = this.internalTestingLink;
    data['appName'] = this.appName;
    data['fileSize'] = this.fileSize;
    return data;
  }
}

class AppDownloadHistory {
  String version;
  String downloadLink;
  String downloaderId;
  String deviceId;

  AppDownloadHistory(
      {this.version, this.downloadLink, this.downloaderId, this.deviceId});

  AppDownloadHistory.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    downloadLink = json['downloadLink'];
    downloaderId = json['downloaderId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['downloadLink'] = this.downloadLink;
    data['downloaderId'] = this.downloaderId;
    data['deviceId'] = this.deviceId;
    return data;
  }
}
