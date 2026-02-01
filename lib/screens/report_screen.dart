import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _currentStep = 1;
  final LatLng _defaultLocation = const LatLng(18.5204, 73.8567); // Pune
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Report Waste',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Custom Stepper
          Container(
            color: const Color(0xFF111111),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buildStepper(),
          ),

          // Content Area
          Expanded(child: _buildCurrentStep()),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildPhotoStep();
      case 2:
        return _buildLocationStep();
      case 3:
        return _buildDetailsStep();
      default:
        return _buildPhotoStep();
    }
  }

  // --- Step 1: Photo UI ---
  Widget _buildPhotoStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Take a photo of the waste',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please take a clear photo of the waste you want to report. This helps our team understand the situation better.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Photo Placeholder
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.camera,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No photo selected',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Take Photo Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.camera, size: 20),
                    label: const Text(
                      'Take Photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Photo Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            LucideIcons.lightbulb,
                            size: 20,
                            color: Color(0xFF1565C0),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Photo Tips',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTipItem(
                        'Ensure good lighting for clear visibility',
                      ),
                      const SizedBox(height: 8),
                      _buildTipItem('Capture the full extent of the waste'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        _buildBottomBar(
          onNext: () {
            setState(() {
              _currentStep = 2;
            });
          },
        ),
      ],
    );
  }

  // --- Step 2: Location UI ---
  Widget _buildLocationStep() {
    return Column(
      children: [
        // Map Section (Top Half)
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: _defaultLocation,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.citysense.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _defaultLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          LucideIcons.mapPin,
                          size: 40,
                          color: Color(0xFFEF4444), // Red pin
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Details Section (Bottom Half)
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Current Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              LucideIcons.mapPin,
                              size: 20,
                              color: Color(0xFF111111),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'HXCJ+6W5 Main Entrance gate, Wagholi, Pune, Maharashtra',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.crosshair,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Lat: 18.572994, Lng: 73.982422',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.locateFixed,
                              size: 16,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Fair accuracy (±27.6m)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFF59E0B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Refresh Location Button
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF111111)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.refreshCw,
                              size: 20,
                              color: Color(0xFF111111),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Note: Red pin shows where the waste report will be submitted',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildNavButtons(
                  onBack: () => setState(() => _currentStep = 1),
                  onNext: () => setState(() => _currentStep = 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Step 3: Details UI ---
  Widget _buildDetailsStep() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Describe the waste',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '(Optional)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF616161),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You can provide additional details about the waste you are reporting. This will help our team categorize and prioritize the issue.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Description Input
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Description (Optional)',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Report Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111111),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://placehold.co/100x100/png',
                                ), // Placeholder
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Photo attached',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Size: 0.06 MB',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Color(0xFF111111),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Wagholi, Pune',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111111),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Step 3 Bottom Bar (Back + Submit)
        Container(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep = 2),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF111111)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.chevronLeft,
                          size: 16,
                          color: Color(0xFF111111),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFF111111),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit action
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report submitted successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E), // Almost black
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(LucideIcons.send, size: 16), // Or check/arrow
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButtons({
    required VoidCallback onBack,
    required VoidCallback onNext,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF111111)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      size: 16,
                      color: Color(0xFF111111),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111111),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(LucideIcons.chevronRight, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar({required VoidCallback onNext}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF212121),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF424242)),
                ),
              ),
              child: const Row(
                children: [
                  Text('Next'),
                  SizedBox(width: 8),
                  Icon(LucideIcons.chevronRight, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Common Helper Widgets ---
  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFF1565C0),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1976D2),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          _buildStepCircle(
            1,
            'Photo',
            isActive: _currentStep == 1,
            isCompleted: _currentStep > 1,
          ),
          _buildStepLine(isActive: _currentStep > 1),
          _buildStepCircle(
            2,
            'Location',
            isActive: _currentStep == 2,
            isCompleted: _currentStep > 2,
          ),
          _buildStepLine(isActive: _currentStep > 2),
          _buildStepCircle(
            3,
            'Details',
            isActive: _currentStep == 3,
            isCompleted: _currentStep > 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    int step,
    String label, {
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.white : const Color(0xFF2C2C2C),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.white : const Color(0xFF424242),
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(LucideIcons.check, size: 16, color: Colors.black)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : const Color(0xFF757575),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : const Color(0xFF757575),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
        color: isActive ? Colors.white : const Color(0xFF424242),
      ),
    );
  }
}
