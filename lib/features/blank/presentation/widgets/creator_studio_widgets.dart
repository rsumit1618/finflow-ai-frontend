import 'package:flutter/material.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';

class CreatorStudioSidebar extends StatelessWidget {
  final bool isCollapsed;
  const CreatorStudioSidebar({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: isCollapsed ? 80 : 260,
      color: const Color(0xFF0F1825),
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: isCollapsed ? 8 : 20,
      ),
      child: Column(
        crossAxisAlignment:
            isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _Brand(isCollapsed: isCollapsed),
          const SizedBox(height: 32),
          _NavItem(
            icon: Icons.compass_calibration_outlined,
            label: l10n?.translate('dashboard') ?? 'Dashboard',
            isActive: true,
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.movie_outlined,
            label: l10n?.translate('studio') ?? 'Studio',
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.people_outline,
            label: l10n?.translate('community') ?? 'Community',
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.bar_chart_outlined,
            label: l10n?.translate('analytics') ?? 'Analytics',
            isCollapsed: isCollapsed,
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: l10n?.translate('settings') ?? 'Settings',
            isCollapsed: isCollapsed,
          ),
          const Spacer(),
          if (!isCollapsed) const _SubscriberBadge(),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  final bool isCollapsed;
  const _Brand({required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment:
          isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2D44),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.workspace_premium, color: Color(0xFF6C8CFF)),
        ),
        if (!isCollapsed) ...[
          const SizedBox(width: 12),
          Text(
            l10n?.translate('creator_hub') ?? 'CreatorHub',
            style: const TextStyle(
              color: Color(0xFFF0F5FE),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCollapsed;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E2D44) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment:
            isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF6C8CFF) : const Color(0xFF6F89AA),
            size: 24,
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFA5B9D4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriberBadge extends StatelessWidget {
  const _SubscriberBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A283B),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Color(0xFFF7C948), size: 20),
          const SizedBox(width: 14),
          Text(
            l10n?.translate('followers_count') ?? '14.2k followers',
            style: const TextStyle(color: Color(0xFFB6CCF0)),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE6EDF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF60758F),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B1A2A),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  isPositive ? const Color(0xFFE4F3EB) : const Color(0xFFF0F5FD),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPositive)
                  const Icon(Icons.arrow_upward, size: 12, color: Color(0xFF2B8C5C)),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    change,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: isPositive
                          ? const Color(0xFF2B8C5C)
                          : const Color(0xFF60758F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UploadSection extends StatelessWidget {
  const UploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE6EDF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.cloud_upload_outlined,
                      color: Color(0xFF4F73E0)),
                  const SizedBox(width: 8),
                  Text(
                    l10n?.translate('upload_new_content') ??
                        'Upload new content',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF142433),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_vert, color: Color(0xFF6E89AA)),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Video title ...',
                          filled: true,
                          fillColor: const Color(0xFFFAFCFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Color(0xFFD5E0EC)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                const BorderSide(color: Color(0xFFD5E0EC)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                      ),
                    ),
                    if (!isMobile) const SizedBox(width: 16),
                    if (!isMobile)
                      Expanded(
                        child: _FileUploadButton(),
                      ),
                  ],
                ),
                if (isMobile) const SizedBox(height: 16),
                if (isMobile) _FileUploadButton(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.publish, size: 18),
                      label: Text(l10n?.translate('publish') ?? 'Publish'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F4F9E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 34, vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PrivacyBadge(
                  icon: Icons.public,
                  label: l10n?.translate('public') ?? 'Public'),
              _PrivacyBadge(
                  icon: Icons.group_outlined,
                  label: l10n?.translate('subscriber_only') ??
                      'Subscriber only'),
              _PrivacyBadge(
                  icon: Icons.link,
                  label: l10n?.translate('unlisted') ?? 'Unlisted'),
              _PrivacyBadge(
                  icon: Icons.access_time,
                  label: l10n?.translate('schedule') ?? 'Schedule',
                  isGray: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _FileUploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFD5E0EC)),
      ),
      child: const Row(
        children: [
          Icon(Icons.file_present_outlined, size: 20, color: Color(0xFF6F89AA)),
          SizedBox(width: 8),
          Text('Choose file', style: TextStyle(color: Color(0xFF6F89AA))),
        ],
      ),
    );
  }
}

class _PrivacyBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isGray;

  const _PrivacyBadge({
    required this.icon,
    required this.label,
    this.isGray = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isGray ? const Color(0xFFE1E9F5) : const Color(0xFFF0F5FD),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFFDCE6F2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF4F73E0)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF3A5778)),
          ),
        ],
      ),
    );
  }
}

