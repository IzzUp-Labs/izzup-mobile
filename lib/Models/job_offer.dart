class JobOffer {
  int? id;
  String jobTitle;
  String jobDescription;
  DateTime startingDate;
  int workingHours;
  int price;
  bool isAvailable;
  int spots;
  int acceptedSpots;

  JobOffer(
      this.jobTitle,
      this.jobDescription,
      this.startingDate,
      this.workingHours,
      this.price,
      this.isAvailable,
      this.spots,
      this.acceptedSpots,
      {this.id});

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      json['job_title'],
      json['job_description'],
      DateTime.parse(json['starting_date']),
      json['working_hours'],
      json['price'],
      json['is_available'],
      json['spots'],
      json['acceptedSpots'],
      id: json['id'],
    );
  }

  static JobOffer basic = JobOffer('', '', DateTime.now(), 0, 0, false, 0, 0);

  toJson() {
    return {
      'job_title': jobTitle,
      'job_description': jobDescription,
      'starting_date': startingDate.toIso8601String(),
      'working_hours': workingHours,
      'price': price,
      'is_available': isAvailable,
      'spots': spots,
      'acceptedSpots': acceptedSpots
    };
  }

  @override
  String toString() {
    return 'JobOffer{id: $id, jobTitle: $jobTitle, jobDescription: $jobDescription, startingDate: $startingDate, workingHours: $workingHours, price: $price, isAvailable: $isAvailable, spots: $spots, acceptedSpots: $acceptedSpots}';
  }
}
