import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/chat_ai_model.dart';

class ChatAiState extends Equatable {
  final SendAiChatMassageState sendAiChatMassageState;

  copyWith({
    SendAiChatMassageState? sendAiChatMassageState,
  }) {
    return ChatAiState(
      sendAiChatMassageState: sendAiChatMassageState ?? this.sendAiChatMassageState,
    );
  }

  const ChatAiState({
    this.sendAiChatMassageState = const SendAiChatMassageState(),
  });

  @override
  List<Object?> get props => [
        sendAiChatMassageState,
      ];
}

class SendAiChatMassageState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<AiContact>? contactList;

  const SendAiChatMassageState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.contactList,
  });

  SendAiChatMassageState asLoading() => const SendAiChatMassageState(
        loadingState: LoadingState.loading(),
      );

  SendAiChatMassageState asLoadingSuccess({
    bool? success,
    bool? isNewUser,
    List<AiContact>? contactList,
  }) =>
      SendAiChatMassageState(
        success: success,
        contactList: contactList,
      );

  SendAiChatMassageState asLoadingFailed(String error, bool success) => SendAiChatMassageState(
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        contactList,
      ];
}
