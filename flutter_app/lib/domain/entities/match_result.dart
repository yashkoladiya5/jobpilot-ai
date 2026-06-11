class MatchResult {
  final double matchScore;
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final List<String> priorityImprovements;
  final List<String> interviewRiskAreas;

  MatchResult({
    required this.matchScore,
    required this.matchedSkills,
    required this.missingSkills,
    required this.priorityImprovements,
    required this.interviewRiskAreas,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) => MatchResult(
        matchScore: (json['matchScore'] as num).toDouble(),
        matchedSkills: List<String>.from(json['matchedSkills'] as List),
        missingSkills: List<String>.from(json['missingSkills'] as List),
        priorityImprovements:
            List<String>.from(json['priorityImprovements'] as List),
        interviewRiskAreas:
            List<String>.from(json['interviewRiskAreas'] as List),
      );
}
