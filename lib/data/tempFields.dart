late String itemNamex;
late String pricex;
late String purchaseDatex;
late String endDatex;
late String itemCategoryx;
late String durationx;

Future<void> modifyTextFields(
  String itemName,
  String price,
  String purchaseDate,
  String endDate,
  String itemCategory,
  String duration,
) async {
  itemNamex = itemName;
  pricex = price;
  purchaseDatex = purchaseDate;
  endDatex = endDate;
  itemCategoryx = itemCategory;
  durationx = duration;
  print(itemNamex);
}
