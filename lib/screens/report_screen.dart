import 'package:citysense_flutter/screens/report_steps/details_step.dart';
import 'package:citysense_flutter/screens/report_steps/location_step.dart';
import 'package:citysense_flutter/screens/report_steps/photo_step.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _currentStep = 1;
  File? _selectedImage;
  LatLng _userLocation = const LatLng(18.5204, 73.8567); // Default
  String _address = "";

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
        return PhotoStep(
          selectedImage: _selectedImage,
          onImageSelected: (image) {
            setState(() {
              _selectedImage = image;
            });
          },
          onNext: () {
            setState(() {
              _currentStep = 2;
            });
          },
        );
      case 2:
        return LocationStep(
          onBack: () {
            setState(() {
              _currentStep = 1;
            });
          },
          onLocationConfirmed: (location, address) {
            setState(() {
              _userLocation = location;
              _address = address;
            });
          },
          onNext: () {
            setState(() {
              _currentStep = 3;
            });
          },
        );
      case 3:
        return DetailsStep(
          selectedImage: _selectedImage,
          userLocation: _userLocation,
          address: _address,
          onBack: () {
            setState(() {
              _currentStep = 2;
            });
          },
          onSuccess: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Report submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      default:
        return Container();
    }
  }

  // --- Custom Stepper UI ---
  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepIndicator(1, "Photo", _currentStep >= 1),
          _buildStepLine(_currentStep >= 2),
          _buildStepIndicator(2, "Location", _currentStep >= 2),
          _buildStepLine(_currentStep >= 3),
          _buildStepIndicator(3, "Details", _currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    bool isCompleted = _currentStep > step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF2E7D32) : Colors.transparent,
            border: Border.all(
              color: isActive ? const Color(0xFF2E7D32) : Colors.grey[700]!,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(LucideIcons.check, size: 16, color: Colors.white)
                : Text(
                    step.toString(),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF2E7D32) : Colors.grey[800],
      ),
    );
  }
}
