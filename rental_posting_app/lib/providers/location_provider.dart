import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  List<Location> _locations = [];
  List<Location> _qhuyen = [];
  List<Location> _phuongxa = [];
  List<Location> _phuongxaByQhuyen = [];
  bool _isLoading = false;
  String? _error;

  List<Location> get locations => _locations;
  List<Location> get qhuyen => _qhuyen;
  List<Location> get phuongxa => _phuongxa;
  List<Location> get phuongxaByQhuyen => _phuongxaByQhuyen;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHotLocations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _locations = await _locationService.fetchHotLocations(onlyNoibat: true);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchQhuyenLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _qhuyen = await _locationService.fetchHotLocations(qhuyen: true);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPhuongXaLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _phuongxaByQhuyen =
          await _locationService.fetchHotLocations(phuongxa: true);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPhuongXaByQhuyen(int idQhuyen) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _phuongxaByQhuyen =
          await _locationService.fetchPhuongXaByQhuyen(idQhuyen);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
