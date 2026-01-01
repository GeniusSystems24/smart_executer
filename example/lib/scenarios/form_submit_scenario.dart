import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:super_dialog/super_dialog.dart';

import '../core/app_theme.dart';
import '../core/widgets.dart';

/// Scenario: Form Submission with Confirmation Dialogs
///
/// This demonstrates:
/// - SuperDialog for beautiful confirmation dialogs
/// - SmartExecuter for form submission with loading
/// - SmartStatusCards for success/error feedback
/// - Complete form workflow with validation
class FormSubmitScenario extends StatefulWidget {
  const FormSubmitScenario({super.key});

  @override
  State<FormSubmitScenario> createState() => _FormSubmitScenarioState();
}

class _FormSubmitScenarioState extends State<FormSubmitScenario> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  bool _isSubmitting = false;
  Map<String, dynamic>? _lastResult;
  bool _hasError = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Show confirmation dialog before submit
  void _showSubmitConfirmation() {
    if (!_formKey.currentState!.validate()) return;

    SuperDialog.showAnimatedDialog<bool>(
      context,
      (context) => _ConfirmationDialog(
        title: 'Submit Post',
        message: 'Are you sure you want to create this post?',
        icon: Icons.send,
        iconColor: AppColors.primary,
        confirmText: 'Submit',
        cancelText: 'Cancel',
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
      ),
      animation: DialogAnimation.centerScale,
      config: const SuperDialogConfig(
        openDuration: Duration(milliseconds: 300),
        openCurve: Curves.easeOutBack,
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _submitForm();
      }
    });
  }

  /// Submit form with SmartExecuter
  Future<void> _submitForm() async {
    setState(() {
      _isSubmitting = true;
      _lastResult = null;
      _hasError = false;
    });

    await SmartExecuter.run(
      request: () => _dio.post('/posts', data: {
        'title': _titleController.text,
        'body': _bodyController.text,
        'userId': 1,
      }),
      context: context,
      options: const ExecuterOptions(
        operationName: 'createPost',
        metadata: {'action': 'form_submit'},
      ),
      onSuccess: (response) async {
        setState(() {
          _lastResult = response.data;
          _hasError = false;
          _isSubmitting = false;
        });

        // Show success dialog
        if (mounted) {
          _showSuccessDialog(response.data);
        }
      },
      onError: (exception) async {
        setState(() {
          _lastResult = {'error': exception.message};
          _hasError = true;
          _isSubmitting = false;
        });

        // Show error dialog
        if (mounted) {
          _showErrorDialog(exception);
        }
      },
    );
  }

  /// Show success dialog with animation
  void _showSuccessDialog(Map<String, dynamic> data) {
    SuperDialog.showAnimatedDialog<void>(
      context,
      (context) => _ResultDialog(
        isSuccess: true,
        title: 'Post Created!',
        message: 'Your post has been created successfully with ID: ${data['id']}',
        onDismiss: () {
          Navigator.pop(context);
          _resetForm();
        },
      ),
      animation: DialogAnimation.bounceIn,
      config: const SuperDialogConfig(
        openDuration: Duration(milliseconds: 500),
      ),
    );
  }

  /// Show error dialog with animation
  void _showErrorDialog(SmartException exception) {
    SuperDialog.showAnimatedDialog<void>(
      context,
      (context) => _ResultDialog(
        isSuccess: false,
        title: 'Submission Failed',
        message: exception.message,
        onDismiss: () => Navigator.pop(context),
        onRetry: () {
          Navigator.pop(context);
          _submitForm();
        },
      ),
      animation: DialogAnimation.elasticIn,
      config: const SuperDialogConfig(
        openDuration: Duration(milliseconds: 400),
      ),
    );
  }

  /// Show delete confirmation with positioned dialog
  void _showDeleteConfirmation() {
    SuperDialog.showPositionedDialog<bool>(
      context,
      (context) => _ConfirmationDialog(
        title: 'Clear Form',
        message: 'This will clear all entered data. Continue?',
        icon: Icons.delete_forever,
        iconColor: AppColors.error,
        confirmText: 'Clear',
        confirmColor: AppColors.error,
        cancelText: 'Keep',
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
      ),
      startPosition: DialogPosition.bottomCenter,
      endPosition: DialogPosition.center,
      transitionType: PositionedTransitionType.slideFadeScale,
    ).then((confirmed) {
      if (confirmed == true) {
        _resetForm();
      }
    });
  }

  void _resetForm() {
    _titleController.clear();
    _bodyController.clear();
    setState(() {
      _lastResult = null;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Form Submit',
              subtitle: 'SuperDialog + SmartExecuter integration',
              icon: Icons.edit_document,
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Result display
                    if (_lastResult != null) ...[
                      ResultCard(
                        title: _hasError ? 'Error' : 'Success',
                        content: _lastResult.toString(),
                        isError: _hasError,
                        onClear: () => setState(() => _lastResult = null),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Form section
                    const SectionHeader(
                      title: 'Create New Post',
                      subtitle: 'Fill in the form and submit',
                    ),

                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter post title',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.length < 3) {
                          return 'Title must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Body field
                    TextFormField(
                      controller: _bodyController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        hintText: 'Enter post content',
                        alignLabelWithHint: true,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 80),
                          child: Icon(Icons.article),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter content';
                        }
                        if (value.length < 10) {
                          return 'Content must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSubmitting ? null : _showDeleteConfirmation,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppColors.error),
                              foregroundColor: AppColors.error,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _isSubmitting ? null : _showSubmitConfirmation,
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(_isSubmitting ? 'Submitting...' : 'Submit'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Demo section
                    const SectionHeader(
                      title: 'Dialog Animations',
                      subtitle: 'Try different dialog styles',
                    ),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _AnimationDemoButton(
                          label: 'Bounce',
                          animation: DialogAnimation.bounceIn,
                        ),
                        _AnimationDemoButton(
                          label: 'Elastic',
                          animation: DialogAnimation.elasticIn,
                        ),
                        _AnimationDemoButton(
                          label: 'Slide Up',
                          animation: DialogAnimation.bottomToTop,
                        ),
                        _AnimationDemoButton(
                          label: 'Scale',
                          animation: DialogAnimation.centerScale,
                        ),
                        _AnimationDemoButton(
                          label: 'Rotate',
                          animation: DialogAnimation.rotateIn,
                        ),
                        _AnimationDemoButton(
                          label: 'Flip',
                          animation: DialogAnimation.flipVertical,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Code preview
                    const CodePreview(
                      language: 'dart',
                      code: '''// Confirmation dialog with SuperDialog
SuperDialog.showAnimatedDialog<bool>(
  context,
  (context) => ConfirmationDialog(...),
  animation: DialogAnimation.centerScale,
).then((confirmed) {
  if (confirmed == true) {
    // Submit with SmartExecuter
    await SmartExecuter.run(
      request: () => dio.post('/posts', data: formData),
      context: context,
      onSuccess: (response) => showSuccessDialog(),
      onError: (error) => showErrorDialog(error),
    );
  }
});''',
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirmation dialog widget
class _ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ConfirmationDialog({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.confirmText,
    required this.cancelText,
    this.confirmColor,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onConfirm,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: confirmColor ?? AppColors.primary,
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Result dialog widget (success/error)
class _ResultDialog extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final VoidCallback onDismiss;
  final VoidCallback? onRetry;

  const _ResultDialog({
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.onDismiss,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? AppColors.success : AppColors.error;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onRetry != null && !isSuccess)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDismiss,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onDismiss,
                  style: FilledButton.styleFrom(backgroundColor: color),
                  child: Text(isSuccess ? 'Continue' : 'OK'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Animation demo button
class _AnimationDemoButton extends StatelessWidget {
  final String label;
  final DialogAnimation animation;

  const _AnimationDemoButton({
    required this.label,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        SuperDialog.showAnimatedDialog<void>(
          context,
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.animation, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    '$label Animation',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This dialog uses $label animation',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
          animation: animation,
          config: const SuperDialogConfig(
            openDuration: Duration(milliseconds: 400),
          ),
        );
      },
      child: Text(label),
    );
  }
}
