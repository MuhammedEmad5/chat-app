class UserDataModel {
  String? uId;
  String? name;
  String? phone;
  String? profileImage;
  String? bio;
  // int? numOfPosts;
  // int? numOfFollowers;
  // int? numOfFollowing;

  UserDataModel({
      this.uId,
      this.name,
      this.phone,
      this.profileImage,
      this.bio,
      // this.numOfFollowers,
      // this.numOfFollowing,
      // this.numOfPosts,
      });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    bio = json['bio'];
    // numOfPosts = json['numOfPosts'];
    // numOfFollowers = json['numOfFollowers'];
    // numOfFollowing = json['numOfFollowing'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'phone': phone,
      'profileImage': profileImage,
      'bio': bio,
      // 'numOfFollowing': numOfFollowing,
      // 'numOfFollowers': numOfFollowers,
      // 'numOfPosts': numOfPosts,
    };
  }
}
