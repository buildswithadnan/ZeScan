import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/document_scanner_service.dart';
import 'preview_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with WidgetsBindingObserver {
  bool _isContinuousMode = false;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _switchToSingleMode(BuildContext context) {
    final state = AppStateProvider.of(context);
    
    // If switching to single mode and there are items in queue, ask user
    if (_isContinuousMode && state.scanQueue.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Switch to Single Scan?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            'You have ${state.scanQueue.length} page${state.scanQueue.length > 1 ? 's' : ''} in the queue. Switching to Single Scan mode will keep them. Continue?',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isContinuousMode = false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
              child: const Text('Switch Mode', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      setState(() => _isContinuousMode = false);
    }
  }

  void _switchToContinuousMode(BuildContext context) {
    setState(() => _isContinuousMode = true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _capturePage(BuildContext context) async {
    if (_isScanning) return;

    final state = AppStateProvider.of(context);

    // In Single Scan mode, clear previous queue before scanning
    if (!_isContinuousMode && state.scanQueue.isNotEmpty) {
      state.clearScanQueue();
    }

    setState(() {
      _isScanning = true;
    });

    try {
      // Use ML Kit's built-in scanner with automatic capture and edge detection
      final scannedPaths = await DocumentScannerService.scanDocumentWithMLKit();

      if (!mounted) return;

      setState(() {
        _isScanning = false;
      });

      if (scannedPaths.isEmpty) {
        // User cancelled - don't show error message
        return;
      }

      // Add all scanned pages to queue
      for (var path in scannedPaths) {
        state.addPageToScanQueue(path);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${scannedPaths.length} page${scannedPaths.length > 1 ? 's' : ''} scanned successfully!'),
          duration: const Duration(milliseconds: 800),
          backgroundColor: AppTheme.success,
        ),
      );

      if (!_isContinuousMode) {
        // Single Scan Mode: navigate to Preview immediately
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PreviewScreen()),
        );
      }
      // In continuous mode, stay on scanner screen and show "Done" button
      // User can choose to scan another page or finish
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
      });
      
      // User-friendly error message
      String errorMessage = 'Unable to scan document';
      if (e.toString().contains('permission')) {
        errorMessage = 'Camera permission is required to scan documents';
      } else if (e.toString().contains('not available')) {
        errorMessage = 'ML Kit scanner is not available on this device';
      } else if (e.toString().contains('cancel')) {
        // User cancelled, don't show error
        return;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppTheme.danger,
          action: SnackBarAction(
            label: 'Use Gallery',
            textColor: Colors.white,
            onPressed: () => _pickFromGallery(context),
          ),
        ),
      );
    }
  }

  void _pickFromGallery(BuildContext context) async {
    debugPrint('Scanner: Gallery import started');
    
    // Request photo permission first
    if (!mounted) return;
    final hasPermission = await PermissionService.requestPhotos(context);
    if (!hasPermission) {
      debugPrint('Scanner: Photo permission denied');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo library access is required to import images'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    debugPrint('Scanner: Photo permission granted, opening picker');
    final state = AppStateProvider.of(context);
    final picker = ImagePicker();

    try {
      // Let user select images from gallery
      debugPrint('Scanner: Calling pickMultiImage()');
      final List<XFile>? images = await picker.pickMultiImage(
        imageQuality: 100,
      );
      
      debugPrint('Scanner: pickMultiImage returned: ${images?.length ?? 0} images');
      
      if (images == null || images.isEmpty) {
        debugPrint('Scanner: No images selected, user cancelled');
        return;
      }

      debugPrint('Scanner: User selected ${images.length} images');

      if (!mounted) return;

      // In Single Scan mode, clear previous queue before importing
      if (!_isContinuousMode && state.scanQueue.isNotEmpty) {
        debugPrint('Scanner: Clearing previous scan queue');
        state.clearScanQueue();
      }

      // Add all images directly to queue without processing
      for (var image in images) {
        state.addPageToScanQueue(image.path);
      }

      debugPrint('Scanner: Added ${images.length} images to queue');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${images.length} image${images.length > 1 ? 's' : ''} imported successfully!'),
            duration: const Duration(milliseconds: 1000),
            backgroundColor: AppTheme.success,
          ),
        );
        
        // Navigate to preview
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        
        debugPrint('Scanner: Navigating to preview screen');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PreviewScreen()),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Scanner: Gallery import EXCEPTION: $e');
      debugPrint('Scanner: Stack trace: $stackTrace');
      
      if (mounted) {
        String errorMessage = 'Unable to import images';
        
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('permission')) {
          errorMessage = 'Photo library access was denied';
        } else if (errorStr.contains('cancel')) {
          debugPrint('Scanner: User cancelled image selection');
          return; // User cancelled, don't show error
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.danger,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _pickFromGalleryEnhanced(BuildContext context) async {
    debugPrint('Scanner: Enhanced gallery import started');
    
    // Request photo permission first
    if (!mounted) return;
    final hasPermission = await PermissionService.requestPhotos(context);
    if (!hasPermission) {
      debugPrint('Scanner: Photo permission denied');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo library access is required to import images'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    final state = AppStateProvider.of(context);

    // In Single Scan mode, clear previous queue before importing
    if (!_isContinuousMode && state.scanQueue.isNotEmpty) {
      state.clearScanQueue();
    }

    try {
      // Use ML Kit scanner with gallery import enabled
      debugPrint('Scanner: Opening ML Kit with gallery mode');
      final scannedPaths = await DocumentScannerService.scanDocumentFromGallery();
      
      if (scannedPaths.isEmpty) {
        debugPrint('Scanner: No images scanned, user cancelled');
        return;
      }

      debugPrint('Scanner: ML Kit processed ${scannedPaths.length} images');

      // Add all scanned images to queue
      for (var path in scannedPaths) {
        state.addPageToScanQueue(path);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${scannedPaths.length} image${scannedPaths.length > 1 ? 's' : ''} enhanced and imported!'),
            duration: const Duration(milliseconds: 1000),
            backgroundColor: AppTheme.success,
          ),
        );
        
        // Navigate to preview
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        
        debugPrint('Scanner: Navigating to preview screen');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PreviewScreen()),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Scanner: Enhanced import EXCEPTION: $e');
      debugPrint('Scanner: Stack trace: $stackTrace');
      
      if (mounted) {
        String errorMessage = 'Unable to import images';
        
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('permission')) {
          errorMessage = 'Photo library access was denied';
        } else if (errorStr.contains('cancel')) {
          debugPrint('Scanner: User cancelled');
          return;
        } else if (errorStr.contains('not available')) {
          errorMessage = 'ML Kit scanner is not available on this device';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.danger,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final queueCount = state.scanQueue.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Scan Document',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Scanner Icon
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryGlow,
                          border: Border.all(color: AppTheme.primary, width: 2),
                        ),
                        child: Icon(
                          LucideIcons.scan,
                          color: AppTheme.primary,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Title
                      Text(
                        _isContinuousMode ? 'Continuous Scan Mode' : 'Ready to Scan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // Description
                      Text(
                        _isContinuousMode 
                          ? 'After each scan, you can add more pages or tap "Done Scanning" to finish.'
                          : 'Tap the scan button to automatically capture and crop your document',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Scan Button or Done Button
                      if (!_isContinuousMode || queueCount == 0) ...[
                        // Show Start Scanning button
                        ElevatedButton.icon(
                          onPressed: _isScanning ? null : () => _capturePage(context),
                          icon: _isScanning
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(LucideIcons.camera, size: 20),
                          label: Text(
                            _isScanning ? 'Scanning...' : 'Start Scanning',
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ] else ...[
                        // In continuous mode with scans, show Done button prominently
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PreviewScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(LucideIcons.check, size: 20),
                              label: const Text(
                                'Done Scanning',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: _isScanning ? null : () => _capturePage(context),
                              icon: _isScanning
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                                      ),
                                    )
                                  : const Icon(LucideIcons.camera, size: 18),
                              label: Text(
                                _isScanning ? 'Scanning...' : 'Scan Another Page',
                                style: const TextStyle(fontSize: 14),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 12),
                      
                      // Gallery Import Button
                      TextButton.icon(
                        onPressed: () => _pickFromGallery(context),
                        icon: const Icon(LucideIcons.image, size: 18),
                        label: const Text('Import from Gallery'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                        ),
                      ),
                      
                      if (queueCount > 0) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$queueCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$queueCount page${queueCount > 1 ? 's' : ''} scanned',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PreviewScreen(),
                                    ),
                                  );
                                },
                                child: const Text('View'),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Mode Toggle Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                border: Border(
                  top: BorderSide(color: AppTheme.borderDark),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Scan Mode',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _switchToSingleMode(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isContinuousMode ? AppTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: !_isContinuousMode ? AppTheme.primary : AppTheme.borderDark,
                            ),
                          ),
                          child: Text(
                            'Single Scan',
                            style: TextStyle(
                              color: !_isContinuousMode ? Colors.white : AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _switchToContinuousMode(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isContinuousMode ? AppTheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _isContinuousMode ? AppTheme.primary : AppTheme.borderDark,
                            ),
                          ),
                          child: Text(
                            'Continuous',
                            style: TextStyle(
                              color: _isContinuousMode ? Colors.white : AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
  }
}
