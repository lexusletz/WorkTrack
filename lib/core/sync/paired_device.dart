import 'dart:convert';

class PairedDevice {
  const PairedDevice({
    required this.id,
    required this.name,
    required this.pairedAt,
    this.lastSyncAt,
  });

  final String id;
  final String name;
  final DateTime pairedAt;
  final DateTime? lastSyncAt;

  PairedDevice copyWith({DateTime? lastSyncAt}) => PairedDevice(
    id: id,
    name: name,
    pairedAt: pairedAt,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'pairedAt': pairedAt.millisecondsSinceEpoch,
    'lastSyncAt': lastSyncAt?.millisecondsSinceEpoch,
  };

  factory PairedDevice.fromJson(Map<String, dynamic> json) => PairedDevice(
    id: json['id'] as String,
    name: json['name'] as String,
    pairedAt: DateTime.fromMillisecondsSinceEpoch(json['pairedAt'] as int),
    lastSyncAt: json['lastSyncAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['lastSyncAt'] as int)
        : null,
  );

  static List<PairedDevice> listFromJson(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => PairedDevice.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJson(List<PairedDevice> devices) =>
      jsonEncode(devices.map((d) => d.toJson()).toList());
}
