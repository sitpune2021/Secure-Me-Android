import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationViewModel extends Notifier<bool> {
  @override
  bool build() {
    // Initial state: Background Tracking is off
    return false;
  }

  void toggleBackgroundTracking(bool value) {
    state = value;
    // Here you would also trigger any background logic or call a repository
  }
}

final locationViewModelProvider = NotifierProvider<LocationViewModel, bool>(LocationViewModel.new);
