class JobAnalysis {
  final String id;
  final String? jobId;
  final String? jobTitle;
  final String description;
  final DateTime analyzedAt;
  final List<String> requiredSkills;
  final List<String> preferredSkills;
  final String experienceRequired;
  final List<String> missingSkills;
  final double matchScore;
  final List<String> recommendations;

  JobAnalysis({
    required this.id,
    this.jobId,
    this.jobTitle,
    required this.description,
    required this.analyzedAt,
    required this.requiredSkills,
    required this.preferredSkills,
    required this.experienceRequired,
    required this.missingSkills,
    required this.matchScore,
    required this.recommendations,
  });

  factory JobAnalysis.fromJson(Map<String, dynamic> json) => JobAnalysis(
        id: json['id'] as String,
        jobId: json['jobId'] as String?,
        jobTitle: json['jobTitle'] as String?,
        description: json['jobDescription'] as String,
        analyzedAt: DateTime.parse(json['analyzedAt'] as String),
        requiredSkills: List<String>.from(json['requiredSkills'] as List),
        preferredSkills: List<String>.from(json['preferredSkills'] as List),
        experienceRequired: json['experienceRequired'] as String,
        missingSkills: List<String>.from(json['missingSkills'] as List),
        matchScore: (json['resumeMatchScore'] as num?)?.toDouble() ?? 0,
        recommendations: json['recommendedChanges'] != null
            ? List<String>.from(json['recommendedChanges'] as List)
            : [],
      );
}
