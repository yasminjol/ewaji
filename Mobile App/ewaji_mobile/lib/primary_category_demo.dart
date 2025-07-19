import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'features/auth/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  
  runApp(const PrimaryCategoryDemoApp());
}

class PrimaryCategoryDemoApp extends StatelessWidget {
  const PrimaryCategoryDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primary Category Selector Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade100,
          selectedColor: Colors.blue.shade50,
          checkmarkColor: Colors.blue,
          labelStyle: const TextStyle(color: Colors.black87),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const DemoNavigationWrapper(),
    );
  }
}

class DemoNavigationWrapper extends StatefulWidget {
  const DemoNavigationWrapper({super.key});

  @override
  State<DemoNavigationWrapper> createState() => _DemoNavigationWrapperState();
}

class _DemoNavigationWrapperState extends State<DemoNavigationWrapper> {
  int _currentStep = 2; // Simulating step 2 of onboarding

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Onboarding'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Simulate going back in onboarding
            if (_currentStep > 1) {
              setState(() {
                _currentStep--;
              });
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Simulate skipping
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Skip Step'),
                  content: const Text('Are you sure you want to skip category selection?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentStep = 3;
                        });
                      },
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Skip'),
          ),
        ],
      ),
      body: _buildCurrentStep(),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return const PrimaryCategoryDemo();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return _buildCompletion();
    }
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LinearProgressIndicator(value: 0.25),
          const SizedBox(height: 24),
          const Text(
            'Step 1 of 4',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tell us about yourself to create your provider profile.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 2;
                });
              },
              child: const Text('Continue to Categories'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LinearProgressIndicator(value: 0.75),
          const SizedBox(height: 24),
          const Text(
            'Step 3 of 4',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Service Areas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select the areas where you provide services.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 4;
                });
              },
              child: const Text('Continue to Verification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LinearProgressIndicator(value: 1.0),
          const SizedBox(height: 24),
          const Text(
            'Step 4 of 4',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Verification',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload documents to verify your credentials.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 5;
                });
              },
              child: const Text('Complete Registration'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletion() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'Registration Complete!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your provider account has been created successfully.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 1; // Reset demo
                });
              },
              child: const Text('Restart Demo'),
            ),
          ),
        ],
      ),
    );
  }
}
