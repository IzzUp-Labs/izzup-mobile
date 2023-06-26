class JobOfferRequests {
  int? id;
  String jobTitle;
  String jobDescription;
  DateTime startingDate;
  int workingHours;
  int price;
  bool isAvailable;
  int spots;
  int acceptedSpots;
  List<JobRequests> requests;

  JobOfferRequests(this.jobTitle, this.jobDescription, this.startingDate, this.workingHours, this.price, this.isAvailable, this.spots, this.acceptedSpots, this.requests, {this.id});

  factory JobOfferRequests.fromJson(Map<String, dynamic> json) {
    return JobOfferRequests(
      json['job_title'],
      json['job_description'],
      DateTime.parse(json['starting_date']),
      json['working_hours'],
      json['price'],
      json['is_available'],
      json['spots'],
      json['acceptedSpots'],
      json['requests'].map<JobRequests>((requests) => JobRequests.fromJson(requests)).toList(),
      id: json['id'],
    );
  }


}

class JobRequests {
  int? id;
  String status;
  ExtraRequest extra;

  JobRequests(this.id, this.status, this.extra);

  factory JobRequests.fromJson(Map<String, dynamic> json) {
    return JobRequests(
      json['id'],
      json['status'],
      ExtraRequest.fromJson(json['extra']),
    );
  }
}

class ExtraRequest {
  int? id;
  String address;
  UserRequest user;

  ExtraRequest(this.id, this.address, this.user);

  factory ExtraRequest.fromJson(Map<String, dynamic> json) {
    return ExtraRequest(
      json['id'],
      json['address'],
      UserRequest.fromJson(json['user']),
    );
  }
}

class UserRequest {
  int? id;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  String? photo;
  String role;

  UserRequest(this.id, this.lastName, this.firstName, this.dateOfBirth, this.photo, this.role);

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      json['id'],
      json['last_name'],
      json['first_name'],
      DateTime.parse(json['date_of_birth']),
      json['photo'],
      json['role'],
    );
  }
}