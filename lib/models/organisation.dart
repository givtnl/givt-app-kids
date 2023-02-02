class Organisation {
  final String name;

  Organisation({
    required this.name,
  });

  Organisation.fromJson(Map<String, dynamic> json)
      : name = json["organisationName"];

  Map<String, dynamic> toJson() => {
        "organisationName": name,
      };
}
