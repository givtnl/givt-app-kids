import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:givt_app_kids/features/recommendation/tags/models/tag.dart';

class Organisation extends Equatable {
  const Organisation({
    required this.guid,
    required this.collectGroupId,
    required this.name,
    required this.namespace,
    required this.qrCodeURL,
    required this.organisationLogoURL,
    required this.promoPictureUrl,
    required this.shortDescription,
    required this.longDescription,
    required this.tags,
  });

  final String guid;
  final String collectGroupId;
  final String name;
  final String namespace;
  final String qrCodeURL;
  final String organisationLogoURL;
  final String promoPictureUrl;
  final String shortDescription;
  final String longDescription;
  final List<Tag> tags;

  @override
  List<Object?> get props => [
        guid,
        collectGroupId,
        name,
        namespace,
        qrCodeURL,
        organisationLogoURL,
        promoPictureUrl,
        shortDescription,
        longDescription,
        tags,
      ];

  Organisation copyWith({
    String? guid,
    String? collectGroupId,
    String? name,
    String? namespace,
    String? qrCodeURL,
    String? organisationLogoURL,
    String? promoPictureUrl,
    String? shortDescription,
    String? longDescription,
    List<Tag>? tags,
  }) =>
      Organisation(
        guid: guid ?? this.guid,
        collectGroupId: collectGroupId ?? this.collectGroupId,
        name: name ?? this.name,
        namespace: namespace ?? this.namespace,
        qrCodeURL: qrCodeURL ?? this.qrCodeURL,
        organisationLogoURL: organisationLogoURL ?? this.organisationLogoURL,
        promoPictureUrl: promoPictureUrl ?? this.promoPictureUrl,
        shortDescription: shortDescription ?? this.shortDescription,
        longDescription: longDescription ?? this.longDescription,
        tags: tags ?? this.tags,
      );

  factory Organisation.fromMap(Map<String, dynamic> map) {
    return Organisation(
      guid: map['guid'],
      collectGroupId: map['collectGroupId'],
      name: map['name'],
      namespace: map['namespace'] ?? '',
      qrCodeURL: map['qrCodeURL'],
      organisationLogoURL: map['organisationLogoURL'],
      promoPictureUrl: map['promoPictureUrl'],
      shortDescription: map['shortDescription'],
      longDescription: map['longDescription'],
      tags: List<Tag>.from(map['tags'].map((map) => Tag.fromMap(map)).toList()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'collectGroupId': collectGroupId,
      'name': name,
      'namespace': namespace,
      'qrCodeURL': qrCodeURL,
      'organisationLogoURL': organisationLogoURL,
      'promoPictureUrl': promoPictureUrl,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'tags': jsonEncode(tags),
    };
  }
}
