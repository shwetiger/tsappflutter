// @dart=2.9
class IntroModel {
  int id;
  String imgUrl;
  // bool isActive = true;
  String name;
  String content;
  String linkUrl;
  String type;

  IntroModel(
      {this.imgUrl,
      this.name,
      this.id,
      // this.isActive,
      this.content,
      this.linkUrl,
      this.type});

  IntroModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['imageUrl'];
    // isActive = json['isActive'];
    name = json['name'];
    content = json['content'];
    linkUrl = json['linkUrl'];
    type = json['type'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imgUrl;
    // data['isActive'] = this.isActive;
    data['name'] = this.name;
    data['content'] = this.content;
    data['linkUrl'] = this.linkUrl;
    data['type'] = this.type;
    return data;
  }
}
