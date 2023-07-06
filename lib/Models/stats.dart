class ExtraStats {
  double totalRequest;
  double totalEarned;
  double acceptedRequest;
  double rejectedRequest;
  double waitingRequest;
  double finishedRequest;

  ExtraStats(this.totalRequest, this.totalEarned, this.acceptedRequest,
      this.rejectedRequest, this.waitingRequest, this.finishedRequest);

  static ExtraStats basic = ExtraStats(0, 0, 0, 0, 0, 0);

  factory ExtraStats.fromJson(Map<String, dynamic> json) {
    return ExtraStats(
        double.parse(json["total_request"].toString()),
        double.parse(json["total_earned"].toString()),
        double.parse(json["accepted_request"].toString()),
        double.parse(json["rejected_request"].toString()),
        double.parse(json["waiting_request"].toString()),
        double.parse(json["finished_request"].toString())
    );
  }
}

class EmployerStats {
  double totalFinishedJobOffers;
  double totalJobOffers;
  double totaljobRequests;
  double totalAcceptedJobRequests;
  double totalFinishedJobRequests;
  double totalRejectedJobRequests;
  double totalWaitingJobRequests;

  EmployerStats(
      this.totalFinishedJobOffers,
      this.totalJobOffers,
      this.totaljobRequests,
      this.totalAcceptedJobRequests,
      this.totalFinishedJobRequests,
      this.totalRejectedJobRequests,
      this.totalWaitingJobRequests);

  static EmployerStats basic = EmployerStats(0, 0, 0, 0, 0, 0, 0);

  factory EmployerStats.fromJson(Map<String, dynamic> json) {
    return EmployerStats(
        double.parse(json["total_finished_job_offers"].toString()),
        double.parse(json["total_job_offers"].toString()),
        double.parse(json["total_job_requests"].toString()),
        double.parse(json["total_accepted_job_requests"].toString()),
        double.parse(json["total_finished_job_requests"].toString()),
        double.parse(json["total_rejected_job_requests"].toString()),
        double.parse(json["total_waiting_job_requests"].toString()));
  }
}
