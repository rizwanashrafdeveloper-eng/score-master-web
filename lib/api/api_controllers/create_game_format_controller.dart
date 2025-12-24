import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../constants/route_name.dart';
import '../../shared_preference/shared_preference.dart';
import '../api_models/create_game_format_model.dart';
import '../api_models/create_game_models_index1.dart';
import '../api_urls.dart';

class UnifiedCreateGameFormatController extends GetxController {
  // --- Form controllers ---
  final sessionNameController = TextEditingController();
  final searchController = TextEditingController();

  // --- Observables ---
  var gameFormatId = 0.obs;
  var selectedGameFormatIds = <int>[].obs; // For multiple selection

  var minPlayers = 5.obs;
  var maxPlayers = 10.obs;
  var badgeNames = <String>[].obs;
  var badgeScores = <int>[].obs;
  var aiScoring = false.obs;
  var allowLaterJoin = false.obs;
  var sendInvitation = false.obs;
  var recordSession = false.obs;
  var startedAt = Rxn<DateTime>();
  var isLoadingImmediate = false.obs;
  var isLoadingScheduled = false.obs;
  var isGameFormatsLoading = true.obs;
  var gameFormats = <SelectGameFormat>[].obs;
  var filteredGameFormats = <SelectGameFormat>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("🔹 [Controller] Initialized");
    fetchGameFormats();
  }

  @override
  void onReady() {
    super.onReady();
    print("🔹 [Controller] Ready");
  }

  @override
  void onClose() {
    print("🔹 [Controller] Closed");
    sessionNameController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // --- Filter game formats ---
  void filterGameFormats(String query) {
    print("🔹 [Controller] Filtering game formats with query: '$query'");
    if (query.isEmpty) {
      filteredGameFormats.assignAll(
          gameFormats.where((format) => format.name?.isNotEmpty ?? false).toList()
      );
    } else {
      filteredGameFormats.assignAll(
        gameFormats.where((format) {
          if (format.name?.isEmpty ?? true) return false;
          final name = format.name!.toLowerCase();
          final desc = format.description?.toLowerCase() ?? '';
          final mode = format.mode?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              desc.contains(query.toLowerCase()) ||
              mode.contains(query.toLowerCase());
        }).toList(),
      );
    }
    print("🔹 [Controller] Filtered game formats count: ${filteredGameFormats.length}");
  }

  // --- Fetch game formats ---
  Future<void> fetchGameFormats() async {
    print("🔹 [Controller] Fetching game formats...");
    isGameFormatsLoading.value = true;
    try {
      final token = await SharedPrefServices.getAuthToken() ?? '';
      print("🔹 [Controller] Auth Token: ${token.isNotEmpty ? '[REDACTED]' : 'None'}");

      final response = await http.get(
        Uri.parse(ApiEndpoints.selectGameFormat),
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      print("🔹 [Controller] Response Code: ${response.statusCode}");
      print("🔹 [Controller] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter out invalid formats and handle null IDs
        final validFormats = data.map((json) {
          final format = SelectGameFormat.fromJson(json);
          // Ensure format has valid ID and name
          if ((format.id ?? 0) == 0) {
            print("⚠️ [Controller] Skipping format with invalid ID: ${format.name}");
            return null;
          }
          return format;
        }).where((format) => format != null).cast<SelectGameFormat>().toList();

        gameFormats.value = validFormats;
        filteredGameFormats.assignAll(validFormats);

        print("✅ [Controller] Loaded ${gameFormats.length} valid game formats");

        if (gameFormats.isEmpty) {
          Get.snackbar('Info', 'No game formats available');
        }
      } else {
        print("❌ [Controller] API Error: ${response.statusCode}");
        Get.snackbar('Error', 'Failed to fetch game formats: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ [Controller] Exception fetching game formats: $e");
      Get.snackbar('Error', 'Failed to load game formats: $e');
    } finally {
      isGameFormatsLoading.value = false;
    }


  }




  // --- Game format selection (single selection) ---
  void toggleGameFormatSelection(int id) {
    if (id == 0) {
      print("⚠️ [Controller] Cannot select format with ID 0");
      return;
    }

    // Single selection logic: clear previous selection
    selectedGameFormatIds.clear();
    selectedGameFormatIds.add(id);
    gameFormatId.value = id;

    print("🔹 [Controller] Selected game format ID: $id");
  }

  //
  // // --- Game format selection ---
  // void toggleGameFormatSelection(int id) {
  //   if (id == 0) {
  //     print("⚠️ [Controller] Cannot select format with ID 0");
  //     return;
  //   }
  //
  //   if (selectedGameFormatIds.contains(id)) {
  //     selectedGameFormatIds.remove(id);
  //     print("🔹 [Controller] Unselected game format ID: $id");
  //   } else {
  //     selectedGameFormatIds.add(id);
  //     print("🔹 [Controller] Selected game format ID: $id");
  //   }

  //   // Update single selection for backward compatibility
  //   gameFormatId.value = selectedGameFormatIds.isNotEmpty ? selectedGameFormatIds.first : 0;
  //
  //   print("🔹 [Controller] Current selection: ${selectedGameFormatIds.toList()}");
  // }

  // --- Player settings ---
  void setPlayerRange(int min, int max) {
    print("🔹 [Controller] Player range set: $min - $max");
    minPlayers.value = min;
    maxPlayers.value = max;
  }

  void addBadgeName(String badge) {
    print("🔹 [Controller] Adding badge: $badge");
    badgeNames.add(badge);
  }

  void removeBadgeName(String badge) {
    print("🔹 [Controller] Removing badge: $badge");
    badgeNames.remove(badge);
  }

  void setBadgeScore(int score) {
    print("🔹 [Controller] Setting badge score: $score");
    if (badgeScores.isNotEmpty) {
      badgeScores[0] = score;
    } else {
      badgeScores.add(score);
    }
  }

  void setAiScoring(bool value) {
    print("🔹 [Controller] AI scoring: $value");
    aiScoring.value = value;
  }

  void setAllowLaterJoin(bool value) {
    print("🔹 [Controller] Allow later join: $value");
    allowLaterJoin.value = value;
  }

  void setSendInvitation(bool value) {
    print("🔹 [Controller] Send invitation: $value");
    sendInvitation.value = value;
  }

  void setRecordSession(bool value) {
    print("🔹 [Controller] Record session: $value");
    recordSession.value = value;
  }

  void setStartedAt(DateTime dateTime) {
    print("🔹 [Controller] Session start date set: $dateTime");
    startedAt.value = dateTime;
  }

  // --- Validations ---
  String? validateSessionName(String? value) {
    if (value == null || value.isEmpty) {
      print("⚠️ [Controller] Session name validation failed");
      return 'Please enter a session name';
    }
    return null;
  }

  String? validatePlayers(String? value) {
    if (value == null || value.isEmpty) {
      print("⚠️ [Controller] Player count validation failed");
      return 'Please enter a valid number';
    }
    final count = int.tryParse(value);
    if (count == null || count < 1) {
      print("⚠️ [Controller] Player count invalid: $value");
      return 'Please enter a valid number';
    }
    return null;
  }


  Future<bool> createSession({bool scheduleForLater = false}) async {
    print("🔹 [Controller] Starting session creation (schedule: $scheduleForLater)");

    final role = await SharedPrefServices.getUserRole() ?? 'unknown';
    print("🔹 [Controller] User role detected: $role");

    if (sessionNameController.text.isEmpty) {
      Get.snackbar('Error', 'Session name is required');
      return false;
    }

    if (selectedGameFormatIds.isEmpty) {
      Get.snackbar('Error', 'Please select at least one game format');
      return false;
    }

    if (scheduleForLater && startedAt.value == null) {
      Get.snackbar('Error', 'Please select a date and time for scheduled session');
      return false;
    }

    if (scheduleForLater) {
      isLoadingScheduled.value = true;
    } else {
      isLoadingImmediate.value = true;
    }

    try {
      final token = await SharedPrefServices.getAuthToken();
      final userId = await SharedPrefServices.getUserId();

      if (token == null || userId == null) {
        Get.snackbar('Error', 'Authentication failed. Please login again.');
        return false;
      }

      final String formattedDate = scheduleForLater
          ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(startedAt.value!.toUtc())
          : DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(DateTime.now().toUtc());

      bool allSessionsCreated = true;
      List<String> errors = [];

      for (final formatId in selectedGameFormatIds) {
        try {
          final Map<String, dynamic> sessionPayload = {
            'gameFormatId': formatId,
            'userId': userId,
            'description': sessionNameController.text,
            'duration': 60,
            'startedAt': formattedDate,
            'status': scheduleForLater ? 'scheduled' : 'active',
            'createdBy': role, // ✅ New Field
          };

          print("📡 [Controller] Sending Create Session Request: ${json.encode(sessionPayload)}");

          final sessionResponse = await http.post(
            Uri.parse(ApiEndpoints.createSession),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(sessionPayload),
          );

          if (sessionResponse.statusCode == 201) {
            final sessionData = json.decode(sessionResponse.body);
            final sessionId = sessionData['id'] as int?;
            if (sessionId != null) {
              await SharedPrefServices.saveSessionId(sessionId);
            }

            // Create capacity config
            final capacityPayload = CreateGameFormatModel(
              gameFormatId: formatId,
              minPlayers: minPlayers.value,
              maxPlayers: maxPlayers.value,
              badgeNames: badgeNames.toList(),
              requireAllTrue: false,
              aiScoring: aiScoring.value,
              allowLaterJoin: allowLaterJoin.value,
              sendInvitation: sendInvitation.value,
              recordSession: recordSession.value,
            );

            await http.post(
              Uri.parse(ApiEndpoints.playerCapacity),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: json.encode(capacityPayload.toJson()),
            );

            print("✅ [Controller] Session $formatId created successfully");
          } else {
            final errorBody = json.decode(sessionResponse.body);
            final errorMessage =
                errorBody['message'] ?? 'Failed to create session for format $formatId';
            errors.add(errorMessage);
            allSessionsCreated = false;
          }
        } catch (e) {
          errors.add('Error creating session for format $formatId: $e');
          allSessionsCreated = false;
        }
      }

      if (allSessionsCreated) {
        Get.snackbar('Success', 'Session(s) created successfully!');
        clearForm();

        // ✅ Role-based navigation
        if (role == 'admin') {
          Get.offAllNamed(RouteName.adminDashboard);
        } else if (role == 'facilitator') {
          Get.offAllNamed(RouteName.facilitatorDashboard);
        } else {
          Get.back(); // fallback
        }

        return true;
      } else {
        Get.snackbar('Partial Success', 'Some sessions failed: ${errors.join(", ")}');
        return false;
      }
    } catch (e) {
      print("❌ [Controller] Exception in createSession: $e");
      Get.snackbar('Error', 'Failed to create session: $e');
      return false;
    } finally {
      isLoadingScheduled.value = false;
      isLoadingImmediate.value = false;
    }
  }

  //
  // // --- Create session ---
  // Future<bool> createSession({bool scheduleForLater = false}) async {
  //   print("🔹 [Controller] Starting session creation (schedule: $scheduleForLater)");
  //
  //   // Single validation block (removed duplicates)
  //   if (sessionNameController.text.isEmpty) {
  //     Get.snackbar('Error', 'Session name is required');
  //     return false;
  //   }
  //
  //   if (selectedGameFormatIds.isEmpty) {
  //     Get.snackbar('Error', 'Please select at least one game format');
  //     return false;
  //   }
  //
  //   if (scheduleForLater && startedAt.value == null) {
  //     Get.snackbar('Error', 'Please select a date and time for scheduled session');
  //     return false;
  //   }
  //
  //   print("🔹 [Controller] Creating sessions for selected formats: $selectedGameFormatIds");
  //
  //   // Single loading state assignment (removed duplicates)
  //   if (scheduleForLater) {
  //     isLoadingScheduled.value = true;
  //   } else {
  //     isLoadingImmediate.value = true;
  //   }
  //
  //   try {
  //     final token = await SharedPrefServices.getAuthToken();
  //     final userId = await SharedPrefServices.getUserId();
  //     if (token == null || userId == null) {
  //       Get.snackbar('Error', 'Authentication failed. Please login again.');
  //       return false;
  //     }
  //
  //     final String formattedDate = scheduleForLater
  //         ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(startedAt.value!.toUtc())
  //         : DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'").format(DateTime.now().toUtc());
  //
  //     bool allSessionsCreated = true;
  //     List<String> errors = [];
  //
  //     // Loop through all selected formats and create sessions for each
  //     for (final formatId in selectedGameFormatIds) {
  //       try {
  //         final Map<String, dynamic> sessionPayload = {
  //           'gameFormatId': formatId,
  //           'userId': userId,
  //           'description': sessionNameController.text,
  //           'duration': 60,
  //           'startedAt': formattedDate,
  //           'status': scheduleForLater ? 'scheduled' : 'active',
  //         };
  //
  //         print("📡 [Controller] Sending Create Session Request for ID: $formatId");
  //         print("   - URL: ${ApiEndpoints.createSession}");
  //         print("   - Payload: ${json.encode(sessionPayload)}");
  //
  //         final sessionResponse = await http.post(
  //           Uri.parse(ApiEndpoints.createSession),
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $token',
  //           },
  //           body: json.encode(sessionPayload),
  //         );
  //
  //         print("📥 [Controller] Session Response Code: ${sessionResponse.statusCode}");
  //         print("📥 [Controller] Session Response Body: ${sessionResponse.body}");
  //
  //         if (sessionResponse.statusCode == 201) {
  //           final sessionData = json.decode(sessionResponse.body);
  //           final sessionId = sessionData['id'] as int?;
  //           if (sessionId != null) {
  //             await SharedPrefServices.saveSessionId(sessionId);
  //             print("🔹 [Controller] Session ID saved: $sessionId");
  //           }
  //
  //           // Create capacity settings
  //           final capacityPayload = CreateGameFormatModel(
  //             gameFormatId: formatId,
  //             minPlayers: minPlayers.value,
  //             maxPlayers: maxPlayers.value,
  //             badgeNames: badgeNames.toList(),
  //             requireAllTrue: false,
  //             aiScoring: aiScoring.value,
  //             allowLaterJoin: allowLaterJoin.value,
  //             sendInvitation: sendInvitation.value,
  //             recordSession: recordSession.value,
  //           );
  //
  //           final capacityResponse = await http.post(
  //             Uri.parse(ApiEndpoints.playerCapacity),
  //             headers: {
  //               'Content-Type': 'application/json',
  //               'Authorization': 'Bearer $token',
  //             },
  //             body: json.encode(capacityPayload.toJson()),
  //           );
  //
  //           print("📥 [Controller] Capacity Response Code: ${capacityResponse.statusCode}");
  //           print("📥 [Controller] Capacity Response Body: ${capacityResponse.body}");
  //
  //           if (capacityResponse.statusCode != 201) {
  //             final errorBody = json.decode(capacityResponse.body);
  //             final errorMessage = errorBody['message'] ?? 'Failed to save player capacity for format $formatId';
  //             errors.add(errorMessage);
  //             allSessionsCreated = false;
  //             print("⚠️ [Controller] Capacity creation failed: $errorMessage");
  //           } else {
  //             print("✅ [Controller] Session $formatId + Capacity created successfully!");
  //           }
  //         } else {
  //           final errorBody = json.decode(sessionResponse.body);
  //           final errorMessage = errorBody['message'] ?? 'Failed to create session for format $formatId';
  //           errors.add(errorMessage);
  //           allSessionsCreated = false;
  //           print("⚠️ [Controller] Session creation failed: $errorMessage");
  //         }
  //       } catch (e) {
  //         final errorMsg = 'Error creating session for format $formatId: $e';
  //         errors.add(errorMsg);
  //         allSessionsCreated = false;
  //         print("❌ [Controller] Exception for format $formatId: $e");
  //       }
  //     }
  //
  //     if (allSessionsCreated) {
  //       Get.snackbar('Success', '${selectedGameFormatIds.length} session(s) created successfully!');
  //       clearForm();
  //       return true;
  //     } else {
  //       Get.snackbar('Partial Success',
  //           'Some sessions created with errors: ${errors.join(", ")}',
  //           duration: const Duration(seconds: 5)
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     print("❌ [Controller] Exception in createSession: $e");
  //     Get.snackbar('Error', 'Failed to create sessions: $e');
  //     return false;
  //   } finally {
  //     if (scheduleForLater) {
  //       isLoadingScheduled.value = false;
  //     } else {
  //       isLoadingImmediate.value = false;
  //     }
  //   }
  // }

  void clearForm() {
    print("🔹 [Controller] Clearing form");
    sessionNameController.clear();
    gameFormatId.value = 0;
    selectedGameFormatIds.clear();
    minPlayers.value = 5;
    maxPlayers.value = 10;
    badgeNames.clear();
    badgeScores.clear();
    aiScoring.value = false;
    allowLaterJoin.value = false;
    sendInvitation.value = false;
    recordSession.value = false;
    startedAt.value = null;
    searchController.clear();
    filteredGameFormats.assignAll(
        gameFormats.where((format) => format.name?.isNotEmpty ?? false).toList()
    );
  }
}