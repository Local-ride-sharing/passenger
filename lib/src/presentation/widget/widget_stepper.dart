import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passenger/src/business_logic/theme_cubit.dart';
import 'package:passenger/src/data/model/custom_step.dart';
import 'package:passenger/src/utils/text_styles.dart';
import 'package:passenger/src/utils/theme_helper.dart';

class StepperWidget extends StatefulWidget {
  final List<CustomStep> steps;
  final int currentIndex;
  final Function onBack;
  final Function onNext;

  StepperWidget({required this.steps, required this.currentIndex, required this.onBack, required this.onNext});

  @override
  _StepperWidgetState createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = ThemeHelper(state.value);
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: theme.secondaryColor,
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    controller: controller,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    physics: RangeMaintainingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.steps.length,
                    separatorBuilder: (_, __) {
                      return Container(
                        width: 54,
                        height: 1,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(color: theme.hintColor),
                      );
                    },
                    itemBuilder: (context, index) {
                      final CustomStep step = widget.steps[index];
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            child:
                                Icon(step.icon, color: widget.currentIndex == index ? theme.backgroundColor : theme.iconColor),
                            backgroundColor: widget.currentIndex == index ? theme.primaryColor : theme.secondaryColor,
                            radius: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            step.title,
                            style: TextStyles.body(
                                    context: context,
                                    color: widget.currentIndex == index ? theme.primaryColor : theme.hintColor)
                                .copyWith(fontWeight: widget.currentIndex == index ? FontWeight.bold : FontWeight.normal),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                top: 0,
                right: 0,
                left: 0,
              ),
              Positioned(
                child: widget.steps[widget.currentIndex].content,
                top: kToolbarHeight,
                bottom: kToolbarHeight,
                right: 0,
                left: 0,
              ),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: kToolbarHeight,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: theme.secondaryColor,
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: widget.currentIndex > 0,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.onBack();
                            controller.jumpTo((widget.currentIndex - 1) * 112);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.secondaryColor, padding: EdgeInsets.symmetric(horizontal: 16)),
                          icon: Icon(Icons.arrow_back_rounded, color: theme.primaryColor),
                          label: Text("Back", style: TextStyles.body(context: context, color: theme.primaryColor)),
                        ),
                      ),
                      Visibility(
                        visible: widget.currentIndex < widget.steps.length - 1,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.onNext();
                            controller.jumpTo((widget.currentIndex + 1) * 112);
                          },
                          icon: Icon(
                            widget.currentIndex == (widget.steps.length - 2) ? Icons.check : Icons.arrow_forward_rounded,
                            color: theme.primaryColor,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.secondaryColor, padding: EdgeInsets.symmetric(horizontal: 16)),
                          label: Text(
                            widget.currentIndex == (widget.steps.length - 2) ? "Finish" : "Next",
                            style: TextStyles.body(context: context, color: theme.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: 0,
                right: 0,
                left: 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
