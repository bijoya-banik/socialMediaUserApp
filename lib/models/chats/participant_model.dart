import 'package:meta/meta.dart';

class ParticipateModel {
  final dynamic userId;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? profilePic;

  const ParticipateModel({
    @required this.userId,
    @required this.firstName,
    @required this.lastName,
    @required this.userName,
    @required this.profilePic,
  });
}
