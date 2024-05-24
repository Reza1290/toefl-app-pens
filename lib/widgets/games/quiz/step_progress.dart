import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toefl/routes/route_key.dart';
import 'package:toefl/utils/colors.dart';
import 'package:toefl/utils/custom_text_style.dart';
import 'package:toefl/utils/hex_color.dart';
import 'package:toefl/widgets/quiz/modal/modal_confirmation.dart';

class StepProgress extends StatefulWidget {
  final int currentStep;
  final int steps;
  final String quizType;

  const StepProgress(
      {super.key,
      required this.currentStep,
      required this.steps,
      required this.quizType});

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  double widthProgress = 0;
  List randomWordsList = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _onSizeWidget();
  }

  @override
  void didUpdateWidget(covariant StepProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onSizeWidget();
  }

  void _onSizeWidget() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size != null && widget.steps > 1) {
        setState(() {
          Size size = context.size!;
          widthProgress = size.width / (widget.steps - 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ModalConfirmation(
                      message: "Are you sure want to abort this quiz?",
                      leftTitle: "Cancel",
                      rightTitle: "Confirm",
                      leftFunction: () => Navigator.pop(context),
                      rightFunction: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteKey.main,
                        (route) => false,
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: const Icon(
                  Icons.close,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 9,
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      width: widthProgress * widget.currentStep,
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: HexColor(mariner800),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // LinearProgressIndicator(
                    //     value: randomWordsList.length / 10,
                    //     color: HexColor(mariner800),
                    //     borderRadius: BorderRadius.circular(8)),
                  ],
                ),
                decoration: BoxDecoration(
                  color: HexColor(neutral40),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.quizType}: Questions ${(widget.currentStep + 1).toInt()} of ${widget.steps.toInt()}',
                style: CustomTextStyle.bold18.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
