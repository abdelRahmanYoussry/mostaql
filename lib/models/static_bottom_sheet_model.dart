class BottomSheetModel {
  final String place;
  late bool isSelected;

  BottomSheetModel(this.place, this.isSelected);
}

// todo remove  static data when integration with apis
// static data for placeOfWork and PlaceOfBirth in egypt and SA
final List<BottomSheetModel> staticPlaceOfWorkDataList = [
  BottomSheetModel('المرور', false),
  BottomSheetModel('التأمينات', false),
  BottomSheetModel('شركه الكهرباء', false),
  BottomSheetModel('شركه المياه', false),
  BottomSheetModel('وزاره التربية والتعليم', false),
  BottomSheetModel('وزاره الصحة', false),
  BottomSheetModel('قسم الدقى', false),
  BottomSheetModel('قسم منتزة اول', false),
];
final List<BottomSheetModel> staticEgyptPlaceOfBirthStaticList = [
  BottomSheetModel('مدينة نصر', false),
  BottomSheetModel('الهرم', false),
  BottomSheetModel('الدقى', false),
  BottomSheetModel('مدينتى ', false),
  BottomSheetModel('العبور', false),
];
final List<BottomSheetModel> staticSaudiArabiaPlaceOfBirthStaticList = [
  BottomSheetModel('الدمام', false),
  BottomSheetModel('القصيم', false),
  BottomSheetModel('مكة', false),
  BottomSheetModel('المدينة ', false),
  BottomSheetModel('الباحة', false),
];

//todo remove  static data when integration with apis
final List<BottomSheetModel> staticCategoriesDataList = [
  BottomSheetModel('المرور', false),
  BottomSheetModel('التأمينات', false),
  BottomSheetModel('الشرطة', false),
  BottomSheetModel('الضرايب', false),
];

final List<BottomSheetModel> staticCountryStaticList = [
  BottomSheetModel('مصر', false),
  BottomSheetModel('الأمارات', false),
  BottomSheetModel('السعودية ', false),
];
