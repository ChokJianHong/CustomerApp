import 'package:customer_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JobCard extends StatelessWidget {
  final String name;
  final String description;
  final String status;

  const JobCard({
    super.key,
    required this.name,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8), // Adjust margin for spacing between cards
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Problem Type: ${_capitalizeFirstLetterOfEachWord(name)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.darkGray,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          AutoSizeText(
            'Description: $description',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkGray,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          _StatusBadge(status: status, color: statusColor),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.red;
    }
  }

  String _capitalizeFirstLetterOfEachWord(String text) {
    return text.split(' ').map((word) {
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '';
    }).join(' ');
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AutoSizeText(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        maxLines: 1,
      ),
    );
  }
}
