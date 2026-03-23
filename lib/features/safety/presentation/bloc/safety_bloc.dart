import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:secure_me/features/safety/domain/models.dart';
import 'dart:async';

// Events
abstract class SafetyEvent extends Equatable {
  const SafetyEvent();
  @override
  List<Object?> get props => [];
}

class ActivateEmergency extends SafetyEvent {
  final LocationModel location;
  const ActivateEmergency(this.location);
  @override
  List<Object?> get props => [location];
}

class CancelEmergency extends SafetyEvent {}

class UpdateSignalStage extends SafetyEvent {
  final SignalStage stage;
  const UpdateSignalStage(this.stage);
  @override
  List<Object?> get props => [stage];
}

class AcceptEmergency extends SafetyEvent {
  final String helperId;
  const AcceptEmergency(this.helperId);
  @override
  List<Object?> get props => [helperId];
}

class DeclineEmergency extends SafetyEvent {
  final String helperId;
  const DeclineEmergency(this.helperId);
  @override
  List<Object?> get props => [helperId];
}

class ReceiveSignalUpdate extends SafetyEvent {
  final List<String> responderIds;
  const ReceiveSignalUpdate(this.responderIds);
  @override
  List<Object?> get props => [responderIds];
}

// States
class SafetyState extends Equatable {
  final SignalStatus status;
  final SignalStage stage;
  final List<String> responderIds;
  final LocationModel? victimLocation;
  final String? activeSignalId;

  const SafetyState({
    this.status = SignalStatus.pending,
    this.stage = SignalStage.stage1,
    this.responderIds = const [],
    this.victimLocation,
    this.activeSignalId,
  });

  SafetyState copyWith({
    SignalStatus? status,
    SignalStage? stage,
    List<String>? responderIds,
    LocationModel? victimLocation,
    String? activeSignalId,
  }) {
    return SafetyState(
      status: status ?? this.status,
      stage: stage ?? this.stage,
      responderIds: responderIds ?? this.responderIds,
      victimLocation: victimLocation ?? this.victimLocation,
      activeSignalId: activeSignalId ?? this.activeSignalId,
    );
  }

  @override
  List<Object?> get props => [status, stage, responderIds, victimLocation, activeSignalId];
}

// BLoC
class SafetyBloc extends Bloc<SafetyEvent, SafetyState> {
  Timer? _stageTimer;

  SafetyBloc() : super(const SafetyState()) {
    on<ActivateEmergency>((event, emit) {
      emit(state.copyWith(
        status: SignalStatus.sent,
        stage: SignalStage.stage1,
        victimLocation: event.location,
        activeSignalId: 'sig_${DateTime.now().millisecondsSinceEpoch}',
        responderIds: [],
      ));

      // Simulate Stage 2 after 15 seconds
      _stageTimer?.cancel();
      _stageTimer = Timer(const Duration(seconds: 15), () {
        add(const UpdateSignalStage(SignalStage.stage2));
      });
      
      // Simulate responders
      _simulateResponders();
    });

    on<CancelEmergency>((event, emit) {
      _stageTimer?.cancel();
      emit(const SafetyState()); // Reset
    });

    on<UpdateSignalStage>((event, emit) {
      emit(state.copyWith(stage: event.stage));
    });

    on<ReceiveSignalUpdate>((event, emit) {
      emit(state.copyWith(responderIds: event.responderIds));
    });

    on<AcceptEmergency>((event, emit) {
      final updatedResponders = List<String>.from(state.responderIds);
      if (!updatedResponders.contains(event.helperId)) {
        updatedResponders.add(event.helperId);
      }
      emit(state.copyWith(responderIds: updatedResponders));
    });

    on<DeclineEmergency>((event, emit) {
      // Logic for decline if needed
    });
  }

  void _simulateResponders() {
    // Add responders periodically to see update on UI
    Future.delayed(const Duration(seconds: 5), () {
      if (state.status == SignalStatus.sent) {
        add(const ReceiveSignalUpdate(['helper1', 'helper2']));
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
       if (state.status == SignalStatus.sent) {
        add(const ReceiveSignalUpdate(['helper1', 'helper2', 'helper3', 'police1']));
      }
    });
  }

  @override
  Future<void> close() {
    _stageTimer?.cancel();
    return super.close();
  }
}
