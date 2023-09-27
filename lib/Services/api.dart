import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:izzup/Models/employer.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Models/homepage_card_data.dart';
import 'package:izzup/Models/stats.dart';
import 'package:izzup/Models/user_with_request.dart';
import 'package:izzup/Services/prefs.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../Models/company.dart';
import '../Models/extra.dart';
import '../Models/job_offer.dart';
import '../Models/job_offer_requests.dart';
import '../Models/map_location.dart';
import '../Models/place.dart';
import '../Models/tag.dart';
import '../Models/user.dart';
import 'string_to_bool.dart';

class Api {
  static const _baseRoute = 'https://izzup-api-pfktdq573a-od.a.run.app/';
  static const _apiRoute = "${_baseRoute}api/v1/";

  static getUri(String route, [forApi = true]) {
    return Uri.parse(forApi ? _apiRoute + route : _baseRoute + route);
  }

  static getUriString(String route) {
    return '$_baseRoute$route';
  }

  static Future<bool?> authCheck(String email) async {
    var client = http.Client();
    try {
      var response =
          await client.post(getUri('auth/check'), body: {'email': email});
      return response.body.toBoolean();
    } finally {
      client.close();
    }
  }

  static Future<int> _registerExtra(Extra extra) async {
    var client = http.Client();
    try {
      var response = await client.post(getUri('auth/register/extra'), body: {
        "email": extra.email,
        "password": extra.password,
        "last_name": extra.lastName,
        "first_name": extra.firstName,
        "date_of_birth": extra.dateOfBirth.dateString,
        "address": extra.address
      });
      return response.statusCode;
    } finally {
      client.close();
    }
  }

