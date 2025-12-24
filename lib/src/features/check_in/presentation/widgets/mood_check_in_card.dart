import 'package:flutter/material.dart';

class MoodCheckInCard extends StatelessWidget {
  const MoodCheckInCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How are you feeling?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.volunteer_activism, color: Colors.white70),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodIcon(
                context,
                Icons.sentiment_very_dissatisfied,
                'Rough',
              ),
              _buildMoodIcon(context, Icons.sentiment_dissatisfied, 'Meh'),
              _buildMoodIcon(context, Icons.sentiment_neutral, 'Okay'),
              _buildMoodIcon(context, Icons.sentiment_satisfied, 'Good'),
              _buildMoodIcon(context, Icons.sentiment_very_satisfied, 'Great'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
