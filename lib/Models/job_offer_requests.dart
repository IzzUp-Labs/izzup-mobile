import 'company.dart';
import 'job_offer.dart';

class JobOfferRequest {
  String? id;
  String jobTitle;
  String jobDescription;
  DateTime startingDate;
  int workingHours;
  int price;
  bool isAvailable;
  int spots;
  int acceptedSpots;
  List<JobRequests> requests;

  JobOfferRequest(
      this.jobTitle,
      this.jobDescription,
      this.startingDate,
      this.workingHours,
      this.price,
      this.isAvailable,
      this.spots,
      this.acceptedSpots,
      this.requests,
      {this.id});

  factory JobOfferRequest.fromJson(Map<String, dynamic> json) {
    var jobOffer = JobOfferRequest(
      json['job_title'],
      json['job_description'],
      DateTime.parse(json['starting_date']),
      json['working_hours'],
      json['price'],
      json['is_available'],
      json['spots'],
      json['acceptedSpots'],
      json['requests'] != null
          ? json['requests']
              .map<JobRequests>((requests) => JobRequests.fromJson(requests))
              .toList()
          : [],
      id: json['id'],
    );
    jobOffer.startingDate = jobOffer.startingDate.add(const Duration(hours: 2));
    return jobOffer;
  }
}

enum JobRequestStatus {
  pending,
  accepted,
  rejected,
  waitingForVerification,
  finished;

  static JobRequestStatus fromString(String status) {
    switch (status) {
      case 'PENDING':
        return JobRequestStatus.pending;
      case 'ACCEPTED':
        return JobRequestStatus.accepted;
      case 'REJECTED':
        return JobRequestStatus.rejected;
      case 'WAITING_FOR_VERIFICATION':
        return JobRequestStatus.waitingForVerification;
      case 'FINISHED':
        return JobRequestStatus.finished;
      default:
        return JobRequestStatus.pending;
    }
  }
}

class JobRequestWithVerificationCode {
  String? id;
  JobRequestStatus status;
  String? verificationCode;
  JobOffer jobOffer;
  Company company;

  JobRequestWithVerificationCode(
      this.id, this.status, this.verificationCode, this.jobOffer, this.company);

  factory JobRequestWithVerificationCode.fromJson(Map<String, dynamic> json) {
    return JobRequestWithVerificationCode(
      json['id'],
      JobRequestStatus.fromString(json['status']),
      json['verification_code'],
      JobOffer.fromJson(json['jobOffer']),
      Company.fromJson(json['jobOffer']['company']),
    );
  }
}

class JobRequests {
  String? id;
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
  String? id;
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
  String? id;
  String lastName;
  String firstName;
  DateTime dateOfBirth;
  String? photo;
  String role;

  UserRequest(this.id, this.lastName, this.firstName, this.dateOfBirth,
      this.photo, this.role);

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
