import 'job_offer.dart';

class Company {
  int id;
  String name;
  String placeId;
  String address;
  List<JobOffer> jobOffers;

  Company(this.id, this.name, this.placeId, this.address, this.jobOffers);

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        json['id'],
        json['name'],
        json['place_id'],
        json['address'],
        json['jobOffers']
            .map<JobOffer>((jobOffer) => JobOffer.fromJson(jobOffer))
            .toList());
  }

  static Company basic = Company(0, '', '', '', [JobOffer.basic]);

  toJson() {
    return {
      'name': name,
      'address': address,
      'place_id': placeId,
      'jobOffers': jobOffers.map((jobOffer) => jobOffer.toJson()).toList()
    };
  }
}
