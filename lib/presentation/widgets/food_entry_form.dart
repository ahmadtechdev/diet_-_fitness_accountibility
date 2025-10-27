import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/food_entry.dart';
import '../../data/models/fine_set.dart';
import '../controllers/settings_controller.dart';
import '../controllers/food_tracker_controller.dart';

class FoodEntryForm extends StatefulWidget {
  final DateTime selectedDate;
  final FoodEntry? initialEntry;
  final Function(FoodEntry) onSave;

  const FoodEntryForm({
    super.key,
    required this.selectedDate,
    this.initialEntry,
    required this.onSave,
  });

  @override
  State<FoodEntryForm> createState() => _FoodEntryFormState();
}

class _FoodEntryFormState extends State<FoodEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedWhoAte = AppConstants.him;
  String _selectedFoodType = AppConstants.clean;
  DateTime _selectedDate = DateTime.now();
  
  bool get isEditing => widget.initialEntry != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    
    if (isEditing) {
      final entry = widget.initialEntry!;
      _foodNameController.text = entry.foodName;
      _quantityController.text = entry.quantity.toString();
      _notesController.text = entry.notes;
      _selectedWhoAte = entry.whoAte;
      _selectedFoodType = entry.foodType;
      _selectedDate = entry.date;
    } else {
      _quantityController.text = '1';
    }
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateSelector(),
                    const SizedBox(height: 24),
                    _buildWhoAteSelector(),
                    const SizedBox(height: 24),
                    _buildFoodTypeSelector(),
                    const SizedBox(height: 24),
                    _buildFoodNameField(),
                    const SizedBox(height: 24),
                    _buildQuantityField(),
                    const SizedBox(height: 24),
                    _buildNotesField(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    _buildFinePreview(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        color: AppColors.primaryPink,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Entry' : 'Add New Entry',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Track your food journey 💕',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryPink),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWhoAteSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who Ate?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWhoAte,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: AppConstants.him,
                  child: Row(
                    children: [
                      const Text('👨', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(AppConstants.him),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AppConstants.her,
                  child: Row(
                    children: [
                      const Text('👩', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(AppConstants.her),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AppConstants.both,
                  child: Row(
                    children: [
                      const Text('👫', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(AppConstants.both),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedWhoAte = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Food Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFoodType,
              isExpanded: true,
              items: AppConstants.foodTypeEmojis.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Row(
                    children: [
                      Text(entry.value, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFoodType = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Food Name',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Optional',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _foodNameController,
          decoration: InputDecoration(
            hintText: 'e.g., Pizza, Salad, Biryani... (Leave empty to use food type)',
            prefixIcon: const Icon(Icons.restaurant, color: AppColors.primaryPink),
            helperText: 'If left empty, will use the selected food type as the name',
            helperStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          validator: (value) {
            // No validation needed - field is optional
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: '1 or 0.5',
            prefixIcon: Icon(Icons.numbers, color: AppColors.primaryPink),
            helperText: 'Enter quantity (e.g., 1, 0.5, 2.5)',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter quantity';
            }
            final quantity = double.tryParse(value);
            if (quantity == null || quantity <= 0) {
              return 'Please enter a valid quantity (must be > 0)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Any additional notes...',
            prefixIcon: Icon(Icons.note, color: AppColors.primaryPink),
          ),
        ),
      ],
    );
  }



  Widget _buildFinePreview() {
    final quantity = double.tryParse(_quantityController.text) ?? 1.0;
    
    // Get fine settings for this food type
    final settingsController = Get.find<SettingsController>();
    final fineSettings = settingsController.fineSettings
        .where((setting) => setting.foodType == _selectedFoodType)
        .firstOrNull;
    
    if (fineSettings != null && _selectedFoodType != AppConstants.clean) {
      return _buildSettingsBasedFinePreview(quantity, fineSettings);
    } else {
      return _buildFallbackFinePreview(quantity);
    }
  }

  Widget _buildSettingsBasedFinePreview(double quantity, fineSettings) {
    // Get existing food entries to check weekly limits
    final existingEntries = Get.find<FoodTrackerController>().foodEntries;
    
    // Create distributed fines
    final distributedFines = ExerciseFine.createDistributedFines(
      _selectedFoodType,
      quantity,
      _selectedWhoAte,
      fineSettings,
      existingEntries: existingEntries,
    );

    final himFine = distributedFines['him']!;
    final herFine = distributedFines['her']!;

    if (_selectedWhoAte == AppConstants.both) {
      // Show fines for both Him and Her
      return Column(
        children: [
          _buildDistributedFinePreview(himFine, 'Him', fineSettings.himFineSet),
          const SizedBox(height: 12),
          _buildDistributedFinePreview(herFine, 'Her', fineSettings.herFineSet),
        ],
      );
    } else {
      // Show fine for selected person and partner distribution
      final personFine = _selectedWhoAte == AppConstants.him ? himFine : herFine;
      final partnerFine = _selectedWhoAte == AppConstants.him ? herFine : himFine;
      final personDisplayName = _selectedWhoAte == AppConstants.him ? 'Him' : 'Her';
      final partnerDisplayName = _selectedWhoAte == AppConstants.him ? 'Her' : 'Him';
      
      // Always show both fines for junk food (unless both are 0)
      if (personFine.totalExercises == 0 && partnerFine.totalExercises == 0) {
        return _buildDistributedFinePreview(personFine, personDisplayName, 
          _selectedWhoAte == AppConstants.him ? fineSettings.himFineSet : fineSettings.herFineSet);
      }
      
      return Column(
        children: [
          if (personFine.totalExercises > 0) ...[
            _buildDistributedFinePreview(
              personFine, 
              personDisplayName, 
              _selectedWhoAte == AppConstants.him ? fineSettings.himFineSet : fineSettings.herFineSet
            ),
          ],
          if (partnerFine.totalExercises > 0) ...[
            if (personFine.totalExercises > 0) const SizedBox(height: 12),
            _buildDistributedFinePreview(
              partnerFine, 
              partnerDisplayName, 
              _selectedWhoAte == AppConstants.him ? fineSettings.herFineSet : fineSettings.himFineSet,
              isPartnerDistribution: true,
            ),
          ],
        ],
      );
    }
  }

  Widget _buildDistributedFinePreview(ExerciseFine fine, String displayName, FineSet? fineSet, {bool isPartnerDistribution = false}) {
    final hasFine = fine.totalExercises > 0;
    String fineDescription = '';
    
    if (hasFine && fineSet != null) {
      fineDescription = fineSet.exercisesDescription;
    } else if (hasFine) {
      fineDescription = fine.description;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasFine 
            ? (isPartnerDistribution ? Colors.orange.withOpacity(0.1) : AppColors.junkFoodRed.withOpacity(0.1))
            : AppColors.cleanDayGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFine 
              ? (isPartnerDistribution ? Colors.orange.withOpacity(0.3) : AppColors.junkFoodRed.withOpacity(0.3))
              : AppColors.cleanDayGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasFine ? Icons.fitness_center : Icons.eco,
                color: hasFine 
                    ? (isPartnerDistribution ? Colors.orange : AppColors.junkFoodRed)
                    : AppColors.cleanDayGreen,
              ),
              const SizedBox(width: 8),
              Text(
                hasFine 
                    ? (isPartnerDistribution ? '$displayName - Love Distribution' : '$displayName - Exercise Fine')
                    : '$displayName - Clean Day!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasFine 
                      ? (isPartnerDistribution ? Colors.orange : AppColors.junkFoodRed)
                      : AppColors.cleanDayGreen,
                ),
              ),
              if (isPartnerDistribution) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'From Partner',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (hasFine) ...[
            Text(
              fineDescription,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Show exercise breakdown
            _buildExerciseBreakdown(fine),
            const SizedBox(height: 4),
            Text(
              'Total: ${fine.totalExercises} exercises',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else
            const Text(
              'No exercises needed! Great choice! 💚',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.cleanDayGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonFinePreview(double quantity, fineSettings, String whoAte, String displayName) {
    final fine = ExerciseFine.calculateFromFineSettings(
      _selectedFoodType,
      quantity,
      whoAte,
      fineSettings,
    );
    
    final hasFine = fine.totalExercises > 0;
    final fineSet = whoAte == AppConstants.him 
        ? fineSettings.himFineSet 
        : fineSettings.herFineSet;
    
    String fineDescription = '';
    if (hasFine && fineSet != null) {
      fineDescription = fineSet.exercisesDescription;
    } else if (hasFine) {
      fineDescription = fine.description;
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasFine 
            ? AppColors.junkFoodRed.withOpacity(0.1)
            : AppColors.cleanDayGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFine 
              ? AppColors.junkFoodRed.withOpacity(0.3)
              : AppColors.cleanDayGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasFine ? Icons.fitness_center : Icons.eco,
                color: hasFine 
                    ? AppColors.junkFoodRed 
                    : AppColors.cleanDayGreen,
              ),
              const SizedBox(width: 8),
              Text(
                hasFine ? '$displayName - Exercise Fine' : '$displayName - Clean Day!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasFine 
                      ? AppColors.junkFoodRed 
                      : AppColors.cleanDayGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (hasFine) ...[
            Text(
              fineDescription,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Show exercise breakdown
            _buildExerciseBreakdown(fine),
            const SizedBox(height: 4),
            Text(
              'Total: ${fine.totalExercises} exercises',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else
            const Text(
              'No exercises needed! Great choice! 💚',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.cleanDayGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackFinePreview(double quantity) {
    final fine = ExerciseFine.calculate(_selectedFoodType, quantity, _selectedWhoAte);
    final hasFine = fine.totalExercises > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasFine 
            ? AppColors.junkFoodRed.withOpacity(0.1)
            : AppColors.cleanDayGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFine 
              ? AppColors.junkFoodRed.withOpacity(0.3)
              : AppColors.cleanDayGreen.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasFine ? Icons.fitness_center : Icons.eco,
                color: hasFine 
                    ? AppColors.junkFoodRed 
                    : AppColors.cleanDayGreen,
              ),
              const SizedBox(width: 8),
              Text(
                hasFine ? 'Exercise Fine' : 'Clean Day!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasFine 
                      ? AppColors.junkFoodRed 
                      : AppColors.cleanDayGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (hasFine) ...[
            Text(
              fine.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            // Show exercise breakdown
            _buildExerciseBreakdown(fine),
            const SizedBox(height: 4),
            Text(
              'Total: ${fine.totalExercises} exercises',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else
            const Text(
              'No exercises needed! Great choice! 💚',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.cleanDayGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseBreakdown(ExerciseFine fine) {
    final exercises = <Widget>[];
    
    if (fine.jumpingRopes > 0) {
      exercises.add(_buildExerciseChip('🔄', '${fine.jumpingRopes} sets Jumping Ropes'));
    }
    if (fine.squats > 0) {
      exercises.add(_buildExerciseChip('🦵', '${fine.squats} sets Squats'));
    }
    if (fine.jumpingJacks > 0) {
      exercises.add(_buildExerciseChip('🤸', '${fine.jumpingJacks} sets Jumping Jacks'));
    }
    if (fine.highKnees > 0) {
      exercises.add(_buildExerciseChip('🏃', '${fine.highKnees} sets High Knees'));
    }
    if (fine.pushups > 0) {
      exercises.add(_buildExerciseChip('💪', '${fine.pushups} sets Pushups'));
    }
    
    if (exercises.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: exercises,
    );
  }

  Widget _buildExerciseChip(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveEntry,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          isEditing ? 'Update Entry' : 'Save Entry',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      final quantity = double.parse(_quantityController.text);
      
      // Use food type as name if food name is empty
      final foodName = _foodNameController.text.trim().isEmpty 
          ? _selectedFoodType 
          : _foodNameController.text.trim();
      
      final entry = isEditing
          ? widget.initialEntry!.copyWith(
              date: _selectedDate,
              whoAte: _selectedWhoAte,
              foodType: _selectedFoodType,
              foodName: foodName,
              quantity: quantity,
              notes: _notesController.text,
            )
          : FoodEntry.create(
              date: _selectedDate,
              whoAte: _selectedWhoAte,
              foodType: _selectedFoodType,
              foodName: foodName,
              quantity: quantity,
              notes: _notesController.text,
            );
      
      widget.onSave(entry);
    }
  }
}
