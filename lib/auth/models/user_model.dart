class UserModel {
  final String userUid;
  final String userName;
  final String profilePicture;
  final String profession;
  final String years;
  final String description;
  final String jobDetails;
  final String location;

  const UserModel({
    required this.description,
    required this.jobDetails,
    required this.location,
    required this.profession,
    required this.profilePicture,
    required this.userName,
    required this.years,
    required this.userUid,
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "description": description,
      "jobDetails": jobDetails,
      "location": location,
      "profession": profession,
      "profilePicture": profilePicture,
      "years": years,
      "userUid": userUid,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      description: json["description"],
      jobDetails: json["jobDetails"],
      location: json["location"],
      profession: json["profession"],
      profilePicture: json["profilePicture"],
      userName: json["userName"],
      years: json["years"],
      userUid: json["userUid"],
    );
  }
}
