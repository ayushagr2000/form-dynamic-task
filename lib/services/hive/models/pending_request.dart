import 'package:hive/hive.dart';

part 'pending_request.g.dart';

@HiveType(typeId: 0)
class PendingRequest {
  @HiveField(0)
  final DateTime createdAt;

  @HiveField(1)
  DateTime? completedAt;

  @HiveField(2)
  final bool processed;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final Map<String, dynamic> body;

  PendingRequest({
    required this.createdAt,
    this.completedAt,
    required this.processed,
    required this.url,
    required this.body,
  });
    Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'processed': processed,
      'url': url,
      'body': body,
    };
  }
}