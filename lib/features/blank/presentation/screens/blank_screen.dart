import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';
import 'package:finflow_app/features/blank/presentation/widgets/creator_studio_widgets.dart';
import 'package:flutter/rendering.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dummyVideos = getDummyVideos();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1100;
        final bool isTablet =
            constraints.maxWidth >= 700 && constraints.maxWidth < 1100;
        final bool isMobile = constraints.maxWidth < 700;

        return Scaffold(
          backgroundColor: const Color(0xFFF2F5F9),
          drawer: isMobile
              ? const Drawer(
                  width: 260,
                  child: CreatorStudioSidebar(isCollapsed: false),
                )
              : null,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: const Color(0xFFF2F5F9),
                  elevation: 0,
                  centerTitle: false,
                  iconTheme: const IconThemeData(color: Color(0xFF0B1829)),
                  title: Text(
                    l10n?.translate('admin_portal') ?? 'Admin Portal',
                    style: const TextStyle(
                      color: Color(0xFF0B1829),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: const [
                    _IconButton(icon: Icons.message_outlined),
                    SizedBox(width: 8),
                    _IconButton(icon: Icons.person_outline),
                    SizedBox(width: 12),
                  ],
                )
              : null,
          body: Row(
            children: [
              if (!isMobile) CreatorStudioSidebar(isCollapsed: isTablet),
              Expanded(
                child: CustomScrollView(
                  scrollCacheExtent: ScrollCacheExtent.pixels(3000), physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 16 : 40,
                        isMobile ? 16 : 40,
                        isMobile ? 16 : 40,
                        0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (!isMobile) ...[
                            _buildHeader(l10n),
                            const SizedBox(height: 32),
                          ],
                          _buildStatsGrid(l10n, constraints),
                          const SizedBox(height: 32),
                          const UploadSection(),
                          const SizedBox(height: 32),
                          _buildVideoGridHeader(l10n),
                          const SizedBox(height: 16),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 40,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: constraints.maxWidth > 800 ? 1.4 : 1.0, // Wider aspect ratio for 2-column layout
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final video = dummyVideos[index];
                            return VideoCard(
                              title: l10n?.translate(video.titleKey) ??
                                  video.titleKey,
                              views: video.views,
                              time: video.time,
                              duration: video.duration,
                              isPublic: video.isPublic,
                            );
                          },
                          childCount: dummyVideos.length,
                          addRepaintBoundaries: true,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 16 : 40,
                        32,
                        isMobile ? 16 : 40,
                        40,
                      ),
                      sliver: const SliverToBoxAdapter(
                        child: AccessNote(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations? l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.rocket_launch, color: Color(0xFF4F73E0), size: 28),
            const SizedBox(width: 12),
            Text(
              l10n?.translate('admin_portal') ?? 'Admin Portal',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0B1829),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const Row(
          children: [
            _IconButton(icon: Icons.message_outlined),
            SizedBox(width: 12),
            _IconButton(icon: Icons.person_outline),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(AppLocalizations? l10n, BoxConstraints constraints) {
    int crossAxisCount = constraints.maxWidth > 1200
        ? 4
        : (constraints.maxWidth > 800 ? 2 : 1);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: crossAxisCount == 1 ? 2.5 : 1.8, // Adjusted to prevent overflow in StatCard
      children: [
        StatCard(
          label: l10n?.translate('total_videos') ?? 'Total videos',
          value: '48',
          change: l10n?.translate('plus_three_week') ?? '+3 this week',
        ),
        StatCard(
          label: l10n?.translate('views') ?? 'Views',
          value: '2.4M',
          change: l10n?.translate('plus_twelve_percent') ?? '+12%',
        ),
        StatCard(
          label: l10n?.translate('followers') ?? 'Followers',
          value: '14.2k',
          change: l10n?.translate('plus_two_twelve') ?? '+212',
        ),
        StatCard(
          label: l10n?.translate('engagement') ?? 'Engagement',
          value: '5.2%',
          change: l10n?.translate('stable') ?? 'stable',
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildVideoGridHeader(AppLocalizations? l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.table_rows_outlined,
                color: Color(0xFF4F73E0), size: 20),
            const SizedBox(width: 8),
            Text(
              l10n?.translate('all_videos') ?? 'All videos',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF142433),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE4ECF7),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 14, color: Color(0xFF1D3857)),
              const SizedBox(width: 4),
              Text(
                l10n?.translate('filter') ?? 'Filter',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D3857),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 750) return 2; // Only two videos in horizontal for tablet/desktop
    return 1;
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  const _IconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE1E9F2)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF2C405B), size: 16),
    );
  }
}
