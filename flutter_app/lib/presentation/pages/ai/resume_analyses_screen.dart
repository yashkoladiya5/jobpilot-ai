import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_bloc.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_event.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_state.dart';
import 'package:jobpilot_ai/presentation/widgets/empty_state.dart';
import 'package:jobpilot_ai/presentation/widgets/error_display.dart';
import 'package:shimmer/shimmer.dart';

class ResumeAnalysesScreen extends StatefulWidget {
  const ResumeAnalysesScreen({super.key});

  @override
  State<ResumeAnalysesScreen> createState() => _ResumeAnalysesScreenState();
}

class _ResumeAnalysesScreenState extends State<ResumeAnalysesScreen> {
  List<ResumeAnalysis>? _lastAnalyses;

  @override
  void initState() {
    super.initState();
    context.read<AiResumeBloc>().add(const LoadAllResumeAnalyses());
  }

  Future<void> _onRefresh() {
    context.read<AiResumeBloc>().add(const LoadAllResumeAnalyses());
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analyses'),
      ),
      body: BlocBuilder<AiResumeBloc, AiResumeState>(
        builder: (context, state) {
          return switch (state) {
            AiResumeInitial() => const SizedBox.shrink(),
            AiResumeAnalyzing() => _lastAnalyses != null
                ? _buildList(_lastAnalyses!)
                : const _AnalysesShimmer(),
            AiResumeAnalysesLoaded(:final analyses) =>
              _buildList(_lastAnalyses = analyses),
            AiResumeLoaded() => _lastAnalyses != null
                ? _buildList(_lastAnalyses!)
                : const _AnalysesShimmer(),
            AiResumeError(:final message) => ErrorDisplay(
                message: message,
                onRetry: () => context.read<AiResumeBloc>()
                    .add(const LoadAllResumeAnalyses()),
              ),
          };
        },
      ),
    );
  }

  Widget _buildList(List<ResumeAnalysis> analyses) {
    if (analyses.isEmpty) {
      return const EmptyState(
        icon: Icons.analytics_outlined,
        message: 'No analyses yet.\nUpload a resume and analyze it.',
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: analyses.length,
        itemBuilder: (context, index) {
          final analysis = analyses[index];
          return _buildAnalysisCard(analysis);
        },
      ),
    );
  }

  Widget _buildAnalysisCard(ResumeAnalysis analysis) {
    final scoreColor = analysis.atsScore >= 80
        ? AppColors.success
        : analysis.atsScore >= 50
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        onTap: () {
          context.read<AiResumeBloc>()
              .add(LoadResumeAnalysis(analysis.resumeId));
          context.push('/ai/resume/${analysis.resumeId}/analysis');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: analysis.atsScore / 100,
                      strokeWidth: 4,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation(scoreColor),
                      strokeCap: StrokeCap.round,
                    ),
                    Text(
                      '${analysis.atsScore}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: scoreColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis.resumeFileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${analysis.strengths.length} strengths, ${analysis.weaknesses.length} weaknesses',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                DateFormat('MMM dd, yyyy').format(analysis.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysesShimmer extends StatelessWidget {
  const _AnalysesShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: List.generate(4, (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      )),
    );
  }
}
