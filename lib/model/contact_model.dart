class ContactResponse {
  bool? status;
  List<Contact>? data;
  Pagination? pagination;

  ContactResponse({this.status, this.data, this.pagination});

  ContactResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Contact>[];
      json['data'].forEach((v) {
        data!.add(Contact.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }
}

class Contact {
  int? id;
  String? userRole;
  String? name;
  String? email;
  String? phoneNo;

  Contact({this.id, this.userRole, this.name, this.email, this.phoneNo});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userRole = json['user_role'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phone_no'];
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  bool? hasMore;

  Pagination({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.hasMore,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    hasMore = json['has_more'];
  }
}
