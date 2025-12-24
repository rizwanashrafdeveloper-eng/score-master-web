class ApiEndpoints {
  static const String baseUrl = 'https://score-master-backend.onrender.com';

  // -------------------- AUTH --------------------
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String createGame = '$baseUrl/admin/game-formats';
  static const String getFacilitators = '$baseUrl/auth/facilitators';
  static const String getPhase = '$baseUrl/admin/phases';

  static const String users = '$baseUrl/auth/users';

  // -------------------- ADMIN --------------------
  static const String gameModelS = '$baseUrl/admin/game-formats/all-games';

  static const String additionalSetting = '$baseUrl/admin/player-capability';

   static const String facilitatorManagementStat = '$baseUrl/user/1/facilitator-stats';
  //static String facilitatorManagementStat(int userId) => '$baseUrl/user/$userId/facilitator-stats';

  static const String playerCapacity = '$baseUrl/admin/player-capability';
  static const String selectGameFormat = '$baseUrl/admin/game-formats/all-games';
  static const String createSession = '$baseUrl/sessions';

  // -------------------- QUESTIONS --------------------
  static const String aiGenerate = '$baseUrl/questions/generate';
  static String questionsForSession(int sessionId, int gameFormatId) =>
      '$baseUrl/questions/questions-for-session/$sessionId/$gameFormatId';

  //static const String viewResponse = '$baseUrl/player-answers/facilitator/1/phase/1';
  static String viewResponse(int facilitatorId, int phaseId) =>
      '$baseUrl/player-answers/facilitator/$facilitatorId/phase/$phaseId';

  // -------------------- TEAM --------------------
  static const String createTeam = '$baseUrl/team/create';
  static String teamsForSession(int sessionId) =>
      '$baseUrl/team/session/$sessionId/members';

  // -------------------- SESSIONS --------------------
  static const String allSessions = '$baseUrl/sessions/with-code';
  static const String joinSession = '$baseUrl/sessions/join';
  static const String postSessionMethod = '$baseUrl/sessions';
  static const String scheduleAndActiveSession = '$baseUrl/sessions/all';
  static const String phaseSession = '$baseUrl/phase-session';

  static String sessionDetail(int sessionId) =>
      "$baseUrl/sessions/$sessionId/detail";
  static String getStartSessionUrl(int sessionId) => '$baseUrl/sessions/$sessionId/start';
  static String getResumeSessionUrl(int sessionId) => '$baseUrl/sessions/$sessionId/resume';
  static String getPauseSessionUrl(int sessionId) => '$baseUrl/sessions/$sessionId/pause';
  static String getPhaseSessionUrl(int sessionId) => '$baseUrl/sessions/$sessionId/phases';
  static String endSession(int sessionId) => '$baseUrl/sessions/$sessionId/complete';
  // -------------------- PLAYER ANSWERS --------------------
  static const String submitPlayerAnswer = '$baseUrl/player-answers/submit';

  // static const String gameFormatPhases = '$baseUrl/questions/session/1/game-format';
  static String gameFormatPhases(int sessionId) => '$baseUrl/questions/session/$sessionId/game-format';

  static const String userAdminFacilitator = '$baseUrl/auth/users';
  static const String evaluateResponse = '$baseUrl/evaluation/evaluate';
  // -------------------- PLAYER SCORES --------------------
  static String playerScore(int playerId, int questionId) =>
      '$baseUrl/scores/player/$playerId/question/$questionId';
  static const String playerScoreUrl = '$baseUrl/scores/player';
  static const String submitScore = '$baseUrl/evaluation/evaluate';

  // static const String analysis = '$baseUrl/scores/1/analytics';
  static String analysis(int sessionId) => '$baseUrl/scores/$sessionId/analytics';

  // -------------------- LEADERBOARD --------------------
  static String playerLeaderboard(int sessionId) =>
      '$baseUrl/scores/ranking/session/$sessionId';
  static String teamLeaderboard(int sessionId) =>
      '$baseUrl/scores/ranking/sessions/$sessionId';

  // -------------------- USER MANAGEMENT --------------------
   static const String userManagementStat = '$baseUrl/user/4/stats';
  //static String userManagementStat(int userId) => '$baseUrl/user/$userId/stats';
}
