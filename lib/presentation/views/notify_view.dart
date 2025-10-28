import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_service.dart';

class NotifyView extends StatefulWidget {
  const NotifyView({super.key});

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedRecipient = AppConstants.him;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Test Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.romanticGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.notifications_active,
                            size: 24,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notification Testing',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Send test notifications to your partner',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textOnPrimary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recipient Selection
              Text(
                'Send to:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildRecipientButton(
                      AppConstants.him,
                      'Him',
                      Icons.male,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRecipientButton(
                      AppConstants.her,
                      'Her',
                      Icons.female,
                      Colors.pink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title Field
              Text(
                'Notification Title:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter notification title...',
                  prefixIcon: const Icon(Icons.title, color: AppColors.primaryPink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Body Field
              Text(
                'Notification Body:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter notification message...',
                  prefixIcon: const Icon(Icons.message, color: AppColors.primaryPink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.textOnPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Send Notification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Test Buttons
              Text(
                'Quick Tests:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _sendQuickTest('junk_food'),
                      icon: const Icon(Icons.fastfood, size: 18),
                      label: const Text('Junk Food'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.junkFoodRed,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _sendQuickTest('exercise'),
                      icon: const Icon(Icons.fitness_center, size: 18),
                      label: const Text('Exercise'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cleanDayGreen,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Test Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.romanticGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.textOnPrimary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.notifications_active,
                            size: 24,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notification Testing',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Send test notifications to your partner',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textOnPrimary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recipient Selection
              Text(
                'Send to:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildRecipientButton(
                      AppConstants.him,
                      'Him',
                      Icons.male,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRecipientButton(
                      AppConstants.her,
                      'Her',
                      Icons.female,
                      Colors.pink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title Field
              Text(
                'Notification Title:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter notification title...',
                  prefixIcon: const Icon(Icons.title, color: AppColors.primaryPink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Body Field
              Text(
                'Notification Body:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter notification message...',
                  prefixIcon: const Icon(Icons.message, color: AppColors.primaryPink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.textOnPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Send Notification',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Test Buttons
              Text(
                'Quick Tests:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _sendQuickTest('junk_food'),
                      icon: const Icon(Icons.fastfood, size: 18),
                      label: const Text('Junk Food'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.junkFoodRed,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _sendQuickTest('exercise'),
                      icon: const Icon(Icons.fitness_center, size: 18),
                      label: const Text('Exercise'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cleanDayGreen,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Extra space for keyboard
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientButton(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedRecipient == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRecipient = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendNotification() async {
    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both title and body'),
          backgroundColor: AppColors.junkFoodRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final notificationService = NotificationService();
      
      await notificationService.sendNotificationToPartner(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        data: {
          'type': 'test_notification',
          'recipient': _selectedRecipient,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification sent to $_selectedRecipient! 📱'),
          backgroundColor: AppColors.cleanDayGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Clear form
      _titleController.clear();
      _bodyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending notification: $e'),
          backgroundColor: AppColors.junkFoodRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendQuickTest(String type) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notificationService = NotificationService();
      
      String title, body;
      Map<String, dynamic> data;

      switch (type) {
        case 'junk_food':
          title = '🍔 Junk Food Alert!';
          body = _selectedRecipient == AppConstants.him 
              ? 'Your love ate junk food! Time for exercises! 💪'
              : 'Your love ate junk food! Time for exercises! 💪';
          data = {
            'type': 'junk_food_entry',
            'whoAte': _selectedRecipient,
            'foodName': 'Test Junk Food',
          };
          break;
        case 'exercise':
          title = '💪 Exercise Reminder!';
          body = _selectedRecipient == AppConstants.him 
              ? 'Time to complete your exercises! You can do it! 🔥'
              : 'Time to complete your exercises! You can do it! 🔥';
          data = {
            'type': 'exercise_reminder',
            'recipient': _selectedRecipient,
          };
          break;
        default:
          title = 'Test Notification';
          body = 'This is a test notification';
          data = {'type': 'test'};
      }

      await notificationService.sendNotificationToPartner(
        title: title,
        body: body,
        data: data,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$type notification sent to $_selectedRecipient! 📱'),
          backgroundColor: AppColors.cleanDayGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending $type notification: $e'),
          backgroundColor: AppColors.junkFoodRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
