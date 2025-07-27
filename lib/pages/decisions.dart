import 'dart:math';

import 'package:flutter/material.dart';

class MakingDecisions extends StatefulWidget {
  const MakingDecisions({super.key});

  @override
  MakingDecisionsState createState() => MakingDecisionsState();
}

class MakingDecisionsState extends State<MakingDecisions> {
  List<String> options = [];
  List<bool> visible = [];
  TextEditingController optionsController = TextEditingController();
  String decisionMade = "";
  bool decisionClicked = false;
  late int randomIndex;
  List<FocusNode> focusNodes = [];

  ChooseRandom(List list) {
    final random = Random();
    int randomIndex = random.nextInt(options.length);
    return list[randomIndex];
  }

  void decision() {
    String randomOption = ChooseRandom(options);
    setState(() {
      decisionMade = randomOption;
      decisionClicked = true;
    });
    options.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () async {
          if (options.isEmpty) {
            options.insert(0, "");
            visible.insert(0, true);
          }
          await showModalBottomSheet(
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SizedBox(
                      height: 500,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListView.builder(
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                while (focusNodes.length <= index) {
                                  focusNodes.add(FocusNode());
                                }
                                return ListTile(
                                  title: TextField(
                                    focusNode: focusNodes[index],
                                    autofocus: index == options.length - 1,
                                    onSubmitted: (value) {
                                      FocusScope.of(context).nextFocus();
                                      setModalState(() {
                                        options.insert((index + 1), "");
                                        visible.insert((index + 1), true);
                                        visible[index] = false;
                                        focusNodes.insert(
                                          (index + 1),
                                          FocusNode(),
                                        );
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            focusNodes[index + 1]
                                                .requestFocus();
                                          });
                                    },
                                    onChanged: (value) {
                                      options[index] = value;
                                    },
                                    decoration: InputDecoration(
                                      label: Text("Option ${index + 1}"),
                                      suffix: visible[index]
                                          ? IconButton(
                                              onPressed: () {
                                                setModalState(() {
                                                  options.insert(
                                                    (index + 1),
                                                    "",
                                                  );
                                                  visible.insert(
                                                    (index + 1),
                                                    true,
                                                  );
                                                  visible[index] = false;
                                                  focusNodes.insert(
                                                    (index + 1),
                                                    FocusNode(),
                                                  );
                                                });
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                      focusNodes[index + 1]
                                                          .requestFocus();
                                                    });
                                              },
                                              icon: Icon(Icons.add),
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              decision();
                            },
                            child: const Text("Make Decision!"),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ).whenComplete(() {
            options.clear();
            for (var node in focusNodes) {
              node.dispose();
            }
            focusNodes.clear();
          });
        },
        icon: Icon(Icons.add),
      ),
      body: Visibility(
        visible: decisionClicked,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: AlignmentDirectional.center,
              child: Text(
                "🎉 $decisionMade 🎉",
                style: TextStyle(fontSize: 42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
