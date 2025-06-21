class ModelConstants {
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String alertsCollection = 'alerts';
  static const String emergenciesCollection = 'emergencies';

  // Alert Statuses
  static const String statusActive = 'active';
  static const String statusResolved = 'resolved';
  static const String statusInvestigating = 'investigating';

  // Alert Types
  static const String typeTheft = 'theft';
  static const String typeAssault = 'assault';
  static const String typeVandalism = 'vandalism';
  static const String typeEmergency = 'emergency'; // General emergency

  // Emergency Service Types
  static const String servicePolice = 'police';
  static const String serviceAmbulance = 'ambulance';
  static const String serviceFire = 'fire';
}
