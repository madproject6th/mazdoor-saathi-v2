import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import '../../models/job.dart';
import '../../models/user_profile.dart';
import '../../providers/app_state.dart';
import '../services/speech_service.dart';

import 'package:provider/provider.dart';

/// Full-screen loading indicator.
class LoadingView extends StatelessWidget {
  final String? message;
  const LoadingView({super.key, this.message});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.orange),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(message!)
            ],
          ],
        ),
      );
}

/// Friendly empty state with icon.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Widget? action;
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (action != null) ...[const SizedBox(height: 16), action!],
            ],
          ),
        ),
      );
}

/// Error state with retry.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorView({super.key, required this.message, this.onRetry});
  @override
  Widget build(BuildContext context) => EmptyState(
        icon: Icons.error_outline,
        message: message,
        action: onRetry == null
            ? null
            : OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
      );
}

/// Coloured chip for a job status.
class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});
  Color get _color {
    switch (status) {
      case 'completed':
        return AppTheme.success;
      case 'cancelled':
        return AppTheme.error;
      case 'in_progress':
      case 'started':
        return AppTheme.orange;
      case 'team_confirmed':
        return AppTheme.navyLight;
      default:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) => Chip(
        label: Text(
          AppConstants.statusLabel(status),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        backgroundColor: _color,
        visualDensity: VisualDensity.compact,
        side: BorderSide.none,
      );
}

/// Star display + optional interactive input.
class RatingStars extends StatelessWidget {
  final double value;
  final ValueChanged<int>? onChanged;
  final double size;
  const RatingStars({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 18,
  });
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (i) {
          final filled = value >= i + 1;
          final star = Icon(
            filled ? Icons.star : Icons.star_border,
            color: AppTheme.warning,
            size: size,
          );
          if (onChanged == null) return star;
          return InkWell(
            onTap: () => onChanged!(i + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: star,
            ),
          );
        }),
      );
}

/// Card for a worker in lists/search results.
class WorkerCard extends StatelessWidget {
  final UserProfile worker;
  final double? distanceKm;
  final VoidCallback? onTap;
  const WorkerCard({
    super.key,
    required this.worker,
    this.distanceKm,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final trades =
        worker.trades.map((t) => AppConstants.trades[t] ?? t).join(', ');
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppTheme.navy,
          foregroundColor: Colors.white,
          child: Text(
            worker.name.isEmpty
                ? '?'
                : worker.name.characters.first.toUpperCase(),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                worker.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (worker.verified)
              const Icon(Icons.verified, size: 16, color: AppTheme.success),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trades.isNotEmpty) Text(trades),
            Row(
              children: [
                RatingStars(value: worker.ratingAvg, size: 14),
                const SizedBox(width: 6),
                Text(
                  '${worker.ratingAvg.toStringAsFixed(1)} (${worker.ratingCount})',
                ),
              ],
            ),
            Text(
              [
                if (worker.city.isNotEmpty) worker.city,
                if (worker.dailyWage != null)
                  '${Helpers.money(worker.dailyWage)}/day',
                if (distanceKm != null)
                  '${distanceKm!.toStringAsFixed(1)} km away',
                worker.isAvailable ? 'Available' : 'Busy',
              ].join(' • '),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

/// Card for a job in lists.
class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  const JobCard({super.key, required this.job, this.onTap});
  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onTap,
          leading: const CircleAvatar(
            backgroundColor: AppTheme.orange,
            foregroundColor: Colors.white,
            child: Icon(Icons.construction),
          ),
          title: Text(job.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            [
              if (job.city.isNotEmpty) job.city,
              if (job.requiredCount > 0) '${job.requiredCount} workers needed',
              if (job.dailyWage != null) '${Helpers.money(job.dailyWage)}/day',
            ].join(' • '),
          ),
          trailing: StatusChip(status: job.status),
        ),
      );
}

/// Mic button that dictates into [controller] using Urdu or English STT.
class UrduMicButton extends StatefulWidget {
  final TextEditingController controller;
  final bool urdu;
  const UrduMicButton({super.key, required this.controller, this.urdu = true});
  @override
  State<UrduMicButton> createState() => _UrduMicButtonState();
}

class _UrduMicButtonState extends State<UrduMicButton> {
  final _speech = SpeechService();
  bool _listening = false;

  Future<void> _toggle() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final ok = await _speech.listen(
      urdu: widget.urdu,
      onResult: (text, isFinal) {
        widget.controller.text = text;
        widget.controller.selection = TextSelection.collapsed(
          offset: text.length,
        );
        if (isFinal && mounted) setState(() => _listening = false);
      },
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice input is not available on this device.'),
        ),
      );
    } else if (mounted) {
      setState(() => _listening = true);
    }
  }

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: 'Speak in Urdu',
        onPressed: _toggle,
        icon: Icon(
          _listening ? Icons.mic : Icons.mic_none,
          color: _listening ? AppTheme.error : AppTheme.orange,
        ),
      );
}

/// Section heading used across dashboards.
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      );
}

/// Shows a snackbar from a BuildContext safely.
void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

/// Current AppState shortcut.
AppState appStateOf(BuildContext c, {bool listen = false}) =>
    Provider.of<AppState>(c, listen: listen);
