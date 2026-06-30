
import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TechdetaisDb {
  final _supabase = Supabase.instance.client;
  //===============================Fetch Techname============================


Future<List<TechModel>> fetchTechDetails(String ticketId) async {
  // 1. Get the complaint's internal id from the ticket id
  final complaintResponse = await _supabase
      .from('Raise_complaint')
      .select('id')
      .eq('tickectid', ticketId)
      .maybeSingle();

  if (complaintResponse == null || complaintResponse['id'] == null) {
    return [];
  }

  final complaintId = complaintResponse['id'];

  // 2. Get all technicians assigned to this complaint, joined with technician details
  final assignedResponse = await _supabase
      .from('complaint_technicians')
      .select('technician(*)')
      .eq('complaint_id', complaintId);

  if (assignedResponse == null || (assignedResponse as List).isEmpty) {
    return [];
  }

  return (assignedResponse)
      .where((row) => row['technician'] != null)
      .map((row) => TechModel.fromMap(row['technician'] as Map<String, dynamic>))
      .toList();
}
Future<int> generateInvoiceNumber() async {
  final response = await _supabase
      .rpc('get_next_invoice_number');
  return response as int;
}




}