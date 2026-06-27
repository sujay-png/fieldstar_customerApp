class ServiceRatingModel {
  final String ticketId;
  final String technicianId;
  final String technicianName;
  final String equipment;
  final String serviceDate;
  final int rating;
  final String ratingLabel;
  final List<String> selectedTags;
  final String comments;
  final String status;

  ServiceRatingModel({
    required this.ticketId,
    required this.technicianId,
    required this.technicianName,
    required this.equipment,
    required this.serviceDate,
    required this.rating,
    required this.ratingLabel,
    required this.selectedTags,
    required this.comments,
    required this.status,
  });

  factory ServiceRatingModel.fromJson(Map<String, dynamic> json) {
    return ServiceRatingModel(
      ticketId: json['ticket_id'] ?? '',
      technicianId: json['technician_id'] ?? '',
      technicianName: json['technician_name'] ?? '',
      equipment: json['equipment'] ?? '',
      serviceDate: json['service_date'] ?? '',
      rating: json['rating'] ?? 0,
      ratingLabel: json['rating_label'] ?? '',
      selectedTags: List<String>.from(json['selected_tags'] ?? []),
      comments: json['comments'] ?? '',
       status: json['status'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ticket_id': ticketId,
      'technician_id': technicianId,
      'technician_name': technicianName,
      'equipment': equipment,
      'service_date': serviceDate,
      'rating': rating,
      'rating_label': ratingLabel,
      'selected_tags': selectedTags,
      'comments': comments,
       'status': 'Completed',
    };
  }
}