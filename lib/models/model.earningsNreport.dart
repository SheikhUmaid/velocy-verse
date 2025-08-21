class EarningsNreportModel {
  EarningsNreportModel({
    required this.todayEarnings,
    required this.yesterdayEarnings,
    required this.thisWeekEarnings,
    required this.thisMonthEarnings,
    required this.totalEarnings,
    required this.remainingCashLimit,
  });

  final double? todayEarnings;
  final double? yesterdayEarnings;
  final double? thisWeekEarnings;
  final double? thisMonthEarnings;
  final double? totalEarnings;
  final int? remainingCashLimit;

  factory EarningsNreportModel.fromJson(Map<String, dynamic> json) {
    return EarningsNreportModel(
      todayEarnings: json["today_earnings"] ?? 0,
      yesterdayEarnings: json["yesterday_earnings"] ?? 0,
      thisWeekEarnings: json["this_week_earnings"] ?? 0,
      thisMonthEarnings: json["this_month_earnings"] ?? 0,
      totalEarnings: json["total_earnings"] ?? 0,
      remainingCashLimit: json["remaining_cash_limit"] ?? 0,
    );
  }
}
