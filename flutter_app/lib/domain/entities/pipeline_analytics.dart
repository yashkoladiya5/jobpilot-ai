class PipelineAnalytics {
  final int totalApplications;
  final List<StatusCount> byStatus;
  final ConversionRates conversionRates;
  final double averageDaysInPipeline;
  final List<CompanyCount> topCompanies;
  final List<MonthlyTrend> monthlyTrend;

  PipelineAnalytics({
    required this.totalApplications,
    required this.byStatus,
    required this.conversionRates,
    required this.averageDaysInPipeline,
    required this.topCompanies,
    required this.monthlyTrend,
  });

  factory PipelineAnalytics.fromJson(Map<String, dynamic> json) =>
      PipelineAnalytics(
        totalApplications: json['totalApplications'] as int? ?? 0,
        byStatus: (json['byStatus'] as List<dynamic>?)
                ?.map((e) =>
                    StatusCount.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        conversionRates: ConversionRates.fromJson(
            json['conversionRates'] as Map<String, dynamic>? ?? {}),
        averageDaysInPipeline:
            (json['averageDaysInPipeline'] as num?)?.toDouble() ?? 0,
        topCompanies: (json['topCompanies'] as List<dynamic>?)
                ?.map((e) =>
                    CompanyCount.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        monthlyTrend: (json['monthlyTrend'] as List<dynamic>?)
                ?.map((e) =>
                    MonthlyTrend.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class StatusCount {
  final String status;
  final int count;
  final double percentage;

  StatusCount({
    required this.status,
    required this.count,
    required this.percentage,
  });

  factory StatusCount.fromJson(Map<String, dynamic> json) => StatusCount(
        status: json['status'] as String,
        count: json['count'] as int? ?? 0,
        percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      );
}

class ConversionRates {
  final double appliedToInterview;
  final double interviewToOffer;
  final double overallSuccessRate;

  ConversionRates({
    required this.appliedToInterview,
    required this.interviewToOffer,
    required this.overallSuccessRate,
  });

  factory ConversionRates.fromJson(Map<String, dynamic> json) =>
      ConversionRates(
        appliedToInterview:
            (json['appliedToInterview'] as num?)?.toDouble() ?? 0,
        interviewToOffer:
            (json['interviewToOffer'] as num?)?.toDouble() ?? 0,
        overallSuccessRate:
            (json['overallSuccessRate'] as num?)?.toDouble() ?? 0,
      );
}

class CompanyCount {
  final String company;
  final int count;

  CompanyCount({required this.company, required this.count});

  factory CompanyCount.fromJson(Map<String, dynamic> json) => CompanyCount(
        company: json['company'] as String,
        count: json['count'] as int? ?? 0,
      );
}

class MonthlyTrend {
  final String month;
  final int applications;
  final int interviews;
  final int offers;

  MonthlyTrend({
    required this.month,
    required this.applications,
    required this.interviews,
    required this.offers,
  });

  factory MonthlyTrend.fromJson(Map<String, dynamic> json) => MonthlyTrend(
        month: json['month'] as String,
        applications: json['applications'] as int? ?? 0,
        interviews: json['interviews'] as int? ?? 0,
        offers: json['offers'] as int? ?? 0,
      );
}

class TimelineEntry {
  final String week;
  final int count;
  final Map<String, int> statuses;

  TimelineEntry({
    required this.week,
    required this.count,
    required this.statuses,
  });

  factory TimelineEntry.fromJson(Map<String, dynamic> json) => TimelineEntry(
        week: json['week'] as String,
        count: json['count'] as int? ?? 0,
        statuses: (json['statuses'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as int)) ??
            {},
      );
}
