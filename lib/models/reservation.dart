class Reservation {
  final int id;
  final Attributes attributes;

  Reservation({
    required this.id,
    required this.attributes,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      attributes: Attributes.fromJson(json['attributes']),
    );
  }
}

class Attributes {
  final String title;
  final String start;
  final String end;
  final bool isSemester;
  final String status;
  final String color;
  final String? reasonForDisapproved;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;

  Attributes({
    required this.title,
    required this.start,
    required this.end,
    required this.isSemester,
    required this.status,
    required this.color,
    this.reasonForDisapproved,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      title: json['title'],
      start: json['start'],
      end: json['end'],
      isSemester: json['isSemester'],
      status: json['status'],
      color: json['color'],
      reasonForDisapproved: json['reasonForDisapproved'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
    );
  }
}

class Meta {
  final Pagination pagination;

  Meta({required this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      total: json['total'],
    );
  }
}

class ReservationResponse {
  final List<Reservation> data;
  final Meta meta;

  ReservationResponse({required this.data, required this.meta});

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Reservation> dataList =
        list.map((i) => Reservation.fromJson(i)).toList();
    return ReservationResponse(
      data: dataList,
      meta: Meta.fromJson(json['meta']),
    );
  }
}
