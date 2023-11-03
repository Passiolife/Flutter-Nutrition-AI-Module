import 'package:json_annotation/json_annotation.dart';

part 'sign_in_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SignInResponse {
  SignInResponse({
    this.email,
    this.photoURL,
    this.uid,
    this.displayName,
  });

  String? email;
  String? photoURL;
  String? uid;
  String? displayName;

  factory SignInResponse.fromJson(Map<String, dynamic> json) => _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}
