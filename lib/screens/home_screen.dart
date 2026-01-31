import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeTab = 'home';

  final Map<String, int> _stats = {
    'submitted': 0,
    'analyzing': 0,
    'completed': 0,
  };

  int get _totalReports =>
      _stats['submitted']! + _stats['analyzing']! + _stats['completed']!;

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _handleSignOut() async {
    await AuthService.signOut();
    // No need to call callback, stream in main.dart will update
  }

  @override
  Widget build(BuildContext context) {
    final firstName = AuthService.getFirstName();
    final photoUrl = AuthService.getPhotoUrl();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getTimeGreeting()},',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              firstName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111111),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _handleSignOut,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: photoUrl == null
                                  ? const Color(0xFF111111)
                                  : null,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: photoUrl != null
                                ? Image.network(
                                    photoUrl,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildInitialAvatar(firstName),
                                  )
                                : _buildInitialAvatar(firstName),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Summary Card
                  _buildSummaryCard(),

                  // Quick Actions
                  const Padding(
                    padding: EdgeInsets.only(top: 28, bottom: 14),
                    child: Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          icon: LucideIcons.camera,
                          iconColor: const Color(0xFF4F46E5),
                          iconBgColor: const Color(0xFFEEF2FF),
                          title: 'Report Issue',
                          description: 'Capture & submit',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionCard(
                          icon: LucideIcons.map,
                          iconColor: const Color(0xFF16A34A),
                          iconBgColor: const Color(0xFFF0FDF4),
                          title: 'Explore Map',
                          description: 'View nearby',
                        ),
                      ),
                    ],
                  ),

                  // Activity Section
                  const Padding(
                    padding: EdgeInsets.only(top: 28, bottom: 14),
                    child: Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                  ),
                  _buildEmptyState(),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Bottom Navigation
            Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Impact',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
              Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    LucideIcons.arrowUpRight,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content
          Row(
            children: [
              // Main Stat
              Column(
                children: [
                  Text(
                    '$_totalReports',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Total Reports',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              const SizedBox(width: 24),

              // Divider
              Container(width: 1, height: 60, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 20),

              // Sub Stats
              Expanded(
                child: Column(
                  children: [
                    _buildSubStatItem(
                      color: const Color(0xFF3B82F6),
                      count: _stats['submitted']!,
                      label: 'Pending',
                    ),
                    const SizedBox(height: 12),
                    _buildSubStatItem(
                      color: const Color(0xFFF59E0B),
                      count: _stats['analyzing']!,
                      label: 'In Review',
                    ),
                    const SizedBox(height: 12),
                    _buildSubStatItem(
                      color: const Color(0xFF10B981),
                      count: _stats['completed']!,
                      label: 'Resolved',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubStatItem({
    required Color color,
    required int count,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              LucideIcons.clock,
              size: 28,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No reports yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Start by reporting an issue in your city',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildNavItem(icon: LucideIcons.home, label: 'Home', tabId: 'home'),
          _buildNavItem(icon: LucideIcons.map, label: 'Map', tabId: 'map'),
          _buildCenterNavButton(),
          _buildNavItem(
            icon: LucideIcons.user,
            label: 'Profile',
            tabId: 'profile',
          ),
          _buildNavItem(
            icon: LucideIcons.barChart3,
            label: 'Stats',
            tabId: 'stats',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String tabId,
  }) {
    final isActive = _activeTab == tabId;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tabId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? const Color(0xFF111111)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                color: isActive
                    ? const Color(0xFF111111)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavButton() {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(LucideIcons.camera, size: 24, color: Colors.white),
      ),
    );
  }
}
