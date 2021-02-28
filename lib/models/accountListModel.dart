class AccountList {
  String companyUrl;
  String email;
  String name;
  String password;
  String registrationId;
  String url;

  AccountList({
    this.companyUrl,
    this.email,
    this.name,
    this.password,
    this.registrationId,
    this.url,
  });

  factory AccountList.fromJson(Map<String, dynamic> json) {
    return AccountList(
      companyUrl: json['companyUrl'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      registrationId: json['registrationId'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'companyUrl': companyUrl,
        'password': password,
        'registrationId': registrationId,
        'url': url,
      };
}
