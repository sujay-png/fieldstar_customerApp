import 'dart:io';
import 'package:field_star_customer_app/model/customer_model.dart';
import 'package:field_star_customer_app/model/raise_complaint_model.dart';
import 'package:field_star_customer_app/model/service_rating_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RaiseComplaintDb {
  final _supabase = Supabase.instance.client;

  //=====================Submit complaint=============================
  Future<void> submitFullComplaint(RaiseComplaintModel model,{File? imageFile}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');
        String? imageUrl = model.imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(model.tickectid, imageFile); // ← folder = ticketId
    }


      await _supabase.from('customer').upsert({
        'id': user.id,
        'cust_name': model.customerName,
        'cust_phno': model.customerPhone,
        'cust_location': model.customerLocation,
        'cust_place': model.customerPlace,
        'cust_hotelname': model.customerHotelName,
        
        
      });

      final data = model.toMap();
      data['customer_id'] = user.id;
       data['image_url'] = imageUrl; 

      await _supabase.from('Raise_complaint').insert(data);
    } catch (e) {
      throw Exception('Failed to insert: $e');
    }
  }

  //============================fetch complaint============================================
  Future<List<RaiseComplaintModel>> Fetchcomplaints() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) throw Exception('User not logged in');

      final response = await _supabase
          .from('Raise_complaint')
          .select('*, complaint_technicians(technician_name)')
          .eq('customer_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => RaiseComplaintModel.fromMap(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch: $e');
    }
  }

  Future<List<RaiseComplaintModel>> fetchCompletedComplaints() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    final response = await Supabase.instance.client
        .from('Raise_complaint')
        .select()
        .eq('customer_id', userId!)
        .eq('complaint_status', 'Completed');

    return (response as List)
        .map((e) => RaiseComplaintModel.fromMap(e))
        .toList();
  }

  //==================Upload Images===================================
Future<String?> uploadImage(String complaintId, File imageFile) async {
  try {
    final path = '$complaintId/${DateTime.now().millisecondsSinceEpoch}';
    await _supabase.storage.from('uploads').upload(path, imageFile);
    return _supabase.storage.from('uploads').getPublicUrl(path);
  } catch (e) {
    print('Image upload error: $e');
    return null;
  }
}

  //====================== Upload audio ===================================
  Future<String?> uploadAudio(String audioFilePath) async {
    try {
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.wav';
      final path = 'uploads/$fileName';
      final audioFile = File(audioFilePath);

      await _supabase.storage.from('complaint-audio').upload(path, audioFile);

      final url = _supabase.storage.from('complaint-audio').getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Audio upload failed: $e');
    }
  }

  //=================================FetchComplaints by ID================================
  Future<RaiseComplaintModel?> fetchComplaintByTicketId(String ticketId) async {
    final response = await _supabase
        .from('Raise_complaint')
        .select()
        .eq('tickectid', ticketId)
        .maybeSingle();

    if (response == null) return null;

    return RaiseComplaintModel.fromMap(response);
  }

  // =============================Fetch rating by ticket ID ========================================
  Future<ServiceRatingModel?> fetchRatingByTicketId(String ticketId) async {
    final response = await _supabase
        .from('service_ratings')
        .select()
        .eq('ticket_id', ticketId)
        .maybeSingle();

    if (response == null) return null;
    return ServiceRatingModel.fromJson(response);
  }

  //======================Save Rating==========================
  Future<void> submitRating(ServiceRatingModel model) async {
    await Supabase.instance.client
        .from('service_ratings')
        .insert(model.toMap());
    await Supabase.instance.client
        .from('Raise_complaint')
        .update({'complaint_status': 'Completed'})
        .eq('tickectid', model.ticketId);
  }

  //====================Fetch complaint counts=======================
  Future<Map<String, int>> fetchComplaintStats() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return {'total': 0, 'completed': 0, 'pending': 0};
    }

    final response = await _supabase
        .from('Raise_complaint')
        .select('complaint_status')
        .eq('customer_id', user.id);

    final complaints = response as List;

    final total = complaints.length;

    final completed = complaints.where((item) {
      return item['complaint_status']?.toString() == 'Completed';
    }).length;

    final pending = complaints.where((item) {
      return item['complaint_status']?.toString().toLowerCase() == 'pending';
    }).length;

    return {'total': total, 'completed': completed, 'pending': pending};
  }

  //======================Fetch customer details===============================
 Future<CustomerModel?> fetchCustomerDetails() async {
  try {
    final user = _supabase.auth.currentUser;
    print('Current user: ${user?.id}');

    if (user == null) return null;

    final response = await _supabase
        .from('customer')
        .select('*, Raise_complaint(id, tickectid)') 
        .eq('id', user.id)
        .maybeSingle();

    print('Customer response: $response');
    if (response == null) return null;

    // Extract ticket IDs from joined complaints
    final complaints = response['Raise_complaint'] as List? ?? [];
    final ticketIds = complaints
        .map((c) => c['tickectid']?.toString() ?? '')
        .where((t) => t.isNotEmpty)
        .toList();

    return CustomerModel.fromMap({
      ...response,
      'complaint_count': complaints.length,
      'ticket_ids': ticketIds,
    });
  } catch (e) {
    print('Error fetching customer: $e');
    return null;
  }
}

}
