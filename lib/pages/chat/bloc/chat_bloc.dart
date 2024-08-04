import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:mostaql/repos/chat_repo.dart';

import 'chat_state.dart';

class ChatAiBloc extends Cubit<ChatAiState> {
  ChatAiBloc({
    required this.authRepo,
    required this.chatRepo,
  }) : super(const ChatAiState());

  final AuthRepo authRepo;
  final ChatAiRepo chatRepo;

  sendMassageToAi({required String massage}) async {
    emit(
      state.copyWith(
        sendAiChatMassageState: state.sendAiChatMassageState.asLoading(),
      ),
    );
    final f = await chatRepo.sendAiChatMassage(
      message: massage,
    );
    await f.fold(
      (l) async {
        emit(
          state.copyWith(
            sendAiChatMassageState: state.sendAiChatMassageState.asLoadingFailed(l, false),
          ),
        );

        debugPrint(state.sendAiChatMassageState.error.toString());
        debugPrint(state.sendAiChatMassageState.success.toString());
      },
      (r) async {
        emit(
          state.copyWith(
            sendAiChatMassageState: state.sendAiChatMassageState.asLoadingSuccess(
              success: true,
              contactList: r.contacts,
            ),
          ),
        );
      },
    );
  }
}
