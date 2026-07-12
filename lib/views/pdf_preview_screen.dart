import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/utils/platform_view_registry.dart' as pvr;

class PdfPreviewScreen extends StatefulWidget {
  final String url;
  final String fileName;

  const PdfPreviewScreen({
    Key? key,
    required this.url,
    required this.fileName,
  }) : super(key: key);

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'pdf_view_${widget.url.hashCode}';
    
    if (kIsWeb) {
      pvr.registerWebView(_viewId, widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded),
            onPressed: () async {
              final Uri url = Uri.parse(widget.url);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            tooltip: 'Open in Browser',
          ),
        ],
      ),
      // Use Positioned.fill logic via Expanded/SizedBox to ensure it stretches
      body: SizedBox.expand(
        child: kIsWeb ? _buildWebView() : _buildNativePdfView(),
      ),
    );
  }

  Widget _buildWebView() {
    return HtmlElementView(viewType: _viewId);
  }

  Widget _buildNativePdfView() {
    return PdfViewer.uri(
      Uri.parse(widget.url),
      controller: _pdfViewerController,
      params: PdfViewerParams(
        loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBannerBuilder: (context, error, stackTrace, documentRef) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Error loading PDF'),
                const SizedBox(height: 8),
                Text(error.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
