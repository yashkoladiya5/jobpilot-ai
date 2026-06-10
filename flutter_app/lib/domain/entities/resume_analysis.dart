class ResumeAnalysis {
  final String id;
  final String resumeId;
  final String resumeFileName;
  final int atsScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> missingKeywords;
  final List<String> suggestions;
  final String experienceSummary;
  final String skillsSummary;
  final String recruiterFeedback;
  final DateTime createdAt;

  ResumeAnalysis({
    required this.id,
    required this.resumeId,
    required this.resumeFileName,
    required this.atsScore,
    required this.strengths,
    required this.weaknesses,
    required this.missingKeywords,
    required this.suggestions,
    required this.experienceSummary,
    required this.skillsSummary,
    required this.recruiterFeedback,
    required this.createdAt,
  });

  factory ResumeAnalysis.fromJson(Map<String, dynamic> json) => ResumeAnalysis(
        id: json['id'] as String,
        resumeId: json['resumeId'] as String,
        resumeFileName: json['resumeFileName'] as String? ??
            ((json['resume'] as Map<String, dynamic>?)?['fileName'] as String?) ?? '',
        atsScore: json['atsScore'] as int,
        strengths: List<String>.from(json['strengths'] as List),
        weaknesses: List<String>.from(json['weaknesses'] as List),
        missingKeywords: List<String>.from(json['missingKeywords'] as List),
        suggestions: List<String>.from(json['suggestions'] as List),
        experienceSummary: json['experienceSummary'] as String,
        skillsSummary: json['skillsSummary'] as String,
        recruiterFeedback: json['recruiterFeedback'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
