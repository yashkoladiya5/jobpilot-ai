class InterviewResult {
  final double overallScore;
  final Map<String, double> categoryScores;
  final List<String> strengths;
  final List<String> improvementAreas;
  final String summary;

  InterviewResult({
    required this.overallScore,
    required this.categoryScores,
    required this.strengths,
    required this.improvementAreas,
    required this.summary,
  });

  factory InterviewResult.fromJson(Map<String, dynamic> json) =>
      InterviewResult(
        overallScore: (json['overallScore'] as num).toDouble(),
        categoryScores:
            (json['categoryScores'] as Map<String, dynamic>)
                .map((k, v) => MapEntry(k, (v as num).toDouble())),
        strengths: List<String>.from(json['strengths'] as List),
        improvementAreas:
            List<String>.from(json['improvements'] as List),
        summary: json['summary'] as String,
      );
}
