import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';
import 'package:finflow_app/core/common/ui/widgets/finflow_sidebar.dart';
import 'package:finflow_app/core/common/ui/widgets/finflow_bottom_nav.dart';
import 'package:finflow_app/core/common/ui/widgets/finflow_stat_card.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_upload_section.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_video_grid.dart';
import 'package:finflow_app/features/video/presentation/providers/video_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _bottomNavIndex = 0;
  String _sidebarRoute = 'dashboard';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(videoNotifierProvider.notifier).fetchVideos(refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;
        final bool isTablet =
            constraints.maxWidth >= 700 && constraints.maxWidth < 1100;

        return Scaffold(
          backgroundColor:
              isDark ? FinFlowColors.darkBg : FinFlowColors.lightBg,
          drawer: isMobile
              ? Drawer(
                  width: 260,
                  child: FinFlowSidebar(
                    activeRoute: _sidebarRoute,
                    onNavigate: (route) {
                      setState(() => _sidebarRoute = route);
                      Navigator.pop(context);
                    },
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile)
                FinFlowSidebar(
                  isCollapsed: isTablet,
                  activeRoute: _sidebarRoute,
                  onNavigate: (route) {
                    setState(() => _sidebarRoute = route);
                  },
                ),
              Expanded(
                child: Column(
                  children: [
                    if (!isMobile) _buildTopNavBar(isDark),
                    Expanded(
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              isMobile ? 16 : 40,
                              isMobile ? 80 : 0,
                              isMobile ? 16 : 40,
                              0,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                _buildWelcomeHeader(isDark, isMobile),
                                const SizedBox(height: 28),
                                _buildMetricCards(isDark, constraints.maxWidth),
                                const SizedBox(height: 28),
                                _buildMainLayout(constraints, isMobile, isDark),
                                const SizedBox(height: 28),
                                if (!isMobile) _buildFooter(isDark),
                                if (isMobile) const SizedBox(height: 40),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isMobile
              ? FinFlowBottomNav(
                  currentIndex: _bottomNavIndex,
                  onTap: (index) => setState(() => _bottomNavIndex = index),
                  onFabPressed: () {},
                )
              : null,
        );
      },
    );
  }

  Widget _buildTopNavBar(bool isDark) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: isDark ? FinFlowColors.darkCardBg : FinFlowColors.lightCardBg,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? FinFlowColors.glassStrokeDark
                : FinFlowColors.glassStroke,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 384),
              height: 40,
              decoration: BoxDecoration(
                color: FinFlowColors.lightSurfaceSoft,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: FinFlowColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(
                    color: FinFlowColors.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/images/search_icon.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        FinFlowColors.textMuted,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              _navLink('Dashboard', isActive: true),
              const SizedBox(width: 24),
              _navLink('Studio'),
              const SizedBox(width: 24),
              _navLink('Analytics'),
            ],
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              _iconButton(Icons.notifications_outlined, isDark),
              const SizedBox(width: 8),
              _avatar(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navLink(String label, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
                  bottom:
                      BorderSide(color: FinFlowColors.primaryDark, width: 2),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive
                ? FinFlowColors.primaryDark
                : FinFlowColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? FinFlowColors.darkCardBg : FinFlowColors.lightCardBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark
              ? FinFlowColors.glassStrokeDark
              : FinFlowColors.glassStroke,
        ),
      ),
      child: Icon(icon, color: FinFlowColors.textSecondary, size: 18),
    );
  }

  Widget _avatar(bool isDark) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark
              ? FinFlowColors.glassStrokeDark
              : FinFlowColors.strokeLight,
        ),
      ),
      child: const Icon(Icons.person,
          size: 16, color: FinFlowColors.textSecondary),
    );
  }

  Widget _buildWelcomeHeader(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, Creator',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.w700,
            color: isDark ? FinFlowColors.textWhite : FinFlowColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Here's what's happening today.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color:
                isDark ? FinFlowColors.textMuted : FinFlowColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCards(bool isDark, double maxWidth) {
    final crossAxisCount = maxWidth > 1200 ? 4 : (maxWidth > 600 ? 2 : 1);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: crossAxisCount == 1 ? 3.5 : 2.2,
      children: [
        FinFlowStatCard(
          label: 'Total videos',
          value: '48',
          change: '+3 this week',
          icon: const Icon(Icons.video_library_outlined,
              size: 16, color: FinFlowColors.primary),
        ),
        FinFlowStatCard(
          label: 'Views',
          value: '2.4M',
          change: '+12%',
          icon: const Icon(Icons.visibility_outlined,
              size: 16, color: FinFlowColors.primary),
        ),
        FinFlowStatCard(
          label: 'Followers',
          value: '14.2k',
          change: '+212',
          icon: const Icon(Icons.people_outline,
              size: 16, color: FinFlowColors.primary),
        ),
        FinFlowStatCard(
          label: 'Engagement',
          value: '5.2%',
          change: 'stable',
          isPositive: false,
          icon: const Icon(Icons.trending_up_outlined,
              size: 16, color: FinFlowColors.primary),
        ),
      ],
    );
  }

  Widget _buildMainLayout(
      BoxConstraints constraints, bool isMobile, bool isDark) {
    return LayoutBuilder(
      builder: (context, innerConstraints) {
        final isWide = innerConstraints.maxWidth > 800;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(
                      height: 590,
                      child: DashboardVideoGrid(
                          maxWidth: innerConstraints.maxWidth * 0.66),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const DashboardUploadSection(),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            const DashboardUploadSection(),
            const SizedBox(height: 24),
            DashboardVideoGrid(maxWidth: innerConstraints.maxWidth),
          ],
        );
      },
    );
  }

  Widget _buildFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2024 FinFlow AI. All rights reserved.',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? FinFlowColors.textMuted
                  : FinFlowColors.textSecondary,
              letterSpacing: 0.05,
            ),
          ),
          Row(
            children: [
              _footerLink('Privacy Policy'),
              const SizedBox(width: 24),
              _footerLink('Terms of Service'),
              const SizedBox(width: 24),
              _footerLink('Cookie Policy'),
              const SizedBox(width: 24),
              _footerLink('Legal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: FinFlowColors.textSecondary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
