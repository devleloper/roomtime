import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_bounce_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FamilyCalls')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Join or Create a Room',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 32),
              _buildActionSection(context),
              const SizedBox(height: 48),
              Text(
                'Active Public Rooms',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // Dummy data
                  itemBuilder: (context, index) {
                    return _buildRoomCard(context, 'Public Room ${index + 1}');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    final controller = TextEditingController();
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(controller: controller, hintText: 'Enter Room Name'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomBounceButton(
                  onPressed: () {
                    // Navigate to room join logic
                    if (controller.text.isNotEmpty) {
                      context.go('/room/${controller.text}');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Join Room',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomBounceButton(
                  onPressed: () {
                    // Navigate to room creation logic
                    if (controller.text.isNotEmpty) {
                      context.go('/room/${controller.text}'); // Simplified
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Create Room',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, String roomName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CustomBounceButton(
        onPressed: () => context.go('/room/$roomName'),
        child: CustomCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roomName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
