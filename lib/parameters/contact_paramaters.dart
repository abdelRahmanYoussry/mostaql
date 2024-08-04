class ContactParameters {
  int? id;
  late String? name;
  late String? email;
  late String? phone;
  late String? job;
  late String? tags;
  late String? address;
  late String? notes;
  late String? gender;
  late String? phoneCode;
  late int? placeOfBirth;
  late int? placeOfWork;
  ContactParameters({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.job,
    this.tags,
    this.address,
    this.notes,
    this.gender,
    this.placeOfBirth,
    this.placeOfWork,
    this.phoneCode,
  });
  void clear() {
    id = null;
    name = null;
    email = null;
    phone = null;
    job = null;
    tags = null;
    address = null;
    notes = null;
    gender = null;
    phoneCode = null;
    placeOfBirth = null;
    placeOfWork = null;
  }
}
