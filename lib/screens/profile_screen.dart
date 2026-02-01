import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final email = AuthService.getEmail() ?? 'Sign in to see email';
    final name = AuthService.getDisplayName() ?? 'User';
    final photoUrl = AuthService.getPhotoUrl();
    final memberSince = user?.createdAt != null
        ? DateFormat('MMMM yyyy').format(DateTime.parse(user!.createdAt))
        : 'January 2026';

    return Container(
      color: const Color(0xFF111111), // Dark background matching reference
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF1E1E1E,
                ), // Slightly lighter dark for card
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF333333),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: photoUrl != null
                          ? Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderAvatar(name),
                            )
                          : _buildPlaceholderAvatar(name),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name and Verified Badge
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.badgeCheck,
                        size: 16,
                        color: Color(0xFF2196F3),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Verified Account',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Member Since
                  Text(
                    'Member since $memberSince',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),

                  // Edit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.pencil, size: 16),
                      label: const Text('Edit Phone Number'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C2C2C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: Color(0xFF333333),
                            width: 1,
                          ),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Information Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildProfileField(
                    icon: LucideIcons.mail,
                    label: 'Email',
                    value: email,
                  ),
                  const SizedBox(height: 24),

                  _buildProfileField(
                    icon: LucideIcons.phone,
                    label: 'Phone',
                    value: 'Not provided',
                    showEdit: true,
                  ),
                  const SizedBox(height: 24),

                  _buildProfileField(
                    icon: LucideIcons.user,
                    label: 'Account Status',
                    value: 'Active',
                  ),
                  const SizedBox(height: 24),

                  _buildProfileField(
                    icon: LucideIcons.clock,
                    label: 'Last Login',
                    value: 'Not available',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ), // Approximate bottom padding for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(String name) {
    return Container(
      color: const Color(0xFFEEEEEE),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111111),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
    bool showEdit = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF757575)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFFE0E0E0).withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          const Icon(LucideIcons.pencil, size: 16, color: Color(0xFF424242)),
      ],
    );
  }
}
