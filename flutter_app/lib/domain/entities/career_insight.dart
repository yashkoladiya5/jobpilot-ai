class CareerHistoryPoint {
  final DateTime date;
  final double score;
  final String label;

  CareerHistoryPoint({
    required this.date,
    required this.score,
    required this.label,
  });

  factory CareerHistoryPoint.fromJson(Map<String, dynamic> json) =>
      CareerHistoryPoint(
        date: DateTime.parse(json['date'] as String),
        score: (json['score'] as num).toDouble(),
        label: json['label'] as String,
      );
}

class CareerInsight {
  final double careerScore;
  final double interviewReadiness;
  final double resumeStrength;
  final double jobMatchQuality;
  final double applicationSuccessRate;
  final List<String> skillGaps;
  final List<String> recommendations;
  final List<CareerHistoryPoint> history;

  CareerInsight({
    required this.careerScore,
    required this.interviewReadiness,
    required this.resumeStrength,
    required this.jobMatchQuality,
    required this.applicationSuccessRate,
    required this.skillGaps,
    required this.recommendations,
    required this.history,
  });

  factory CareerInsight.fromJson(Map<String, dynamic> json) => CareerInsight(
        careerScore: (json['careerScore'] as num).toDouble(),
        interviewReadiness: (json['interviewReadiness'] as num).toDouble(),
        resumeStrength: (json['resumeStrength'] as num).toDouble(),
        jobMatchQuality: (json['jobMatchQuality'] as num).toDouble(),
        applicationSuccessRate:
            (json['applicationSuccessRate'] as num).toDouble(),
        skillGaps: List<String>.from(json['skillGaps'] as List),
        recommendations: List<String>.from(json['recommendations'] as List),
        history: (json['weeklyProgress'] as List?)
                ?.map((e) =>
                    CareerHistoryPoint.fromJson(e as Map<String, dynamic>))
                .toList() ?? [],
      );
}
