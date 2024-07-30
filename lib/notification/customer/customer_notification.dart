import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'remote_messages/remote_messages_cubit.dart';

class CustomerNotificationPage extends StatelessWidget {
  const CustomerNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build customer notification');
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
      ),
      body: BlocProvider.value(
        value: context.read<RemoteMessages>(),
        child: Builder(builder: (context) {
          return _remoteMessages();
        }),
      ),
    );
  }

  Widget _remoteMessages() {
    return BlocBuilder<RemoteMessages, RemoteMessagesState>(
      builder: (context, state) {
        if (state is RemoteMessagesLoaded) {
          final messages = state.messages;

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Text('${message.notification?.title}'),
                subtitle: Text('${message.notification?.body}'),
                trailing: Text(message.sentTime.toString()),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
