import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/owner_property_mangment/data/models/owner_property_list_item_model.dart';

void main() {
  group('OwnerPropertyListItemModel photos', () {
    test('uses the cover photo URL', () {
      final item = OwnerPropertyListItemModel.fromJson({
        'id': 'property-id',
        'photos': [
          {'is_cover': false, 'url': 'https://example.com/other.jpg'},
          {'is_cover': true, 'url': 'https://example.com/cover.jpg'},
        ],
      });

      expect(item.imageUrl, 'https://example.com/cover.jpg');
    });

    test('falls back to the first photo with a URL when no cover exists', () {
      final item = OwnerPropertyListItemModel.fromJson({
        'id': 'property-id',
        'photos': [
          {'is_cover': false, 'url': ''},
          {'is_cover': false, 'url': 'https://example.com/first.jpg'},
        ],
      });

      expect(item.imageUrl, 'https://example.com/first.jpg');
    });
  });
}
