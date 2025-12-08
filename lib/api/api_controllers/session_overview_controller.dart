// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:developer' as developer;
// import '../../shared_preferences/shared_preferences.dart';
// import '../api_models/session_overview_model.dart';
// import '../api_urls.dart';
// import 'package:http/http.dart'as http;
//
// class SessionController extends GetxController {
//   var isLoading = true.obs;
//   var session = Rxn<SessionOverViewModel>();
//
//   final SessionService _sessionService = SessionService();
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeSession();
//   }
//
//   Future<void> initializeSession() async {
//     try {
//       isLoading(true);
//
//       final sessionId = await SharedPrefServices.getSessionId();
//       developer.log('Stored session ID: $sessionId', name: 'SessionController');
//
//       if (sessionId != null) {
//         await fetchSession(sessionId);
//       } else {
//         developer.log('No session ID found in storage', name: 'SessionController');
//         isLoading(false);
//       }
//     } catch (e) {
//       developer.log('Error initializing session: $e', name: 'SessionController');
//       isLoading(false);
//     }
//   }
//
//   Future<void> fetchSession(int sessionId) async {
//     try {
//       isLoading(true);
//       developer.log('Fetching session with ID: $sessionId', name: 'SessionController');
//
//       final result = await _sessionService.fetchSessionDetail(sessionId);
//       if (result != null) {
//         session.value = result;
//         // developer.log('Session loaded successfully: ${result.sessiontitle}', name: 'SessionController');
//
//         await SharedPrefServices.saveSessionId(result.id);
//         developer.log('💾 Saved sessionId=${result.id}', name: 'SessionController');
//       } else {
//         developer.log('Failed to load session - API returned null', name: 'SessionController');
//       }
//     } catch (e) {
//       developer.log('Error in fetchSession: $e', name: 'SessionController');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> saveAndFetchSession(int sessionId) async {
//     await SharedPrefServices.saveSessionId(sessionId);
//     developer.log('Session ID saved: $sessionId', name: 'SessionController');
//     await fetchSession(sessionId);
//   }
//
//   Future<void> refreshSession() async {
//     final sessionId = await SharedPrefServices.getSessionId();
//     if (sessionId != null) {
//       await fetchSession(sessionId);
//     } else {
//       developer.log('Cannot refresh - no session ID available', name: 'SessionController');
//     }
//   }
//
//   Future<void> clearSession() async {
//     session.value = null;
//     // await SharedPrefServices.clearSessionId();
//     developer.log('Session cleared', name: 'SessionController');
//   }
// }
//
// class SessionService {
//   Future<String?> _getToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString('auth_token');
//     } catch (e) {
//       developer.log('Error getting token: $e', name: 'SessionService');
//       return null;
//     }
//   }
//
//   Future<SessionOverViewModel?> fetchSessionDetail(int sessionId) async {
//     final url = ApiEndpoints.sessionDetail(sessionId);
//     developer.log('Fetching session detail from URL: $url', name: 'SessionService');
//
//     try {
//       final token = await _getToken();
//
//       if (token == null) {
//         developer.log('No auth token found', name: 'SessionService');
//         return null;
//       }
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       developer.log('API Response Status: ${response.statusCode}', name: 'SessionService');
//       developer.log('API Response Body: ${response.body}', name: 'SessionService');
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         return SessionOverViewModel.fromJson(jsonData);
//       } else if (response.statusCode == 401) {
//         developer.log('Unauthorized - token may be invalid', name: 'SessionService');
//         return null;
//       } else if (response.statusCode == 404) {
//         developer.log('Session not found', name: 'SessionService');
//         return null;
//       } else {
//         developer.log('Failed to load session detail: ${response.statusCode} - ${response.reasonPhrase}', name: 'SessionService');
//         return null;
//       }
//     } catch (e) {
//       developer.log('Error fetching session detail: $e', name: 'SessionService');
//       return null;
//     }
//   }
// }