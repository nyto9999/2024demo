import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:house/auth/bloc/smsSignInConfirm/sms_sign_in_confirm_cubit.dart';
import 'package:house/auth/helper/custom_style.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';
import 'package:pinput/pinput.dart';

class SmsConfirmPage extends StatefulWidget {
  const SmsConfirmPage({
    super.key,
    this.confirmationResultOrVerificationId,
    required this.authUsecases,
    required this.phoneNo,
  });

  final AuthUsecases authUsecases;
  final dynamic confirmationResultOrVerificationId;
  final String phoneNo;

  @override
  State<SmsConfirmPage> createState() => _SmsConfirmPageState();
}

class _SmsConfirmPageState extends State<SmsConfirmPage> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  BlocProvider<SmsSignInConfirmCubit> _smsTextfield(PinTheme defaultPinTheme) {
    return BlocProvider(
      create: (_) => SmsSignInConfirmCubit(widget.authUsecases),
      child: BlocConsumer<SmsSignInConfirmCubit, SmsSignInConfirmState>(
        listener: (context, state) {
          switch (state) {
            case SmsSignInConfirmSuccess():
              EasyLoading.dismiss();
              context.go('/');
            case SmsSignInConfirmLoading():
              EasyLoading.show(status: '驗證中...');
            case SmsSignInConfirmFailure():
              EasyLoading.dismiss();
              setState(() => _errorMessage = state.error);
            default:
          }
        },
        builder: (context, state) {
          return FractionallySizedBox(
            widthFactor: 1,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (index) => const SizedBox(width: 8),
                      hapticFeedbackType: HapticFeedbackType.heavyImpact,
                      onChanged: (value) async {
                        context
                            .read<SmsSignInConfirmCubit>()
                            .confirmSmsSignInCode(
                                smsCode: value,
                                result:
                                    widget.confirmationResultOrVerificationId);
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Text _phoneNoTitleSmall(BuildContext context) {
    return Text(
      widget.phoneNo,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.titleSmall!.fontSize?.r,
        color: Colors.black87,
      ),
    );
  }

  Text _titleSmallText(BuildContext context) {
    return Text(
      '請輸入6位數驗證碼',
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize?.r,
          color: Colors.black45),
    );
  }

  Text _titleLargeText(BuildContext context) {
    return Text(
      '簡訊認證',
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleLarge!.fontSize?.r,
          color: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22.r,
        color: Theme.of(context).buttonTheme.colorScheme!.primary,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black12),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _titleLargeText(context),
          Custom.gap,
          Custom.gap,
          _titleSmallText(context),
          Custom.gap,
          _phoneNoTitleSmall(context),
          Custom.gap,
          Custom.gap,
          _smsTextfield(defaultPinTheme),
        ],
      ),
    );
  }
}
