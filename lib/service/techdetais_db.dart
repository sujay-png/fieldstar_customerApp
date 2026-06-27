
import 'package:field_star_customer_app/model/tech_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TechdetaisDb {
  final _supabase = Supabase.instance.client;
  //===============================Fetch Techname============================


Future<TechModel?> fetchTechDetails(String ticketId) async {
  final complaintResponse = await _supabase
      .from('Raise_complaint')
      .select('technician_id')
      .eq('tickectid', ticketId)
      .maybeSingle();

  if (complaintResponse == null ||
      complaintResponse['technician_id'] == null) {
    return null;
  }

  final technicianId = complaintResponse['technician_id'];

  final technicianResponse = await _supabase
      .from('technician')
      .select()
      .eq('id', technicianId)
      .maybeSingle();

  if (technicianResponse == null) return null;

  return TechModel.fromMap(technicianResponse);
}
Future<int> generateInvoiceNumber() async {
  final response = await _supabase
      .rpc('get_next_invoice_number');
  return response as int;
}




}