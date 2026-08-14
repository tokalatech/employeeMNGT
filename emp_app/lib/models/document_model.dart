enum EmployeeDocumentCategory {
  myDocuments,
  companyPolicies,
  payslips,
  certificates,
}

enum EmployeeDocumentFileType {
  pdf,
  docx,
  jpg,
  png,
}

class EmployeeDocument {
  final String id;
  final String name;
  final EmployeeDocumentCategory category;
  final String dateAdded;
  final EmployeeDocumentFileType fileType;
  final String fileSize;
  final String? url;

  EmployeeDocument({
    required this.id,
    required this.name,
    required this.category,
    required this.dateAdded,
    required this.fileType,
    required this.fileSize,
    this.url,
  });

  factory EmployeeDocument.fromMap(Map<String, dynamic> map) {
    return EmployeeDocument(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: documentCategoryFromString(map['category']),
      dateAdded: map['dateAdded'] ?? '',
      fileType: documentFileTypeFromString(map['fileType']),
      fileSize: map['fileSize'] ?? '',
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': documentCategoryToString(category),
      'dateAdded': dateAdded,
      'fileType': documentFileTypeToString(fileType),
      'fileSize': fileSize,
      'url': url,
    };
  }
}

EmployeeDocumentCategory documentCategoryFromString(String? value) {
  switch (value) {
    case 'Company Policies':
      return EmployeeDocumentCategory.companyPolicies;
    case 'Payslips':
      return EmployeeDocumentCategory.payslips;
    case 'Certificates':
      return EmployeeDocumentCategory.certificates;
    default:
      return EmployeeDocumentCategory.myDocuments;
  }
}

String documentCategoryToString(EmployeeDocumentCategory value) {
  switch (value) {
    case EmployeeDocumentCategory.myDocuments:
      return 'My Documents';
    case EmployeeDocumentCategory.companyPolicies:
      return 'Company Policies';
    case EmployeeDocumentCategory.payslips:
      return 'Payslips';
    case EmployeeDocumentCategory.certificates:
      return 'Certificates';
  }
}

EmployeeDocumentFileType documentFileTypeFromString(String? value) {
  switch (value) {
    case 'DOCX':
      return EmployeeDocumentFileType.docx;
    case 'JPG':
      return EmployeeDocumentFileType.jpg;
    case 'PNG':
      return EmployeeDocumentFileType.png;
    default:
      return EmployeeDocumentFileType.pdf;
  }
}

String documentFileTypeToString(EmployeeDocumentFileType value) {
  switch (value) {
    case EmployeeDocumentFileType.pdf:
      return 'PDF';
    case EmployeeDocumentFileType.docx:
      return 'DOCX';
    case EmployeeDocumentFileType.jpg:
      return 'JPG';
    case EmployeeDocumentFileType.png:
      return 'PNG';
  }
}