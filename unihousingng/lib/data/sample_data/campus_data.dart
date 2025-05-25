import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/campus_model.dart';

class CampusData {
  static List<CampusModel> get allCampuses => [
    fupre,
    unilag,
    ui,
    oau,
    unn,
    abu,
    uniben,
    uniport,
  ];

  // Federal University of Petroleum Resources, Effurun (FUPRE)
  static const CampusModel fupre = CampusModel(
    id: 'fupre',
    name: 'Federal University of Petroleum Resources, Effurun',
    shortName: 'FUPRE',
    state: 'Delta',
    city: 'Effurun',
    location: LatLng(5.5629, 5.7661), // FUPRE coordinates
    description:
        'A specialized federal university focused on petroleum and energy studies, located in the heart of Nigeria\'s oil-rich Niger Delta region.',
    logoUrl: 'https://fupre.edu.ng/wp-content/uploads/2019/07/fupre-logo.png',
    faculties: [
      'Engineering',
      'Environmental Sciences',
      'Science',
      'Management Sciences',
      'Education',
      'Law',
      'Agriculture',
    ],
    studentPopulation: 8500,
    website: 'https://fupre.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(5.5729, 5.7761),
      southwest: LatLng(5.5529, 5.7561),
    ),
  );

  // University of Lagos (UNILAG)
  static const CampusModel unilag = CampusModel(
    id: 'unilag',
    name: 'University of Lagos',
    shortName: 'UNILAG',
    state: 'Lagos',
    city: 'Lagos',
    location: LatLng(6.5158, 3.3966),
    description:
        'One of Nigeria\'s premier universities, known for academic excellence and located in the commercial capital of Nigeria.',
    logoUrl: 'https://unilag.edu.ng/wp-content/uploads/2019/07/unilag-logo.png',
    faculties: [
      'Arts',
      'Business Administration',
      'Education',
      'Engineering',
      'Environmental Sciences',
      'Law',
      'Medicine',
      'Pharmacy',
      'Science',
      'Social Sciences',
    ],
    studentPopulation: 57000,
    website: 'https://unilag.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(6.5258, 3.4066),
      southwest: LatLng(6.5058, 3.3866),
    ),
  );

  // University of Ibadan (UI)
  static const CampusModel ui = CampusModel(
    id: 'ui',
    name: 'University of Ibadan',
    shortName: 'UI',
    state: 'Oyo',
    city: 'Ibadan',
    location: LatLng(7.4474, 3.9056),
    description:
        'Nigeria\'s oldest university, established in 1948, renowned for its academic tradition and beautiful campus.',
    logoUrl: 'https://ui.edu.ng/sites/default/files/ui-logo.png',
    faculties: [
      'Arts',
      'Agriculture and Forestry',
      'Basic Medical Sciences',
      'Clinical Sciences',
      'Dentistry',
      'Economics and Management Sciences',
      'Education',
      'Law',
      'Pharmacy',
      'Public Health',
      'Renewable Natural Resources',
      'Science',
      'Social Sciences',
      'Technology',
      'Veterinary Medicine',
    ],
    studentPopulation: 41000,
    website: 'https://ui.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(7.4574, 3.9156),
      southwest: LatLng(7.4374, 3.8956),
    ),
  );

  // Obafemi Awolowo University (OAU)
  static const CampusModel oau = CampusModel(
    id: 'oau',
    name: 'Obafemi Awolowo University',
    shortName: 'OAU',
    state: 'Osun',
    city: 'Ile-Ife',
    location: LatLng(7.5243, 4.5216),
    description:
        'Known for its beautiful campus and academic excellence, OAU is one of Nigeria\'s most prestigious universities.',
    logoUrl: 'https://oauife.edu.ng/sites/default/files/oau-logo.png',
    faculties: [
      'Administration',
      'Agriculture',
      'Arts',
      'Basic Medical Sciences',
      'Clinical Sciences',
      'Dentistry',
      'Education',
      'Environmental Design and Management',
      'Law',
      'Pharmacy',
      'Public Health',
      'Science',
      'Social Sciences',
      'Technology',
    ],
    studentPopulation: 35000,
    website: 'https://oauife.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(7.5343, 4.5316),
      southwest: LatLng(7.5143, 4.5116),
    ),
  );

  // University of Nigeria, Nsukka (UNN)
  static const CampusModel unn = CampusModel(
    id: 'unn',
    name: 'University of Nigeria, Nsukka',
    shortName: 'UNN',
    state: 'Enugu',
    city: 'Nsukka',
    location: LatLng(6.8747, 7.3986),
    description:
        'The first indigenous university in Nigeria, known for its commitment to academic excellence and cultural heritage.',
    logoUrl: 'https://unn.edu.ng/wp-content/uploads/2019/07/unn-logo.png',
    faculties: [
      'Agriculture',
      'Arts',
      'Biological Sciences',
      'Business Administration',
      'Dentistry',
      'Education',
      'Engineering',
      'Environmental Studies',
      'Law',
      'Medicine',
      'Pharmaceutical Sciences',
      'Physical Sciences',
      'Social Sciences',
      'Veterinary Medicine',
    ],
    studentPopulation: 36000,
    website: 'https://unn.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(6.8847, 7.4086),
      southwest: LatLng(6.8647, 7.3886),
    ),
  );

  // Ahmadu Bello University (ABU)
  static const CampusModel abu = CampusModel(
    id: 'abu',
    name: 'Ahmadu Bello University',
    shortName: 'ABU',
    state: 'Kaduna',
    city: 'Zaria',
    location: LatLng(11.1511, 7.6890),
    description:
        'One of Nigeria\'s largest universities, known for its comprehensive academic programs and research excellence.',
    logoUrl: 'https://abu.edu.ng/wp-content/uploads/2019/07/abu-logo.png',
    faculties: [
      'Administration',
      'Agriculture',
      'Arts and Social Sciences',
      'Education',
      'Engineering',
      'Environmental Design',
      'Law',
      'Medicine',
      'Pharmaceutical Sciences',
      'Science',
      'Veterinary Medicine',
    ],
    studentPopulation: 45000,
    website: 'https://abu.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(11.1611, 7.6990),
      southwest: LatLng(11.1411, 7.6790),
    ),
  );

  // University of Benin (UNIBEN)
  static const CampusModel uniben = CampusModel(
    id: 'uniben',
    name: 'University of Benin',
    shortName: 'UNIBEN',
    state: 'Edo',
    city: 'Benin City',
    location: LatLng(6.4023, 5.6037),
    description:
        'A leading university in South-South Nigeria, known for its medical school and engineering programs.',
    logoUrl: 'https://uniben.edu/wp-content/uploads/2019/07/uniben-logo.png',
    faculties: [
      'Agriculture',
      'Arts',
      'Basic Medical Sciences',
      'Clinical Sciences',
      'Dentistry',
      'Education',
      'Engineering',
      'Environmental Sciences',
      'Law',
      'Life Sciences',
      'Management Sciences',
      'Pharmacy',
      'Physical Sciences',
      'Social Sciences',
    ],
    studentPopulation: 40000,
    website: 'https://uniben.edu',
    bounds: CampusBounds(
      northeast: LatLng(6.4123, 5.6137),
      southwest: LatLng(6.3923, 5.5937),
    ),
  );

  // University of Port Harcourt (UNIPORT)
  static const CampusModel uniport = CampusModel(
    id: 'uniport',
    name: 'University of Port Harcourt',
    shortName: 'UNIPORT',
    state: 'Rivers',
    city: 'Port Harcourt',
    location: LatLng(4.8156, 7.0498),
    description:
        'A prominent university in the Niger Delta region, known for its petroleum engineering and environmental studies.',
    logoUrl:
        'https://uniport.edu.ng/wp-content/uploads/2019/07/uniport-logo.png',
    faculties: [
      'Agriculture',
      'Basic Medical Sciences',
      'Clinical Sciences',
      'Dentistry',
      'Education',
      'Engineering',
      'Environmental Sciences',
      'Humanities',
      'Law',
      'Management Sciences',
      'Pharmacy',
      'Science',
      'Social Sciences',
    ],
    studentPopulation: 38000,
    website: 'https://uniport.edu.ng',
    bounds: CampusBounds(
      northeast: LatLng(4.8256, 7.0598),
      southwest: LatLng(4.8056, 7.0398),
    ),
  );

  // Helper methods
  static CampusModel? getCampusById(String id) {
    try {
      return allCampuses.firstWhere((campus) => campus.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<CampusModel> getCampusesByState(String state) {
    return allCampuses.where((campus) => campus.state == state).toList();
  }

  static List<CampusModel> searchCampuses(String query) {
    final lowercaseQuery = query.toLowerCase();
    return allCampuses.where((campus) {
      return campus.name.toLowerCase().contains(lowercaseQuery) ||
          campus.shortName.toLowerCase().contains(lowercaseQuery) ||
          campus.city.toLowerCase().contains(lowercaseQuery) ||
          campus.state.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  static List<String> get allStates {
    return allCampuses.map((campus) => campus.state).toSet().toList()..sort();
  }

  static List<String> get allCities {
    return allCampuses.map((campus) => campus.city).toSet().toList()..sort();
  }
}
