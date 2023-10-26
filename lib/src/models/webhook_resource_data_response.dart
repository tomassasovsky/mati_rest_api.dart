// ignore_for_file: public_member_api_docs

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mati_rest_api/mati_rest_api.dart';
import 'package:recase/recase.dart';

class MatiWebhookResourceData extends MatiResponse with EquatableMixin {
  const MatiWebhookResourceData({
    required this.expired,
    required this.deviceFingerprint,
    required this.identity,
    required this.steps,
    required this.documents,
    required this.computed,
    required this.id,
    required this.hasProblem,
  });

  factory MatiWebhookResourceData.fromMap(Map<dynamic, dynamic> json) =>
      MatiWebhookResourceData(
        expired: json['expired'] as bool? ?? true,
        deviceFingerprint: json['deviceFingerprint'] == null
            ? null
            : DeviceFingerprint.fromMap(json['deviceFingerprint'] as Map),
        identity: json['identity'] == null
            ? null
            : Identity.fromMap(json['identity'] as Map),
        steps: json['steps'] == null
            ? null
            : List<MatiWebhookResourceDataStep>.from(
                (json['steps'] as List)
                    .cast<Map<dynamic, dynamic>>()
                    .map(MatiWebhookResourceDataStep.fromMap),
              ),
        documents: json['documents'] == null
            ? null
            : List<Document>.from(
                (json['documents'] as List)
                    .cast<Map<dynamic, dynamic>>()
                    .map(Document.fromMap),
              ),
        hasProblem: json['hasProblem'] as bool? ?? true,
        computed: json['computed'] == null
            ? null
            : Computed.fromMap(json['computed'] as Map),
        id: json['id'] as String?,
      );

  final bool expired;
  final DeviceFingerprint? deviceFingerprint;
  final Identity? identity;
  final List<MatiWebhookResourceDataStep>? steps;
  final List<Document>? documents;
  final bool hasProblem;
  final Computed? computed;
  final String? id;

  String? get capitalizedName {
    final value = documents
        ?.firstWhereOrNull((element) => element.fields?.fullName?.value != null)
        ?.fields
        ?.fullName
        ?.value;

    if (value == null || value.isEmpty) return null;

    return ReCase(value).titleCase;
  }

  bool get verified =>
      (steps?.every((step) => step.status == 200) ?? false) &&
      !hasProblem &&
      !expired &&
      identity?.status == 'verified';

  @override
  List<Object?> get props {
    return [
      expired,
      deviceFingerprint,
      identity,
      steps,
      documents,
      hasProblem,
      computed,
      id,
    ];
  }
}

class Computed extends Equatable {
  const Computed({
    required this.age,
    required this.isDocumentExpired,
  });

  factory Computed.fromMap(Map<dynamic, dynamic> json) => Computed(
        age: json['age'] == null ? null : Age.fromMap(json['age'] as Map),
        isDocumentExpired: json['isDocumentExpired'] == null
            ? null
            : IsDocumentExpired.fromMap(json['isDocumentExpired'] as Map),
      );

  final Age? age;
  final IsDocumentExpired? isDocumentExpired;

  @override
  List<Object?> get props => [age, isDocumentExpired];
}

class Age extends Equatable {
  const Age({
    required this.data,
  });

  factory Age.fromMap(Map<dynamic, dynamic> json) => Age(
        data: json['data'] as int?,
      );

  final int? data;

  @override
  List<Object?> get props => [data];
}

class IsDocumentExpired extends Equatable {
  const IsDocumentExpired({
    required this.data,
  });

  factory IsDocumentExpired.fromMap(Map<dynamic, dynamic> json) =>
      IsDocumentExpired(
        data: json['data'] == null
            ? null
            : IsDocumentExpiredData.fromMap(json['data'] as Map),
      );

  final IsDocumentExpiredData? data;

  @override
  List<Object?> get props => [data];
}

class IsDocumentExpiredData extends Equatable {
  const IsDocumentExpiredData({
    this.nationalId,
    this.passport,
    this.proofOfResidency,
  });

  factory IsDocumentExpiredData.fromMap(Map<dynamic, dynamic> json) =>
      IsDocumentExpiredData(
        nationalId: json['national-id'] as bool?,
        passport: json['passport'] as bool?,
        proofOfResidency: json['proof-of-residency'] as String?,
      );