class VideoData {
  final String titleKey;
  final String views;
  final String time;
  final String duration;
  final bool isPublic;

  const VideoData({
    required this.titleKey,
    required this.views,
    required this.time,
    required this.duration,
    this.isPublic = true,
  });
}

List<VideoData> getDummyVideos() {
  return List.generate(40, (index) {
    final keys = [
      'morning_routine_vlog',
      'podcast_episode_seven',
      'book_review_analysis',
      'productivity_hacks',
      'travel_diary_italy'
    ];
    return VideoData(
      titleKey: keys[index % keys.length],
      views: '${(index + 1) * 1.5}k views',
      time: '${index + 1} days ago',
      duration: '${10 + (index % 50)}:22',
      isPublic: index % 3 != 0,
    );
  });
}

class VideoCard extends StatefulWidget {
  final String title;
  final String views;
  final String time;
  final String duration;
  final bool isPublic;

  const VideoCard({
    super.key,
    required this.title,
    required this.views,
    required this.time,
    required this.duration,
    this.isPublic = true,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
    _shadowAnimation = Tween<double>(begin: 0, end: 16).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: _hoverController.isCompleted
                      ? const Color(0xFF4F73E0)
                      : const Color(0xFFE6EDF6),
                  width: _hoverController.isCompleted ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x08000000),
                    blurRadius: _shadowAnimation.value,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // CRITICAL: Prevents extra space
                children: [
                  // Thumbnail with gradient
                  Stack(
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          gradient: LinearGradient(
                            colors: widget.isPublic
                                ? [const Color(0xFF1A2940), const Color(0xFF253A54)]
                                : [const Color(0xFF2A1F30), const Color(0xFF3A2A44)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.play_circle_filled,
                            color: Colors.white.withOpacity(0.7),
                            size: 48,
                          ),
                        ),
                      ),
                      // Duration badge
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xCC0F1A2A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            widget.duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      // Play icon overlay on hover
                      if (_hoverController.isCompleted)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(28),
                              ),
                              color: Colors.black.withOpacity(0.2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 56,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Content with tight padding - NO EXTRA BOTTOM SPACE
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14), // Reduced bottom padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // CRITICAL: Prevents extra space
                      children: [
                        // Title
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1E2E),
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 6), // Reduced spacing

                        // Views and time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.views,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5F7897),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F5FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF5F7897),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12), // Reduced spacing

                        // Bottom row with privacy badge and actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Privacy Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.isPublic
                                    ? const Color(0xFFE8F5F0)
                                    : const Color(0xFFF5EFD8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.isPublic
                                      ? const Color(0xFFC5E0D5)
                                      : const Color(0xFFE8DCC0),
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.isPublic
                                        ? Icons.public_rounded
                                        : Icons.lock_rounded,
                                    size: 12,
                                    color: widget.isPublic
                                        ? const Color(0xFF136B4A)
                                        : const Color(0xFF9E7B2A),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    widget.isPublic
                                        ? (l10n?.translate('public') ?? 'Public')
                                        : (l10n?.translate('subscriber') ?? 'Subscriber'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: widget.isPublic
                                          ? const Color(0xFF136B4A)
                                          : const Color(0xFF9E7B2A),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Action buttons - smaller and tighter
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ActionButton(
                                  icon: Icons.edit_outlined,
                                  color: const Color(0xFF4F73E0),
                                  size: 14,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 2),
                                _ActionButton(
                                  icon: Icons.delete_outline,
                                  color: const Color(0xFFE57373),
                                  size: 14,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 2),
                                _ActionButton(
                                  icon: Icons.more_vert_rounded,
                                  color: const Color(0xFF60758F),
                                  size: 14,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    this.size = 14,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 150),
          tween: Tween<double>(begin: 1.0, end: 1.0),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: color.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: size,
                  color: color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AccessNote extends StatelessWidget {
  const AccessNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EDF8),
        borderRadius: BorderRadius.circular(60),
        border: Border.all(color: const Color(0xFFD0DEF0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF3F6BC0), size: 20),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              l10n?.translate('access_note_text') ??
                  'Public and Subscribers can watch all videos · privacy settings are shown on each card',
              style: const TextStyle(color: Color(0xFF1A3251), fontSize: 14),
            ),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.shield_outlined, color: Color(0xFF476BB5), size: 20),
        ],
      ),
    );
  }
}
