class DocumentModel {
  final int id;
  final String name;
  final String category;
  final String url; // S3 Presigned URL
  final DateTime createdAt;

  DocumentModel({
    required this.id,
    required this.name,
    required this.category,
    required this.url,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Untitled',
      category: json['category'] ?? 'General',
      url: json['url'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}

class PaginationInfo {
  final int total;
  final int page;
  final int totalPages;

  PaginationInfo({
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
