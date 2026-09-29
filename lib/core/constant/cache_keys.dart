class CacheKeys {
  CacheKeys._();

  static const home = 'home';

  static String favourites(String userId) => 'favourites:$userId';
  static String ownerProperties(String userId) => 'owner_properties:$userId';
  static String propertyDetails(String id) => 'property:$id';
  static String search(String? listingType) => 'search:${listingType ?? 'all'}';
}