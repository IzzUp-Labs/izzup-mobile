import 'job_offer.dart';

class Company {
  String id;
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
        json['jobOffers'] == null
            ? []
            : json['jobOffers']
                .map<JobOffer>((jobOffer) => JobOffer.fromJson(jobOffer))
                .toList());
  }

  static Company basic = Company('0', '', '', '', [JobOffer.basic]);

  isEquals(Company company) {
    return id == company.id &&
        name == company.name &&
        placeId == company.placeId &&
        address == company.address &&
        jobOffers.length == company.jobOffers.length &&
        jobOffers.every((jobOffer) => company.jobOffers.contains(jobOffer));
  }

  toJson() {
    return {
      'name': name,
      'address': address,
      'place_id': placeId,
      'jobOffers': jobOffers.map((jobOffer) => jobOffer.toJson()).toList()
    };
  }

  @override
  toString() {
    return 'Company{id: $id, name: $name, placeId: $placeId, address: $address, jobOffers: ${jobOffers.map((jobOffer) => jobOffer.toString()).toList()}}';
  }
}
