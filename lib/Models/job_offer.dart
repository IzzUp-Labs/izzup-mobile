class JobOffer {
  int? id;
  String jobTitle;
  int price;
  bool isAvailable;
  int spots;
  int acceptedSpots;

  JobOffer(this.jobTitle, this.price, this.isAvailable, this.spots, this.acceptedSpots, {this.id});

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
        json['job_title'],
        json['price'],
        json['is_available'],
        json['spots'],
        json['acceptedSpots'],
        id: json['id'],
    );
  }

  static JobOffer basic = JobOffer('', 0, false, 0, 0);

  toJson() {
    return {
      'job_title': jobTitle,
      'price': price,
      'is_available': isAvailable,
      'spots': spots,
      'acceptedSpots': acceptedSpots
    };
  }
}