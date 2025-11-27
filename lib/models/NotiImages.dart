// @dart=2.9
class NotiImages {
  String imagePath;


  NotiImages({
    this.imagePath,

  });

  NotiImages.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagePath'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    return data;
  }
}
