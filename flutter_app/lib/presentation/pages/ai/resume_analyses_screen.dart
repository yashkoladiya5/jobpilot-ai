import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jobpilot_ai/core/theme/app_colors.dart';
import 'package:jobpilot_ai/domain/entities/resume_analysis.dart';
import 'package:jobpilot_ai/presentation/bloc/ai_resume/ai_resume_bloc.dart';
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
                onRetry: () {},
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
        message: 'No analyses yet.\nAnalyze a resume to get started.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {},
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
        : analysis.atsScore >= 60
            ? AppColors.warning
            : AppColors.error;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: analysis.atsScore / 100,
                strokeWidth: 4,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(scoreColor),
              ),
              Text(
                '${analysis.atsScore}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: scoreColor,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          analysis.resumeFileName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${analysis.strengths.length} strengths, ${analysis.weaknesses.length} weaknesses',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        trailing: Text(
          DateFormat('MMM dd').format(analysis.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        onTap: () => context.push('/ai/resume/analysis/${analysis.id}'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 72,
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
