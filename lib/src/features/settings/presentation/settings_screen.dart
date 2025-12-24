import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Profile Link
            _buildSettingsTile(
              context,
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'View and edit profile details',
              onTap: () => context.push('/profile'),
            ),
            const SizedBox(height: 24),

            // Settings Sections
            _buildSectionHeader(context, 'General'),
            _buildSettingsTile(
              context,
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Light',
              onTap: () => _showThemeDialog(context),
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              onTap: () => context.go('/settings/notifications'),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Focus'),
            _buildSettingsTile(
              context,
              icon: Icons.timer_outlined,
              title: 'Pomodoro Timer',
              subtitle: 'Configure intervals',
              onTap: () => context.go('/settings/focus'),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Account'),
            _buildSettingsTile(
              context,
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon')),
                );
              },
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'About'),
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: 'Version',
              trailing: const Text(
                '1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are on the latest version'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeOption(context, 'Light', (() => Navigator.pop(context))),
            _buildThemeOption(context, 'Dark', (() => Navigator.pop(context))),
            _buildThemeOption(
              context,
              'System',
              (() => Navigator.pop(context)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [Text(title, style: const TextStyle(fontSize: 16))],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              )
            : null,
        trailing:
            trailing ??
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