  final bool? nationalId;
  final bool? passport;
  final String? proofOfResidency;

  @override
  List<Object?> get props => [nationalId, passport, proofOfResidency];
}

class DeviceFingerprint extends Equatable {
  const DeviceFingerprint({
    required this.ua,
    required this.browser,
    required this.engine,
    required this.os,
    required this.device,
  });

  factory DeviceFingerprint.fromMap(Map<dynamic, dynamic> json) =>
      DeviceFingerprint(
        ua: json['ua'] == null ? null : json['ua'] as String,
        browser: json['browser'] == null
            ? null
            : Browser.fromMap(json['browser'] as Map),
        engine: json['engine'] == null
            ? null
            : Engine.fromMap(json['engine'] as Map),
        os: json['os'] == null ? null : Engine.fromMap(json['os'] as Map),
        device: json['device'] == null
            ? null
            : Device.fromMap(json['device'] as Map),
      );

  final String? ua;
  final Browser? browser;
  final Engine? engine;
  final Engine? os;
  final Device? device;

  @override
  List<Object?> get props {
    return [
      ua,
      browser,
      engine,
      os,
      device,
    ];
  }
}

class Browser extends Equatable {
  const Browser({
    this.name,
    this.version,
    this.major,
  });

  factory Browser.fromMap(Map<dynamic, dynamic> json) => Browser(
        name: json['name'] as String?,
        version: json['version'] as String?,
        major: json['major'] as String?,
      );

  final String? name;
  final String? version;
  final String? major;

  @override
  List<Object?> get props => [name, version, major];
}

class Device extends Equatable {
  const Device({
    this.vendor,
    this.model,
    this.type,
  });

  factory Device.fromMap(Map<dynamic, dynamic> json) => Device(
        vendor: json['vendor'] as String?,
        model: json['model'] as String?,
        type: json['type'] as String?,
      );

  final String? vendor;
  final String? model;
  final String? type;

  @override
  List<Object?> get props => [vendor, model, type];
}

class Engine extends Equatable {
  const Engine({
    this.name,
    this.version,
  });

  factory Engine.fromMap(Map<dynamic, dynamic> json) => Engine(
        name: json['name'] as String?,
        version: json['version'] as String?,
      );

  final String? name;
  final String? version;

  @override
  List<Object?> get props => [name, version];
}

class Document extends Equatable {
  const Document({
    this.country,
    this.type,
    this.steps,
    this.fields,
    this.photos,
  });

  factory Document.fromMap(Map<dynamic, dynamic> json) => Document(
        country: json['country'] as String?,
        type: json['type'] as String?,
        steps: json['steps'] == null
            ? null
            : List<DocumentStep>.from(
                (json['steps'] as List)
                    .cast<Map<dynamic, dynamic>>()
                    .map(DocumentStep.fromMap),
              ),
        fields: json['fields'] == null
            ? null
            : Fields.fromMap(json['fields'] as Map),
        photos: (json['photos'] as List?)?.cast<String>(),
      );

  final String? country;
  final String? type;
  final List<DocumentStep>? steps;
  final Fields? fields;
  final List<String>? photos;

  @override
  List<Object?> get props {
    return [
      country,
      type,
      steps,
      fields,
      photos,
    ];
  }
}

class Fields extends Equatable {
  const Fields({
    this.fullName,
    this.address,
    this.documentNumber,
    this.dateOfBirth,
    this.expirationDate,
    this.cde,
    this.curp,
    this.ne,
    this.ocrNumber,
    this.surname,
    this.firstName,
    this.sex,
  });

  factory Fields.fromMap(Map<dynamic, dynamic> json) {
    DocumentField? parseField(String key) {
      final value = json[key];
      if (value == null || value is! Map) return null;

      return DocumentField.fromMap(value);
    }

    return Fields(
      fullName: parseField('fullName'),
      address: parseField('address'),
      documentNumber: parseField('documentNumber'),
      dateOfBirth: parseField('dateOfBirth'),
      expirationDate: parseField('expirationDate'),
      cde: parseField('cde'),
      curp: parseField('curp'),
      ne: parseField('ne'),
      ocrNumber: parseField('ocrNumber'),
      surname: parseField('surname'),
      firstName: parseField('firstName'),
      sex: parseField('sex'),
    );
  }

