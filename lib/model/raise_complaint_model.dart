class RaiseComplaintModel {
  final int? id;
  final String categoryName;
  final String? serviceRequired;
  final String? problem;
  final String? priorityLevel;
  final DateTime? date;
  final String tickectid;
  final String otp;
  final String? imageUrl;
  final String? audioUrl;
  final String? complaintStatus;
  final String? technicianName;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerLocation;
  final String? customerPlace;
  final String? customerHotelName;
  final String? techstatus;

  RaiseComplaintModel({
    this.id,
    required this.categoryName,
    this.serviceRequired,
    this.problem,
    this.priorityLevel,
    this.date,
    required this.tickectid,
    required this.otp,
    this.imageUrl,
    this.audioUrl,
    this.complaintStatus,
    this.technicianName,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerLocation,
    this.customerPlace,
    this.customerHotelName,
    this.techstatus,
  });

  factory RaiseComplaintModel.fromMap(Map<String, dynamic> map) {

  String? technicianName;
  final techList = map['complaint_technicians'];
  if (techList is List && techList.isNotEmpty) {
    technicianName = techList
        .map((t) => t['technician_name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .join(', ');
  }

  return RaiseComplaintModel(
    id: (map['id'] as num?)?.toInt(),
    categoryName: map['Category_name']?.toString() ?? '',
    serviceRequired: map['service_required']?.toString(),
    problem: map['problem']?.toString(),
    priorityLevel: map['priority_level']?.toString(),
    date: map['Date'] != null ? DateTime.tryParse(map['Date'].toString()) : null,
    tickectid: map['tickectid']?.toString() ?? '',
    otp: map['otp']?.toString() ?? '',
    imageUrl: map['image_url']?.toString(),
    audioUrl: map['audio_url']?.toString(),
    complaintStatus: map['complaint_status']?.toString(),
    technicianName: technicianName,
    customerId: map['customer_id']?.toString(),
    techstatus: map['tech_status']?.toString(),
  );
}
  Map<String, dynamic> toMap() {
    return {
      'Category_name': categoryName,
      'service_required': serviceRequired,
      'problem': problem,
      'priority_level': priorityLevel,
      'Date': date?.toIso8601String(),
      'tickectid': tickectid,
      'otp': otp,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'tech_status': complaintStatus,
      'technician_name': technicianName,
      'customer_id': customerId,
    };
  }
}