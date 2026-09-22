import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/property/presentation/widgets/property_input_field_widget.dart';

import '../../../../../../../../config/theme/app_colors.dart';
import '../../../../../../../../core/constant/app_icons.dart';
import '../../../../../../../../core/constant/images_path.dart';
import '../../../../../../../../core/constant/strings.dart';
import '../../../../config/routes/routes_names.dart';
import '../state_management/create_property_cubit.dart';
import '../state_management/create_property_state.dart';
import '../widgets/card_wiget.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button_widget.dart';

class PropertyLocationScreen extends StatefulWidget {
  const PropertyLocationScreen({super.key});

  @override
  State<PropertyLocationScreen> createState() => _PropertyLocationScreenState();
}

class _PropertyLocationScreenState extends State<PropertyLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  String? _selectedCity = 'Gaza';
  String? _selectedDistrict = 'Al-Wehda';

  int _rooms = 1;
  int _bathrooms = 1;

  String _selectedCurrency = 'JOD';
  static const List<String> _currencies = ['JOD', 'USD', 'ILS'];

  @override
  void initState() {
    super.initState();
    final state = context.read<CreatePropertyCubit>().state;
    if (state.priceCurrency.isNotEmpty &&
        _currencies.contains(state.priceCurrency)) {
      _selectedCurrency = state.priceCurrency;
    } else {
      context
          .read<CreatePropertyCubit>()
          .priceCurrencyChanged(_selectedCurrency);
    }
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    _buildingNoController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    _floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePropertyCubit, CreatePropertyState>(
      listener: (context, state) {
        if (state.status == CreatePropertyStatus.step2Saved) {
          context.push(RouteNames.listPropertyFeaturesScreen);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(ImagePath.background, fit: BoxFit.cover),
            ),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  HeaderWidget(
                    title: AppStrings.listYourPropertyPage2Title,
                    subTitle: AppStrings.listYourPropertyStep2,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidateMode,
                        child: Padding(
                          padding: const EdgeInsets.all(45),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomCardField(
                                      context,
                                      AppStrings.city,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: DropdownButton<String>(
                                          icon: SvgPicture.asset(
                                            AppIcons.arrowDown,
                                          ),
                                          value: _selectedCity,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.white,
                                                fontSize: 16,
                                              ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Gaza',
                                              child: Text('Gaza'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'option2',
                                              child: Text('Option 2'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCity = value;
                                            });
                                          },
                                        ),
                                      ),
                                      icon: AppIcons.location,
                                      isRequired: true,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCustomCardField(
                                      context,
                                      AppStrings.district,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: DropdownButton<String>(
                                          icon: SvgPicture.asset(
                                            AppIcons.arrowDown,
                                          ),
                                          value: _selectedDistrict,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.white,
                                                fontSize: 16,
                                              ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Al-Wehda',
                                              child: Text('Al-Wehda'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'option2',
                                              child: Text('Option 2'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedDistrict = value;
                                            });
                                          },
                                        ),
                                      ),
                                      icon: AppIcons.district,
                                      isRequired: true,
                                    ),
                                  ),
                                ],
                              ),
                              _buildCustomInputField(
                                context,
                                AppStrings.latitude,
                                AppStrings.latitudeHint,
                                _latitudeController,
                                isRequired: true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                validator: (value) {
                                  final val = value?.trim() ?? '';
                                  if (val.isEmpty) {
                                    return 'Please enter latitude';
                                  }
                                  final lat = double.tryParse(val);
                                  if (lat == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (lat < -90 || lat > 90) {
                                    return 'Must be between -90 and 90';
                                  }
                                  return null;
                                },
                              ),
                              _buildCustomInputField(
                                context,
                                AppStrings.longitude,
                                AppStrings.longitudeHint,
                                _longitudeController,
                                isRequired: true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                  signed: true,
                                ),
                                validator: (value) {
                                  final val = value?.trim() ?? '';
                                  if (val.isEmpty) {
                                    return 'Please enter longitude';
                                  }
                                  final lng = double.tryParse(val);
                                  if (lng == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (lng < -180 || lng > 180) {
                                    return 'Must be between -180 and 180';
                                  }
                                  return null;
                                },
                              ),
                              _buildCustomInputField(
                                context,
                                AppStrings.buildingNumber,
                                AppStrings.buildingNumberHint,
                                _buildingNoController,
                                isOptional: true,
                                keyboardType: TextInputType.text,
                              ),
                              _buildCustomInputField(
                                context,
                                AppStrings.area,
                                AppStrings.areaHint,
                                _areaController,
                                isRequired: true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                validator: (value) {
                                  final val = value?.trim() ?? '';
                                  if (val.isEmpty) {
                                    return 'Please enter area';
                                  }
                                  final area = double.tryParse(val);
                                  if (area == null || area <= 0) {
                                    return 'Please enter a valid area';
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          AppStrings.price,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.white,
                                              ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          '*',
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    PropertyInputFieldWidget(
                                      controller: _priceController,
                                      hint: AppStrings.priceHint,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      validator: (value) {
                                        final val = value?.trim() ?? '';
                                        if (val.isEmpty) {
                                          return 'Please enter price';
                                        }
                                        final price = double.tryParse(val);
                                        if (price == null || price <= 0) {
                                          return 'Please enter a valid price';
                                        }
                                        return null;
                                      },
                                      suffixIcon: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _selectedCurrency,
                                            dropdownColor: AppColors.background,
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: AppColors.white,
                                              size: 16,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                            items: _currencies.map((currency) {
                                              return DropdownMenuItem<String>(
                                                value: currency,
                                                child: Text(
                                                  currency,
                                                  style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedCurrency = value;
                                                });
                                                context
                                                    .read<CreatePropertyCubit>()
                                                    .priceCurrencyChanged(
                                                        value);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomCardField(
                                      context,
                                      AppStrings.rooms,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (_rooms > 1) {
                                                setState(() {
                                                  _rooms--;
                                                });
                                              }
                                            },
                                            icon: SvgPicture.asset(
                                              AppIcons.minus,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              '$_rooms',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors.white,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _rooms++;
                                              });
                                            },
                                            icon: SvgPicture.asset(
                                              AppIcons.plus,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCustomCardField(
                                      context,
                                      AppStrings.bathrooms,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (_bathrooms > 1) {
                                                setState(() {
                                                  _bathrooms--;
                                                });
                                              }
                                            },
                                            icon: SvgPicture.asset(
                                              AppIcons.minus,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              '$_bathrooms',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors.white,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _bathrooms++;
                                              });
                                            },
                                            icon: SvgPicture.asset(
                                              AppIcons.plus,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildCustomInputField(
                                context,
                                AppStrings.floor,
                                AppStrings.floorHint,
                                _floorController,
                                isOptional: true,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  final val = value?.trim() ?? '';
                                  if (val.isEmpty) {
                                    return null;
                                  }
                                  final floor = int.tryParse(val);
                                  if (floor == null || floor < 0) {
                                    return 'Please enter a valid floor number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SubmitButtonWidget(
                    onPressed: () {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.onUserInteraction;
                      });

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final floorText = _floorController.text.trim();
                      final floorNumber =
                          floorText.isNotEmpty ? int.tryParse(floorText) : null;

                      context
                          .read<CreatePropertyCubit>()
                          .priceCurrencyChanged(_selectedCurrency);
                      context.read<CreatePropertyCubit>().saveStep2(
                        city: _selectedCity ?? '',
                        district: _selectedDistrict ?? '',
                        latitude: _latitudeController.text.trim(),
                        longitude: _longitudeController.text.trim(),
                        buildingNumber: _buildingNoController.text.trim(),
                        floorNumber: floorNumber,
                        areaSqm: double.tryParse(_areaController.text.trim()),
                        price: double.tryParse(_priceController.text.trim()),
                        rooms: _rooms,
                        bathrooms: _bathrooms,
                      );
                    },
                  ),
                  const SizedBox(height: 33),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomInputField(
    BuildContext context,
    String title,
    String hint,
    TextEditingController controller, {
    String? icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isRequired = false,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[SvgPicture.asset(icon), const SizedBox(width: 8)],
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
              if (isOptional) ...[
                const SizedBox(width: 6),
                Text(
                  '(Optional)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white60,
                        fontSize: 12,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          PropertyInputFieldWidget(
            controller: controller,
            hint: hint,
            validator: validator,
            keyboardType: keyboardType,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCardField(
    BuildContext context,
    String title,
    Widget widget, {
    String? icon,
    bool isRequired = false,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[SvgPicture.asset(icon), const SizedBox(width: 8)],
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
              if (isOptional) ...[
                const SizedBox(width: 6),
                Text(
                  '(Optional)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white60,
                        fontSize: 12,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          CardWidget(widget: widget, isSelected: false, onTap: () {}),
        ],
      ),
    );
  }
}