  static Future<int> _registerEmployer(Employer employer) async {
    var client = http.Client();
    try {
      var response = await client.post(getUri('auth/register/employer'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(employer.toJson()));
      return response.statusCode;
    } finally {
      client.close();
    }
  }

  static Future<bool> registerAndLoginExtra() async {
    int registerStatusCode = await _registerExtra(Globals.tempExtra);
    return await login(Globals.tempExtra);
  }

  static Future<bool> registerAndLoginEmployer() async {
    int registerStatusCode = await _registerEmployer(Globals.tempEmployer);
    return await login(Extra(Globals.tempEmployer.email,
        Globals.tempEmployer.password, DateTime.now()));
  }

  static Future<Map<String, dynamic>> _login(Extra extra) async {
    var client = http.Client();
    try {
      var response = await client.post(getUri('auth/login'),
          body: {"email": extra.email, "password": extra.password});
      return jsonDecode(response.body);
    } finally {
      client.close();
    }
  }

  static Future<bool> login(Extra extra) async {
    Map<String, dynamic> loginResult = await _login(extra);
    if (loginResult.keys.contains('token')) {
      if (kDebugMode) print("Token updated");
      Prefs.setString('authToken', loginResult['token']);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> logout() async {
    Prefs.setString('authToken', '');
    return true;
  }

  static Future<List<HomepageCardData>> homepageCards() async {
    final authToken = await Prefs.getString('authToken');
    var client = http.Client();
    try {
      var response = await client.get(
        getUri('homepage-card'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
      );
      List<HomepageCardData> cards = [];
      for (var card in jsonDecode(response.body)) {
        cards.add(HomepageCardData.fromJson(card));
      }
      return cards;
    } finally {
      client.close();
    }
  }

  static Future<Place?> getPlace(String name, String address) async {
    var client = http.Client();
    try {
      var response =
          await client.get(getUri('google-places/search/$name $address'));
      final jsonBody = jsonDecode(response.body);
      if (jsonBody.length == 0) {
        return null;
      }
      return Place.fromJson(jsonDecode(response.body)[0]);
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    var client = http.Client();
    try {
      var response = await client.get(getUri('google-places/details/$placeId'));
      final jsonBody = jsonDecode(response.body);
      if (jsonBody['result'] == null) {
        return null;
      }
      return jsonBody['result'];
    } finally {
      client.close();
    }
  }

  static Future<List<String>?> getPlacePhotoLinks(String placeId) async {
    final placeDetails = await Api.getPlaceDetails(placeId);
    List<String> placeImagesLinks = List<String>.empty(growable: true);
    if (placeDetails != null) {
      placeDetails['photos']
          .map((photo) => {'photo_reference': photo['photo_reference']})
          .toList()
          .forEach((element) {
        placeImagesLinks.add(_getPlacePhotoLink(element['photo_reference']));
      });
    }
    return placeImagesLinks;
  }

  static String _getPlacePhotoLink(String ref) {
    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=400'
        '&photo_reference=$ref'
        '&key=AIzaSyA0OV0UsfJbZXDg5GKvWgHhuRC5iDqlw_g';
  }

  static Future<bool> uploadProfilePhoto(String imagePath) async {
    var request = http.MultipartRequest("POST", getUri('user/upload/photo'));
    final token = await Prefs.getString('authToken');
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        imagePath,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers['Authorization'] = 'Bearer $token';
    var response = await request.send();
    return response.statusCode == 201;
  }

  static Future<bool> uploadIdPhoto(String imagePath) async {
    var request = http.MultipartRequest("POST", getUri('user/upload/id_photo'));
    final token = await Prefs.getString('authToken');
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        imagePath,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers['Authorization'] = 'Bearer $token';
    var response = await request.send();
    return response.statusCode == 201;
  }

  static Future<List<MapLocation>?> jobOffersInRange() async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.post(
        getUri('location/job-offers-in-range'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          "longitude": Globals.locationData?.longitude,
          "latitude": Globals.locationData?.latitude,
        }),
      );
      List<MapLocation> locations = [];
      var jsonLocations = jsonDecode(response.body);
      for (var location in jsonLocations) {
        locations.add(MapLocation.fromJson(location));
      }
      return locations;
    } finally {
      client.close();
    }
  }

  static Future<User?> getProfile() async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return null;
    final id = JwtDecoder.decode(authToken)['id'];
    var client = http.Client();
    try {
      var response = await client.get(getUri('user/$id'), headers: {
        'Authorization': 'Bearer $authToken',
      });
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return User.fromJson(jsonBody);
    } finally {
      client.close();
    }
  }

  static Future<List<Company>?> getCompaniesFromToken() async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.get(getUri('employer/my/company'), headers: {
        'Authorization': 'Bearer $authToken',
      });
      if (response.statusCode != 200) return null;
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return jsonBody['companies']
          .map<Company>((company) => Company.fromJson(company))
          .toList();
    } finally {
      client.close();
    }
  }

  static Future<bool> uploadJobOffer(
      String employerId, String companyId, JobOffer jobOffer) async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.post(
          getUri('employer/$employerId/job-offer/$companyId'),
          headers: {
            'Authorization': 'Bearer $authToken',
            "Content-Type": "application/json"
          },
          body: jsonEncode(jobOffer.toJson()));
      if (response.statusCode != 201) return false;
      return true;
    } finally {
      client.close();
    }
  }

  static Future<List<Tag>> getTags() async {
    var client = http.Client();
    try {
      var response = await client.get(getUri('tag'));
      List<Tag> tags = [];
      for (var tag in jsonDecode(response.body)) {
        tags.add(Tag.fromJson(tag));
      }
      return tags;
    } finally {
      client.close();
    }
  }

  static Future<void> addTags(List<Tag> tags) async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return;
    var client = http.Client();
    try {
      var response = await client.patch(getUri('extra/add/tags'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(tags.map((e) => e.id).toList()));
    } catch (e) {
      if (kDebugMode) print("add tags error: $e");
    } finally {
      client.close();
    }
  }

  static Future<Company?> getCompanyById(int id) async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.get(
        getUri('company/$id'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
      );
      Company company = Company.fromJson(jsonDecode(response.body));
      return company;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    } finally {
      client.close();
    }
  }

  static Future<bool> applyToJobOffer(int jobOfferId) async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) false;
    var client = http.Client();
    try {
      var response = await client.post(
        getUri('extra-job-request/$jobOfferId'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode != 201) return false;
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    } finally {
      client.close();
    }
  }

  static Future<List<JobOfferRequest>?> getMyJobOffers() async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.get(
        getUri("employer/my/jobOffers/requests"),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
      List<JobOfferRequest> jobOffers = [];
      for (var jobOffer in jsonDecode(response.body)) {
        jobOffers.add(JobOfferRequest.fromJson(jobOffer));
      }
      return jobOffers;
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    } finally {
      client.close();
    }
  }

  static Future<bool> acceptRequest(String requestId) async {
    final authToken = await Prefs.getString('authToken');
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.patch(
        getUri("employer/accept/request/$requestId"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode != 200) return false;
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    } finally {
      client.close();
    }
  }

  static Future<ExtraStats?> getStatsExtra() async {
    final authToken = await Globals.authToken();
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.get(
        getUri("extra/statistics"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      var stats = ExtraStats.fromJson(jsonDecode(response.body));
      return stats;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    } finally {
      client.close();
    }
  }

  static Future<EmployerStats?> getStatsEmployer() async {
    final authToken = await Globals.authToken();
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.get(
        getUri("employer/statistics"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      var stats = EmployerStats.fromJson(jsonDecode(response.body));
      return stats;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    } finally {
      client.close();
    }
  }

  static Future<UserWithRequests?> getExtraRequests() async {
    final authToken = await Globals.authToken();
    if (authToken == null) return null;
    var client = http.Client();
    try {
      var response = await client.get(
        getUri("extra/with/request"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      var requests = UserWithRequests.fromJson(jsonDecode(response.body));
      return requests;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    } finally {
      client.close();
    }
  }

  static Future<bool> confirmWork(String requestId) async {
    final authToken = await Globals.authToken();
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.patch(
        getUri("employer/comfirm-work/$requestId"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    } finally {
      client.close();
    }
  }

  static Future<bool> finishWork(String requestId, String code) async {
    final authToken = await Globals.authToken();
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.patch(
        getUri("employer/finish-work/$requestId/$code"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    } finally {
      client.close();
    }
  }

  static Future<bool> sendProblem(String requestId) async {
    final authToken = await Globals.authToken();
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.patch(
        getUri("mailing/send-problem/$requestId"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    } finally {
      client.close();
    }
  }

  static Future<bool> changeFcmToken(String deviceId, String fcmToken) async {
    final authToken = await Globals.authToken();
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.post(
        getUri("user/device/check"),
        body: {
          'device_id': deviceId,
          'fcm_token': fcmToken,
          'device_language': Globals.getLocale()
        },
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print("$e");
      return false;
    } finally {
      client.close();
    }
  }

  static Future<bool> sendNotification() async {
    final authToken = await Globals.authToken();
    if (authToken == null) return false;
    var client = http.Client();
    try {
      var response = await client.get(
        Uri.parse(
            "https://izzup-api-pfktdq573a-od.a.run.app/api/notification/send"),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    } finally {
      client.close();
    }
  }
}
