import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../core/localization/app_localizations.dart';
import '../core/services/api_service.dart';
import '../models/document_model.dart';
import 'pdf_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isUploading = false;
  bool _isLoadingDocs = false;
  List<DocumentModel> _documents = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  void _navigate(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  Future<void> _fetchDocuments() async {
    if (!mounted) return;
    setState(() => _isLoadingDocs = true);
    try {
      final response = await _apiService.fetchDocuments();
      if (response['success']) {
        if (mounted) {
          setState(() {
            _documents = response['documents'];
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching documents: $e');
    } finally {
      if (mounted) setState(() => _isLoadingDocs = false);
    }
  }

  Future<bool> _requestPermission() async {
    if (kIsWeb) return true;
    if (await Permission.storage.request().isGranted) return true;
    if (await Permission.photos.request().isGranted) return true;
    return false;
  }

  Future<void> _pickAndUploadPdf() async {
    try {
      if (!kIsWeb) {
        final hasPermission = await _requestPermission();
        if (!hasPermission) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('❌ Storage permission denied')),
            );
          }
          return;
        }
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: kIsWeb,
      );

      if (result != null) {
        final file = result.files.first;
        
        // Enforce 5MB limit (5 * 1024 * 1024 bytes)
        const int maxBytes = 5 * 1024 * 1024;
        if (file.size > maxBytes) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('❌ File too large. Max limit is 5MB.')),
            );
          }
          return;
        }

        setState(() => _isUploading = true);
        
        Map<String, dynamic> response;
        if (kIsWeb) {
          if (file.bytes == null) throw Exception("Could not read file bytes on Web");
          response = await _apiService.uploadPdfFromBytes(file.bytes!, file.name, category: 'GENERAL');
        } else {
          if (file.path == null) throw Exception("File path is null");
          response = await _apiService.uploadPdf(file.path!, file.name, category: 'GENERAL');
        }

        if (response['success']) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ PDF Uploaded successfully!')),
            );
            _fetchDocuments();
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ Upload failed: ${response['message']}')),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking/uploading file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _confirmDelete(DocumentModel doc) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text('Are you sure you want to delete "${doc.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteDocument(doc.id);
    }
  }

  Future<void> _deleteDocument(int id) async {
    try {
      final response = await _apiService.deleteDocument(id);
      if (response['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Document deleted successfully')),
          );
          _fetchDocuments();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Delete failed: ${response['message']}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool useTopMenu = kIsWeb && screenWidth > 950;

    return Scaffold(
      appBar: useTopMenu ? _buildWebAppBar(context) : _buildMobileAppBar(context),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchDocuments,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                // Stretch to available width but with a reasonable maximum for large screens
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingCard(context),
                    const SizedBox(height: 24),
                    
                    Text(
                      'Your Documents',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_isLoadingDocs && _documents.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else if (_documents.isEmpty)
                      _buildEmptyState(theme)
                    else
                      _buildDocumentList(theme),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isUploading ? null : _pickAndUploadPdf,
        icon: _isUploading 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : const Icon(Icons.upload_file_rounded),
        label: Text(_isUploading ? 'Uploading...' : 'Upload PDF'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 100,
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text(
            'No documents yet. Tap upload to start!',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _documents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = _documents[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
            ),
            title: Text(
              doc.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${doc.category} • ${doc.createdAt.day}/${doc.createdAt.month}/${doc.createdAt.year}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility_rounded, color: theme.colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfPreviewScreen(
                          url: doc.url,
                          fileName: doc.name,
                        ),
                      ),
                    );
                  },
                  tooltip: 'Preview PDF',
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
                  onPressed: () => _confirmDelete(doc),
                  tooltip: 'Delete Document',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_graph_rounded, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            loc?.translate('app_title') ?? 'FinFlow AI',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  PreferredSizeWidget _buildWebAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    
    return AppBar(
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            Icon(Icons.auto_graph_rounded, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Text(
              'FinFlow AI',
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                fontSize: 20, 
                letterSpacing: -0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _webNavItem(context, 'Home', Icons.home_rounded, () {}),
            _webNavItem(context, 'Profile', Icons.person_rounded, () => _navigate(context, '/profile')),
            _webNavItem(context, 'Settings', Icons.settings_rounded, () => _navigate(context, '/settings')),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: FilledButton.tonalIcon(
            onPressed: () => authViewModel.logout(),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Logout'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.7),
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _webNavItem(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final loc = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('👋', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'Welcome,',
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            authViewModel.userName,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'AI Insight: Your spending is looking great today!',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimary,
              child: Icon(Icons.person, color: theme.colorScheme.primary, size: 45),
            ),
            accountName: Text(
              authViewModel.userName, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            accountEmail: Text(authViewModel.userEmail, style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 12),
          _drawerItem(theme, Icons.dashboard_rounded, 'Home', () => Navigator.pop(context)),
          _drawerItem(theme, Icons.person_rounded, 'Profile', () {
            Navigator.pop(context);
            _navigate(context, '/profile');
          }),
          _drawerItem(theme, Icons.settings_rounded, 'Settings', () {
            Navigator.pop(context);
            _navigate(context, '/settings');
          }),
          const Spacer(),
          const Divider(indent: 20, endIndent: 20),
          _drawerItem(theme, Icons.logout_rounded, 'Logout', () {
            authViewModel.logout();
            Navigator.pushReplacementNamed(context, '/');
          }, color: theme.colorScheme.error),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _drawerItem(ThemeData theme, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? theme.colorScheme.onSurfaceVariant),
      title: Text(
        title, 
        style: TextStyle(
          color: color ?? theme.colorScheme.onSurface, 
          fontWeight: FontWeight.w600,
          fontSize: 16,
        )
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
