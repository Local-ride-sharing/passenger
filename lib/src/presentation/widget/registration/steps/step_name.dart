import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class NameStep extends StatefulWidget {
  final String name;
  final Function(String) onSave;

  NameStep({
    required this.onSave,
    required this.name,
  });

  @override
  _NameStepState createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  late String name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyles.body(context: context, color: theme.textColor),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (val) {
                      widget.onSave(val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.secondaryColor,
                      isDense: true,
                      labelText: "Enter your name *",
                      labelStyle: TextStyles.caption(context: context, color: theme.primaryColor),
                      hintText: "ex - John doe",
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
