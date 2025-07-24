import 'package:equatable/equatable.dart';

enum UserType { client, provider }

class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    required this.userType,
    required this.isEmailVerified,
    this.isPhoneVerified = false,
    this.isNewUser = false,
  });

  final String uid;
  final String email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  final UserType userType;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isNewUser;

  bool get isFullyVerified => isEmailVerified && (phoneNumber == null || isPhoneVerified);

  AuthUser copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoURL,
    UserType? userType,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isNewUser,
  }) {
    return AuthUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      userType: userType ?? this.userType,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'userType': userType.name,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'isNewUser': isNewUser,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.client,
      ),
      isEmailVerified: json['isEmailVerified'] as bool,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isNewUser: json['isNewUser'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        phoneNumber,
        displayName,
        photoURL,
        userType,
        isEmailVerified,
        isPhoneVerified,
        isNewUser,
      ];
}
