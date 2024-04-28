import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/count_down_cubit.dart';
import 'package:passenger/src/business_logic/login/existence_cubit.dart';
import 'package:passenger/src/business_logic/login/generate_otp_cubit.dart';
import 'package:passenger/src/business_logic/login/verify_otp_cubit.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  OTPVerificationScreen(this.phoneNumber);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController = TextEditingController();

  late String verificationId;

  @override
  void initState() {
    BlocProvider.of<GenerateOTPCubit>(context).generateOTP(widget.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(automaticallyImplyLeading: true),
          body: Container(
            padding: const EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: kToolbarHeight),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: "A ", style: TextStyles.caption(context: context, color: theme.textColor)),
                          TextSpan(text: "6-digits", style: TextStyles.body(context: context, color: theme.accentColor)),
                          TextSpan(
                              text: " verification code is sent to ",
                              style: TextStyles.caption(context: context, color: theme.textColor)),
                          TextSpan(
                              text: widget.phoneNumber, style: TextStyles.body(context: context, color: theme.accentColor)),
                          TextSpan(
                            text: ".\n Please input the valid verification code below to identify your phone number.",
                            style: TextStyles.caption(context: context, color: theme.textColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * .75,
                      child: TextFormField(
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        style: TextStyles.headline(context: context, color: theme.textColor),
                        validator: (val) => (val ?? "").trim().isEmpty ? '' : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.secondaryColor,
                          isDense: true,
                          hintText: "* * * * * *",
                          hintStyle: TextStyles.headline(context: context, color: theme.hintColor),
                          errorStyle:
                              TextStyles.caption(context: context, color: theme.errorColor).copyWith(fontSize: 0, height: 0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.primaryColor, width: 4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          errorText: null,
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.errorColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: theme.errorColor, width: 4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    BlocConsumer<GenerateOTPCubit, GenerateOTPState>(
                      listener: (listenerContext, state) {
                        if (state is GenerateOTPSuccess) {
                          verificationId = state.verificationId;
                          if (state.credential != null) {
                            BlocProvider.of<VerifyOTPCubit>(context).verifyOTPWithCredential(state.credential!);
                          }
                          BlocProvider.of<CountDownCubit>(context).initiate(60);
                          BlocProvider.of<CountDownCubit>(context).startCountDown();
                        }
                      },
                      builder: (builderContext, state) {
                        if (state is GenerateOTPError) {
                          return Container(
                            width: MediaQuery.of(context).size.width * .75,
                            child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<GenerateOTPCubit>(context).generateOTP(widget.phoneNumber);
                              },
                              child: Text("Failed".toUpperCase(),
                                  style: TextStyles.title(context: context, color: theme.textColor)),
                            ),
                          );
                        } else if (state is GenerateOTPNetworking) {
                          return Container(
                            width: MediaQuery.of(context).size.width * .75,
                            child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<CountDownCubit>(context).initiate(60);
                                BlocProvider.of<GenerateOTPCubit>(context).generateOTP(widget.phoneNumber);
                              },
                              child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
                            ),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width * .75,
                            child: BlocConsumer<VerifyOTPCubit, VerifyOTPState>(
                              listener: (context, state) {
                                if (state is VerifyOTPSuccess) {
                                  BlocProvider.of<ExistenceCubit>(context).check();
                                }
                              },
                              builder: (context, state) {
                                if (state is VerifyOTPError) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        BlocProvider.of<VerifyOTPCubit>(context)
                                            .verifyOTP(_verificationCodeController.text, verificationId);
                                      }
                                    },
                                    child: Text("Failed to verify".toUpperCase(),
                                        style: TextStyles.title(context: context, color: theme.textColor)),
                                  );
                                } else if (state is VerifyOTPNetworking) {
                                  return ElevatedButton(
                                    onPressed: () {},
                                    child: Center(
                                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
                                  );
                                } else if (state is VerifyOTPSuccess) {
                                  return BlocConsumer<ExistenceCubit, ExistenceState>(
                                    listener: (context, state) {
                                      if (state is ExistenceSuccess) {
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                            state.exists ? AppRouter.initialization : AppRouter.registration, (route) => false);
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is ExistenceError) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState?.validate() ?? false) {
                                              BlocProvider.of<VerifyOTPCubit>(context)
                                                  .verifyOTP(_verificationCodeController.text, verificationId);
                                            }
                                          },
                                          child: Text("Try again".toUpperCase(),
                                              style: TextStyles.title(context: context, color: theme.textColor)),
                                        );
                                      } else if (state is ExistenceNetworking) {
                                        return ElevatedButton(
                                          onPressed: () {},
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blue))),
                                        );
                                      } else if (state is ExistenceSuccess) {
                                        return ElevatedButton(
                                          onPressed: () {},
                                          child: Center(child: Icon(Icons.check, color: theme.backgroundColor)),
                                        );
                                      } else {
                                        return ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState?.validate() ?? false) {
                                              BlocProvider.of<VerifyOTPCubit>(context)
                                                  .verifyOTP(_verificationCodeController.text, verificationId);
                                            }
                                          },
                                          child: Text("Verified".toUpperCase(),
                                              style: TextStyles.title(context: context, color: theme.textColor)),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        BlocProvider.of<VerifyOTPCubit>(context)
                                            .verifyOTP(_verificationCodeController.text, verificationId);
                                      }
                                    },
                                    child: Text("Verify".toUpperCase(),
                                        style: TextStyles.title(context: context, color: theme.textColor)),
                                  );
                                }
                              },
                            ),
                          );
                        }
                      },
                    ),
                    BlocBuilder<CountDownCubit, int>(
                      builder: (context, state) {
                        return Container(
                          margin: EdgeInsets.only(top: 16),
                          child: state > 0
                              ? RichText(
                                  text: TextSpan(
                                    style: TextStyles.caption(context: context, color: theme.hintColor),
                                    children: <TextSpan>[
                                      TextSpan(text: "Code sent. Resend code in "),
                                      TextSpan(
                                        text: "${state}s",
                                        style: TextStyles.caption(context: context, color: theme.accentColor),
                                      ),
                                    ],
                                  ),
                                )
                              : RichText(
                                  text: TextSpan(
                                    style: TextStyles.caption(context: context, color: theme.hintColor),
                                    children: <TextSpan>[
                                      TextSpan(text: "Didn't received code?\t\t"),
                                      TextSpan(
                                        text: "Resend code",
                                        style: TextStyles.body(context: context, color: theme.accentColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            BlocProvider.of<GenerateOTPCubit>(context).generateOTP(widget.phoneNumber);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
