class HomepageCardData {
  String title;
  String description;
  String? picLink;
  HomepageCardType type;
  String? link;
  String? companyId;

  HomepageCardData(this.title, this.description, this.picLink, this.type,
      this.link, this.companyId);

  factory HomepageCardData.fromJson(Map<String, dynamic> json) {
    return HomepageCardData(
        json['title'],
        json['description'],
        json['photo'],
        HomepageCardType.fromString(json['type']),
        json['link'],
        json['company_id']);
  }

  static Map<HomepageCardType, List<HomepageCardData>> groupByType(
      List<HomepageCardData> cards) {
    Map<HomepageCardType, List<HomepageCardData>> groupedCards = {};
    for (var card in cards) {
      if (groupedCards.keys.contains(card.type)) {
        groupedCards[card.type]!.add(card);
      } else {
        groupedCards[card.type] = [card];
      }
    }
    return groupedCards;
  }
}

enum HomepageCardType {
  jobs,
  news,
  forYou;

  static fromString(String type) {
    switch (type) {
      case 'JOBS':
        return HomepageCardType.jobs;
      case 'NEWS':
        return HomepageCardType.news;
      case 'FOR_YOU':
        return HomepageCardType.forYou;
      default:
        return HomepageCardType.news;
    }
  }
}
