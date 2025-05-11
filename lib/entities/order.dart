class Order {
  final String id;
  final List<String> productIds;
  final double total;

  Order({
    required this.id,
    required this.productIds,
    required this.total,
  });
}
