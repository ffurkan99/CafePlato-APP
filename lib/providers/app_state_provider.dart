import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/branch.dart';

class AppStateProvider extends ChangeNotifier {
  Branch _selectedBranch = MockData.branches.first;

  // Notification settings
  bool _campaignNotifications = true;
  bool _orderStatusNotifications = true;
  bool _newProductNotifications = false;
  bool _cafePointNotifications = true;

  Branch get selectedBranch => _selectedBranch;

  bool get campaignNotifications => _campaignNotifications;
  bool get orderStatusNotifications => _orderStatusNotifications;
  bool get newProductNotifications => _newProductNotifications;
  bool get cafePointNotifications => _cafePointNotifications;

  void setSelectedBranch(Branch branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  void setCampaignNotifications(bool value) {
    _campaignNotifications = value;
    notifyListeners();
  }

  void setOrderStatusNotifications(bool value) {
    _orderStatusNotifications = value;
    notifyListeners();
  }

  void setNewProductNotifications(bool value) {
    _newProductNotifications = value;
    notifyListeners();
  }

  void setCafePointNotifications(bool value) {
    _cafePointNotifications = value;
    notifyListeners();
  }
}
