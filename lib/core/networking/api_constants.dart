class ApiConstants {
//static const String apiBaseUrl = "https://api.myinvite.me/";
 static const String apiBaseUrl = "https://api-uat.myinvite.me/";

  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth';
  static const String clientEvents = 'client/myevents';
  static const String clientEventDetailsEndpoint = 'client/geteventclient?eventid=';
  static const String clientProfileEndpoint = 'client/profile';
  static const String calendarEventsEndpoint = 'events/calender';
  static const String reserveEventEndpoint = 'events/reserveevent?eventid=';
  static const String gatekeeperEventsEndpoint = 'events';
  static const String scanEndpoint = 'scan';
  static const String scanHistoryEndpoint = 'scanhistory';
  static const String checkinEndpoint = 'events/checkin?eventid=';
 static const String checkoutEndpoint = 'events/checkout';
 static const String locationsEndpoint = 'Events/Locations';
  static const String countriesEndpoint = 'Events/GetCountries';
  static const String citiesEndpoint = 'Events/GetCities';
  static const String logsEndpoint = 'ReadLogs';
  static const String messageStatusEndpoint = 'Client/getguestmessagestatus?eventId=';
  static const String searchMessageStatusEndpoint = 'Client/searchguestmessagestatus?eventId=';
  static const String confirmationServiceEndpoint = 'Client/getguestconfirmationstatisticsinfo?eventId=';
  static const String acceptedGuestsEndpoint = 'Client/GetAcceptedGuests?eventId=';
  static const String declinedGuestsEndpoint = 'Client/GetDeclinedGuests?eventId=';
  static const String notAnsweredGuestsEndpoint = 'Client/GetNoAnswerGuests?eventId=';
  static const String failedGuestsEndpoint = 'Client/GetFailedGuests?eventId=';
  static const String notSentGuestsEndpoint = 'Client/GetNotSentGuests?eventId=';
  static const String cardSendingServiceEndpoint = 'Client/getguestcardstatisticsinfo?eventId=';
  static const String guestsCardsReadEndpoint = 'Client/GetReadCardGuests?eventId=';
  static const String guestsCardsReceivedEndpoint = 'Client/GetDeliverdCardGuests?eventId=';
  static const String guestsCardsSentEndpoint = 'Client/GetSentCardGuests?eventId=';
  static const String guestsCardsFailedEndpoint = 'Client/GetFailedCardGuests?eventId=';
  static const String guestsCardsNotSent = 'Client/GetNotSentCardGuests?eventId=';
  static const String allMessageStatisticsEndpoint = 'Client/getmessagesstatisticsinfo?eventId=';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
