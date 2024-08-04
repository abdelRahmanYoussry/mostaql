class FilterParameters {
  late dynamic term;
  late dynamic categoryId;
  late dynamic stateId;
  FilterParameters({
    this.term,
    this.categoryId,
    this.stateId,
  });

  bool isAnyParameterEmpty() {
    return (categoryId == null || categoryId!.toString().isEmpty) &&
        (stateId == null || stateId!.toString().isEmpty) &&
        (term == null || term!.isEmpty);
  }

  void clearFilter() {
    categoryId = null;
    stateId = null;
  }
}
