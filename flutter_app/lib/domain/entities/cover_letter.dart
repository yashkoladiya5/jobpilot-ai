class CoverLetter {
  final String id;
  final String resumeId;
  final String resumeFileName;
  final String? jobId;
  final String jobDescription;
  final String tone;
  final String coverLetterText;
  final String status;
  final DateTime createdAt;

  CoverLetter({
    required this.id,
    required this.resumeId,
    required this.resumeFileName,
    this.jobId,
    required this.jobDescription,
    required this.tone,
    required this.coverLetterText,
    required this.status,
    required this.createdAt,
  });

  factory CoverLetter.fromJson(Map<String, dynamic> json) => CoverLetter(
        id: json['id'] as String,
        resumeId: json['resumeId'] as String,
        resumeFileName: json['resumeFileName'] as String? ??
            ((json['resume'] as Map<String, dynamic>?)?['fileName']
                    as String?) ??
            '',
        jobId: json['jobId'] as String?,
        jobDescription: json['jobDescription'] as String,
        tone: json['tone'] as String? ?? 'professional',
        coverLetterText: json['coverLetterText'] as String,
        status: json['status'] as String? ?? 'COMPLETED',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
