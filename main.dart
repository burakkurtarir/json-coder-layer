import 'dart:convert';

void main(List<String> args) {
  // Test variables
  List<Map<String, dynamic>> userJsonList = [
    {"firstName": "Sherlock", "lastName": "Holmes"},
    {"firstName": "John", "lastName": "Watson"},
  ];
  Map<String, dynamic> userJson = {
    "firstName": "Sherlock",
    "lastName": "Holmes"
  };

  // Decode and Encode UserModel
  final user =
      JSONDecoder().decode<UserModel, UserModel>(userJson, UserModel());
  userJson = JSONEncoder().encode<UserModel>(user);
  print(user.toString());
  print(userJson);
  print("****************");

  // Decode and Encode List<UserModel>
  final userList = JSONDecoder()
      .decode<List<UserModel>, UserModel>(userJsonList, UserModel());
  userJsonList = JSONEncoder().encode<UserModel>(userList);
  print(userList?.toString());
  print(userJsonList);
  print("****************");
}

class UserModel implements Codable<UserModel> {
  UserModel({this.firstName, this.lastName});

  final String? firstName;
  final String? lastName;

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"] as String?,
      lastName: json["lastName"] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
    };
  }

  @override
  String toString() {
    return "$firstName - $lastName";
  }
}

class JSONDecoder {
  /// [R] is result type that we expect
  /// [T] is [Decodable] type to decode json data
  /// And we need [model] paramater to call fromJson function
  R? decode<R, T extends Decodable<T>>(dynamic data, T model) {
    if (data is List) {
      return data.map((e) => model.fromJson(e)).cast<T>().toList() as R;
    } else if (data is Map<String, dynamic>) {
      return model.fromJson(data) as R;
    } else {
      return null;
    }
  }
}

class JSONEncoder {
  /// [T] is [Encodable] type to encode data
  dynamic encode<T extends Encodable<T>>(dynamic data) {
    if (data is List<T>) {
      return data.map((e) => e.toJson()).toList();
    } else if (data is T) {
      return data.toJson();
    } else if (data != null) {
      return jsonEncode(data);
    } else {
      return null;
    }
  }
}

mixin Decodable<T> {
  T fromJson(Map<String, dynamic> json);
}

mixin Encodable<T> {
  Map<String, dynamic> toJson();
}

abstract class Codable<T> with Decodable<T>, Encodable<T> {
  @override
  T fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson();
}
