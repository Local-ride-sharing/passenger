import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/app_router.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Stack(
            children: [
              Center(child: Image.asset("images/logo.png", width: 144, height: 144, fit: BoxFit.contain)),
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        style: TextStyles.body(context: context, color: theme.textColor),
                        validator: (val) => (val ?? "").trim().isEmpty
                            ? "required"
                            : (val ?? "").trim().length == 11
                                ? null
                                : "invalid phone number",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.secondaryColor,
                          isDense: true,
                          labelText: "Phone number *",
                          labelStyle: TextStyles.caption(context: context, color: theme.primaryColor),
                          hintText: "ex- 01XXXXXXXXX",
                          hintStyle: TextStyles.body(context: context, color: theme.hintColor),
                          errorStyle:
                              TextStyles.caption(context: context, color: theme.errorColor).copyWith(fontSize: 9, height: 1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.primaryColor, width: 4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          errorText: null,
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.errorColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: theme.errorColor, width: 4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Navigator.of(context).pushNamed(AppRouter.otp, arguments: "+88${_phoneNumberController.text}");
                            }
                          },
                          child: Text("Login".toUpperCase(), style: TextStyles.title(context: context, color: theme.textColor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
