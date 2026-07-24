import 'package:flutter/material.dart';
import 'package:finflow_app/features/dashboard/presentation/widgets/dashboard_studio_widgets.dart';

class DashboardSidebar extends StatelessWidget {
  final bool isCollapsed;
  const DashboardSidebar({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return CreatorStudioSidebar(isCollapsed: isCollapsed);
  }
}
