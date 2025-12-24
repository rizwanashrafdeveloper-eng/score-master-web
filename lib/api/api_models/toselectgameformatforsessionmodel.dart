// toselectgameformatforsessionmodel.dart

class ToSelectGameFormatForSessionModel {
  int? id;
  String? name;
  String? description;
  String? mode;
  int? totalPhases;
  int? timeDuration;
  bool? isPublished;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdById;
  ToSelectGameFormatForSessionCreatedBy? createdBy;
  List<ToSelectGameFormatForSessionFacilitator>? facilitators;

  ToSelectGameFormatForSessionModel({
    this.id,
    this.name,
    this.description,
    this.mode,
    this.totalPhases,
    this.timeDuration,
    this.isPublished,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.createdById,
    this.createdBy,
    this.facilitators,
  });

  factory ToSelectGameFormatForSessionModel.fromJson(Map<String, dynamic> json) {
    return ToSelectGameFormatForSessionModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      mode: json['mode'] as String?,
      totalPhases: json['totalPhases'] as int?,
      timeDuration: json['timeDuration'] as int?,
      isPublished: json['isPublished'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      createdById: json['createdById'] as int?,
      createdBy: json['createdBy'] != null
          ? ToSelectGameFormatForSessionCreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>)
          : null,
      facilitators: json['facilitators'] != null
          ? List<ToSelectGameFormatForSessionFacilitator>.from(
        (json['facilitators'] as List).map(
              (x) => ToSelectGameFormatForSessionFacilitator.fromJson(x as Map<String, dynamic>),
        ),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'mode': mode,
      'totalPhases': totalPhases,
      'timeDuration': timeDuration,
      'isPublished': isPublished,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdById': createdById,
      'createdBy': createdBy?.toJson(),
      'facilitators': facilitators?.map((x) => x.toJson()).toList(),
    };
  }

  String get displayName => name?.trim().isNotEmpty == true ? name! : 'Unnamed Game';

  String get displayDescription => description?.trim().isNotEmpty == true
      ? description!
      : '${mode?.toUpperCase() ?? 'UNKNOWN'} • ${totalPhases ?? 0} Phase${totalPhases == 1 ? '' : 's'}';
}

class ToSelectGameFormatForSessionCreatedBy {
  int? id;
  String? email;
  String? name;
  String? password;
  String? language;
  String? phone;
  String? role;
  DateTime? createdAt;
  dynamic roleId;

  ToSelectGameFormatForSessionCreatedBy({
    this.id,
    this.email,
    this.name,
    this.password,
    this.language,
    this.phone,
    this.role,
    this.createdAt,
    this.roleId,
  });

  factory ToSelectGameFormatForSessionCreatedBy.fromJson(Map<String, dynamic> json) {
    return ToSelectGameFormatForSessionCreatedBy(
      id: json['id'] as int?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      language: json['language'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      roleId: json['roleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'language': language,
      'phone': phone,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'roleId': roleId,
    };
  }
}

class ToSelectGameFormatForSessionFacilitator {
  int? id;
  String? email;
  String? name;
  String? password;
  String? language;
  String? phone;
  String? role;
  DateTime? createdAt;
  int? roleId;

  ToSelectGameFormatForSessionFacilitator({
    this.id,
    this.email,
    this.name,
    this.password,
    this.language,
    this.phone,
    this.role,
    this.createdAt,
    this.roleId,
  });

  factory ToSelectGameFormatForSessionFacilitator.fromJson(Map<String, dynamic> json) {
    return ToSelectGameFormatForSessionFacilitator(
      id: json['id'] as int?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      language: json['language'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      roleId: json['roleId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'language': language,
      'phone': phone,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'roleId': roleId,
    };
  }
}