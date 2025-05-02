import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/app_snackbar.dart';
import 'package:salon_management/app/feature/settings/data/services/shop_details_service.dart';
import 'package:salon_management/app/feature/settings/domain/models/shop_details_model.dart';

@RoutePage()
class ShopDetailsScreen extends ConsumerStatefulWidget {
  const ShopDetailsScreen({super.key});

  @override
  ConsumerState<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends ConsumerState<ShopDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _sloganController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  Future<void> _saveShopDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final service = ref.read(shopDetailsServiceProvider);

        final shopDetails = ShopDetailsModel(
          name: _nameController.text,
          mobileNumber: _mobileController.text,
          address: _addressController.text,
          email:
              _emailController.text.isNotEmpty ? _emailController.text : null,
          gstNumber:
              _gstController.text.isNotEmpty ? _gstController.text : null,
          slogan:
              _sloganController.text.isNotEmpty ? _sloganController.text : null,
        );

        await service.saveShopDetails(shopDetails);

        // Refresh the provider
        ref.refresh(shopDetailsProvider);

        if (mounted) {
          AppSnackbar.showSuccess(context, 'Shop details saved successfully');
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          AppSnackbar.showError(context, 'Failed to save shop details: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch shop details provider
    final shopDetailsAsync = ref.watch(shopDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveShopDetails,
          ),
        ],
      ),
      body: shopDetailsAsync.when(
        data: (shopDetails) {
          // Prefill form with data if not already done
          if (_nameController.text.isEmpty) {
            _nameController.text = shopDetails.name;
            _mobileController.text = shopDetails.mobileNumber;
            _addressController.text = shopDetails.address;
            _emailController.text = shopDetails.email ?? '';
            _gstController.text = shopDetails.gstNumber ?? '';
            _sloganController.text = shopDetails.slogan ?? '';
          }

          return _buildForm();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error loading shop details: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(shopDetailsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Information',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Shop Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Company/Shop Name *',
                      hintText: 'Enter your shop name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter shop name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mobile Number
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number *',
                      hintText: 'Enter contact number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter contact number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address *',
                      hintText: 'Enter your shop address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter shop address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email (optional)
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email (optional)',
                      hintText: 'Enter business email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // GST Number (optional)
                  TextFormField(
                    controller: _gstController,
                    decoration: const InputDecoration(
                      labelText: 'GST Number (optional)',
                      hintText: 'Enter GST number if applicable',
                      prefixIcon: Icon(Icons.receipt),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 16),

                  // Slogan (optional)
                  TextFormField(
                    controller: _sloganController,
                    decoration: const InputDecoration(
                      labelText: 'Slogan/Tagline (optional)',
                      hintText: 'Enter your business slogan or tagline',
                      prefixIcon: Icon(Icons.format_quote),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveShopDetails,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Save Details'),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
