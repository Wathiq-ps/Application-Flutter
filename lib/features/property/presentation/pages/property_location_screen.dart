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
  final bool isEdit;
  const PropertyLocationScreen({super.key, this.isEdit = false});

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

  static const List<Map<String, String>> _cities = [
    {'value': 'Gaza', 'label': 'Gaza'},
    {'value': 'option2', 'label': 'Option 2'},
  ];

  static const List<Map<String, String>> _districts = [
    {'value': 'Al-Wehda', 'label': 'Al-Wehda'},
    {'value': 'option2', 'label': 'Option 2'},
  ];

  int _rooms = 0;
  int _bathrooms = 0;

  String? _selectedPriceUnit;
  String? _priceUnitError;
  static const List<Map<String, String>> _priceUnits = [
    {'value': 'per_hour', 'label': 'Per Hour'},
    {'value': 'per_week', 'label': 'Weekly'},
    {'value': 'per_month', 'label': 'Per Month'},
    {'value': 'per_year', 'label': 'Per Year'},
  ];

  String _selectedCurrency = 'JOD';
  static const List<String> _currencies = ['JOD', 'USD', 'ILS'];

  @override
  void initState() {
    super.initState();
    final state = context.read<CreatePropertyCubit>().state;

    if (state.latitude.isNotEmpty) _latitudeController.text = state.latitude;
    if (state.longitude.isNotEmpty) {
      _longitudeController.text = state.longitude;
    }
    if (state.buildingNumber.isNotEmpty) {
      _buildingNoController.text = state.buildingNumber;
    }
    if (state.areaSqm != null && state.areaSqm! > 0) {
      _areaController.text = state.areaSqm! % 1 == 0
          ? state.areaSqm!.toInt().toString()
          : state.areaSqm!.toString();
    }
    if (state.price != null && state.price! > 0) {
      _priceController.text = state.price! % 1 == 0
          ? state.price!.toInt().toString()
          : state.price!.toString();
    }
    if (state.floorNumber != null) {
      _floorController.text = state.floorNumber.toString();
    }

    if (state.city.isNotEmpty) _selectedCity = state.city;
    if (state.district.isNotEmpty) _selectedDistrict = state.district;
    if (state.rooms != null) _rooms = state.rooms!;
    if (state.bathrooms != null) _bathrooms = state.bathrooms!;
    if (state.priceUnit.isNotEmpty) _selectedPriceUnit = state.priceUnit;

    if (state.priceCurrency.isNotEmpty &&
        _currencies.contains(state.priceCurrency)) {
      _selectedCurrency = state.priceCurrency;
    } else {
      context.read<CreatePropertyCubit>().priceCurrencyChanged(
        _selectedCurrency,
      );
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
    final isRent = context.select<CreatePropertyCubit, bool>(
      (cubit) => cubit.state.listingType.toLowerCase() == 'rent',
    );

    final cityItems = [
      ..._cities,
      if (_selectedCity != null &&
          _selectedCity!.isNotEmpty &&
          !_cities.any((c) => c['value'] == _selectedCity))
        {'value': _selectedCity!, 'label': _selectedCity!},
    ];

    final districtItems = [
      ..._districts,
      if (_selectedDistrict != null &&
          _selectedDistrict!.isNotEmpty &&
          !_districts.any((d) => d['value'] == _selectedDistrict))
        {'value': _selectedDistrict!, 'label': _selectedDistrict!},
    ];

    final priceUnitItems = [
      ..._priceUnits,
      if (_selectedPriceUnit != null &&
          _selectedPriceUnit!.isNotEmpty &&
          !_priceUnits.any((u) => u['value'] == _selectedPriceUnit))
        {'value': _selectedPriceUnit!, 'label': _selectedPriceUnit!},
    ];

    return BlocListener<CreatePropertyCubit, CreatePropertyState>(
      listener: (context, state) {
        if (state.status == CreatePropertyStatus.step2Saved) {
          if (widget.isEdit) {
            context.pop();
          } else {
            context.push(RouteNames.listPropertyFeaturesScreen);
          }
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
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            value: _selectedCity,
                                            dropdownColor:
                                                AppColors.background,
                                            isExpanded: true,
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
                                            selectedItemBuilder:
                                                (BuildContext context) {
                                              return cityItems.map<Widget>((
                                                city,
                                              ) {
                                                return Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    city['label']!,
                                                    style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              }).toList();
                                            },
                                            items: cityItems.map((city) {
                                              return DropdownMenuItem<String>(
                                                value: city['value'],
                                                child: Text(
                                                  city['label']!,
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedCity = value;
                                                });
                                              }
                                            },
                                          ),
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
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            value: _selectedDistrict,
                                            dropdownColor:
                                                AppColors.background,
                                            isExpanded: true,
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
                                            selectedItemBuilder:
                                                (BuildContext context) {
                                              return districtItems.map<Widget>((
                                                district,
                                              ) {
                                                return Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    district['label']!,
                                                    style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              }).toList();
                                            },
                                            items: districtItems.map((
                                              district,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: district['value'],
                                                child: Text(
                                                  district['label']!,
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  _selectedDistrict = value;
                                                });
                                              }
                                            },
                                          ),
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
                                          horizontal: 14,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),

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
                                            selectedItemBuilder: (BuildContext context) {
                                              return _currencies.map<Widget>((currency) {
                                                return Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    currency,
                                                    style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              }).toList();
                                            },
                                            items: _currencies.map((currency) {
                                              return DropdownMenuItem<String>(
                                                value: currency,

                                                child: Text(
                                                  currency,
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
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
                                                      value,
                                                    );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (isRent) ...[
                                _buildCustomCardField(
                                  context,
                                  AppStrings.priceUnit,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        borderRadius: BorderRadius.circular(12),
                                        value: _selectedPriceUnit,
                                        dropdownColor: AppColors.background,
                                        isExpanded: true,
                                        hint: Text(
                                          AppStrings.selectPriceUnit,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.white60,
                                                fontSize: 14,
                                              ),
                                        ),
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
                                        selectedItemBuilder:
                                            (BuildContext context) {
                                          return priceUnitItems.map<Widget>((
                                            unit,
                                          ) {
                                            return Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                unit['label']!,
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        items: priceUnitItems.map((unit) {
                                          return DropdownMenuItem<String>(
                                            value: unit['value'],
                                            child: Text(
                                              unit['label']!,
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedPriceUnit = value;
                                              _priceUnitError = null;
                                            });
                                            context
                                                .read<CreatePropertyCubit>()
                                                .priceUnitChanged(value);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  isRequired: true,
                                  errorMessage: _priceUnitError,
                                ),
                              ],

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
                                              if (_rooms > 0) {
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
                                              if (_bathrooms > 0) {
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
                    text: widget.isEdit
                        ? AppStrings.saveChanges
                        : AppStrings.continueText,
                    onPressed: () {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.onUserInteraction;
                      });

                      final isRent = context
                              .read<CreatePropertyCubit>()
                              .state
                              .listingType
                              .toLowerCase() ==
                          'rent';

                      if (isRent &&
                          (_selectedPriceUnit == null ||
                              _selectedPriceUnit!.isEmpty)) {
                        setState(() {
                          _priceUnitError = AppStrings.pleaseSelectPriceUnit;
                        });
                      }

                      if (!_formKey.currentState!.validate() ||
                          (isRent &&
                              (_selectedPriceUnit == null ||
                                  _selectedPriceUnit!.isEmpty))) {
                        return;
                      }

                      final floorText = _floorController.text.trim();
                      final floorNumber = floorText.isNotEmpty
                          ? int.tryParse(floorText)
                          : null;

                      context.read<CreatePropertyCubit>().priceCurrencyChanged(
                        _selectedCurrency,
                      );
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
                        priceCurrency: _selectedCurrency,
                        priceUnit: isRent ? _selectedPriceUnit : null,
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
              if (icon != null) ...[
                SvgPicture.asset(icon),
                const SizedBox(width: 8),
              ],
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
    String? errorMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                SvgPicture.asset(icon),
                const SizedBox(width: 8),
              ],
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
          if (errorMessage != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
