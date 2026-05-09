/// Auth feature route segments and names. Keeps navigation constants inside the feature.
enum ProductRoute {
  product,
  productDetail;

  String get path => switch (this) {
    ProductRoute.product => '/',
    ProductRoute.productDetail => '/:id',
  };

  String get routeName => switch (this) {
    ProductRoute.product => 'Product',
    ProductRoute.productDetail => 'ProductDetail',
  };
}
