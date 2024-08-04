class ChatModel {
  final List<AiContact> contacts;

  ChatModel({required this.contacts});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      contacts:
          List<AiContact>.from(json['assistant_response']['contacts'].map((contact) => AiContact.fromJson(contact))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts.map((contact) => contact.toJson()).toList(),
    };
  }
}

class AiContact {
  final String name;
  final String phone;

  AiContact({required this.name, required this.phone});

  factory AiContact.fromJson(Map<String, dynamic> json) {
    return AiContact(
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}
