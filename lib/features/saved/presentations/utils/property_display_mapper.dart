import 'package:mobile/core/utils/price_formatter.dart';
import 'package:mobile/features/owner_property_mangment/domain/entities/owner_property_list_item.dart';
import 'package:mobile/features/owner_property_mangment/domain/entities/property_status.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';


OwnerPropertyListItem toDisplayItem(PropertyEntity property) {
  final capitalizedType = property.type.isEmpty
      ? property.type
      : '${property.type[0].toUpperCase()}${property.type.substring(1)}';

  return OwnerPropertyListItem(
    id: property.id,
    title: '$capitalizedType — ${_roomsLabel(property.rooms)}',
    location: property.locationLabel,
    imageUrl: property.coverPhoto,
    rooms: property.rooms,
    bathrooms: property.bathrooms,
    areaSqm: property.areaSqm.round(),
    price: PriceFormatter.displayWithCode(
      price: property.price,
      currency: property.priceCurrency,
    ),
    priceUnit: '',
    pricePeriod: _periodSuffix(property.priceUnit),
    // Unused: the Saved screen always passes showStatus: false.
    status: PropertyStatus.active,
  );
}

String _roomsLabel(int rooms) => rooms == 1 ? '1 room' : '$rooms rooms';

String _periodSuffix(String? unit) => switch (unit) {
  'per_hour' => ' / hr',
  'per_day' => ' / day',
  'per_week' => ' / week',
  'per_month' => ' / month',
  'per_year' => ' / year',
  _ => '',
};