  final DocumentField? fullName;
  final DocumentField? address;
  final DocumentField? documentNumber;
  final DocumentField? dateOfBirth;
  final DocumentField? expirationDate;
  final DocumentField? cde;
  final DocumentField? curp;
  final DocumentField? ne;
  final DocumentField? ocrNumber;
  final DocumentField? surname;
  final DocumentField? firstName;
  final DocumentField? sex;

  @override
  List<Object?> get props {
    return [
      fullName,
      address,
      documentNumber,
      dateOfBirth,
      expirationDate,
      cde,
      curp,
      ne,
      ocrNumber,
      surname,
      firstName,
      sex,
    ];
  }
}

class DocumentField extends Equatable {
  const DocumentField({
    this.value,
    this.label,
    this.format,
  });

  factory DocumentField.fromMap(Map<dynamic, dynamic> json) => DocumentField(
        value: json['value'] as String?,
        label: json['label'] as String?,
        format: json['format'] as String?,
      );

  final String? value;
  final String? label;
  final String? format;

  @override
  List<Object?> get props => [value, label, format];
}

class DocumentStep extends Equatable {
  const DocumentStep({
    this.status,
    this.id,
    this.error,
    this.data,
  });

  factory DocumentStep.fromMap(Map<dynamic, dynamic> json) => DocumentStep(
        status: json['status'] as int?,
        id: json['id'] as String?,
        error: json['error'] == null
            ? null
            : MatiError.fromMap(json['error'] as Map),
        data: json['data'] == null ? null : Fields.fromMap(json['data'] as Map),
      );

  final int? status;
  final String? id;
  final MatiError? error;
  final Fields? data;

  @override
  List<Object?> get props => [status, id, error, data];
}

class MatiError extends Equatable {
  const MatiError({
    this.type,
    this.code,
    this.message,
  });

  factory MatiError.fromMap(Map<dynamic, dynamic> json) => MatiError(
        type: json['type'] as String?,
        code: json['code'] as String?,
        message: json['message'] as String?,
      );

  final String? type;
  final String? code;
  final String? message;

  @override
  List<Object?> get props => [type, code, message];
}

class Identity extends Equatable {
  const Identity({
    this.status,
  });

  factory Identity.fromMap(Map<dynamic, dynamic> json) => Identity(
        status: json['status'] as String?,
      );

  final String? status;

  @override
  List<Object?> get props => [status];
}

class MatiWebhookResourceDataStep extends Equatable {
  const MatiWebhookResourceDataStep({
    this.status,
    this.id,
    this.data,
    this.error,
  });

  factory MatiWebhookResourceDataStep.fromMap(Map<dynamic, dynamic> json) =>
      MatiWebhookResourceDataStep(
        status: json['status'] as int?,
        id: json['id'] as String?,
        data:
            json['data'] == null ? null : StepData.fromMap(json['data'] as Map),
        error: json['error'] == null
            ? null
            : MatiError.fromMap(json['error'] as Map),
      );

  final int? status;
  final String? id;
  final StepData? data;
  final MatiError? error;

  @override
  List<Object?> get props => [status, id, data, error];
}

class StepData extends Equatable {
  const StepData({
    this.selfieUrl,
    this.country,
    this.countryCode,
    this.region,
    this.regionCode,
    this.city,
    this.zip,
    this.latitude,
    this.longitude,
    this.safe,
  });

  factory StepData.fromMap(Map<dynamic, dynamic> json) => StepData(
        selfieUrl: json['selfieUrl'] as String?,
        country: json['country'] as String?,
        countryCode: json['countryCode'] as String?,
        region: json['region'] as String?,
        regionCode: json['regionCode'] as String?,
        city: json['city'] as String?,
        zip: json['zip'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        safe: json['safe'] as bool?,
      );

  final String? selfieUrl;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionCode;
  final String? city;
  final String? zip;
  final double? latitude;
  final double? longitude;
  final bool? safe;

  @override
  List<Object?> get props {
    return [
      selfieUrl,
      country,
      countryCode,
      region,
      regionCode,
      city,
      zip,
      latitude,
      longitude,
      safe,
    ];
  }
}
