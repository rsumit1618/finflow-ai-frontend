import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:finflow_app/core/common/utils/localization/app_localizations.dart';
import 'package:finflow_app/core/common/models/file_upload_model.dart';
import 'package:finflow_app/core/common/ui/utils/error_handler_ui.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';
import 'package:finflow_app/features/video/presentation/providers/video_providers.dart';
import 'package:finflow_app/features/video/presentation/providers/video_state.dart';

class DashboardUploadSection extends ConsumerStatefulWidget {
  const DashboardUploadSection({super.key});

  @override
  ConsumerState<DashboardUploadSection> createState() =>
      _DashboardUploadSectionState();
}

class _DashboardUploadSectionState
    extends ConsumerState<DashboardUploadSection> {
  List<FileUploadModel> _selectedFiles = [];

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.video,
        withData: kIsWeb,
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files
              .map((f) => FileUploadModel(
                    name: f.name,
                    size: f.size,
                    path: kIsWeb ? null : f.path,
                    bytes: f.bytes,
                    format: f.extension ?? 'mp4',
                  ))
              .toList();
        });
        _uploadFiles();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandlerUI.showError(context, 'Error picking files: $e');
      }
    }
  }

  void _uploadFiles() {
    if (_selectedFiles.isEmpty) return;
    ref.read(videoNotifierProvider.notifier).uploadVideos(_selectedFiles);
    setState(() => _selectedFiles = []);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final videoState = ref.watch(videoNotifierProvider);
    final isUploading =
        videoState is VideoUploading || videoState is VideoUploadProgress;
    double progress = 0;
    String statusText = 'Uploading...';
    if (videoState is VideoUploadProgress) {
      progress = videoState.progress;
      statusText = videoState.statusText;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FinFlowColors.lightCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FinFlowColors.glassStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_upload_outlined,
                  color: FinFlowColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n?.translate('upload_new_content') ?? 'Upload new content',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FinFlowColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (_selectedFiles.isNotEmpty)
                Text(
                  '${_selectedFiles.length} file(s)',
                  style: const TextStyle(
                      fontSize: 13, color: FinFlowColors.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            return Column(
              children: [
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isUploading ? null : _pickFiles,
                    icon: isUploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add, size: 18),
                    label:
                        Text(isUploading ? statusText : 'Select video files'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FinFlowColors.primary,
                      side: const BorderSide(color: FinFlowColors.glassStroke),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          if (isUploading && videoState is VideoUploadProgress) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: FinFlowColors.lightSurfaceSoft,
                valueColor: const AlwaysStoppedAnimation(FinFlowColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style:
                  const TextStyle(fontSize: 12, color: FinFlowColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
