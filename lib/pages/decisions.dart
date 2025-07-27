import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MakingDecisions extends StatefulWidget {
  const MakingDecisions({super.key});

  @override
  MakingDecisionsState createState() => MakingDecisionsState();
}

class MakingDecisionsState extends State<MakingDecisions> {
  List<String> options = [];
  String decisionMade = "";
  bool decisionClicked = false;
  late int randomIndex;
  List<FocusNode> focusNodes = [];
  List<TextEditingController> controllers = [];

  ChooseRandom(List list) {
    final random = Random();
    int randomIndex = random.nextInt(options.length);
    return list[randomIndex];
  }

  void decision() {
    options.removeWhere((item) => [''].contains(item));
    String randomOption = ChooseRandom(options);
    setState(() {
      decisionMade = randomOption;
      decisionClicked = true;
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton.filled(
        onPressed: () async {
          controllers.clear();
          controllers.insert(0, TextEditingController());
          options.clear();
          options.insert(0, "");
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
                                    controller: controllers[index],
                                    focusNode: focusNodes[index],
                                    autofocus: index == options.length - 1,
                                    onSubmitted: (value) {
                                      FocusScope.of(context).nextFocus();
                                      setModalState(() {
                                        options.insert((index + 1), "");
                                        focusNodes.insert(
                                          (index + 1),
                                          FocusNode(),
                                        );
                                        controllers.insert(
                                          index + 1,
                                          TextEditingController(),
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
                                      suffix: IconButton(
                                        onPressed: () {
                                          setModalState(() {
                                            if (options.length > 1) {
                                              options.removeAt(index);
                                              controllers.removeAt(index);
                                              focusNodes.removeAt((index));
                                            }
                                          });
                                          if (index > 0 &&
                                              focusNodes.length > index - 1) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                  focusNodes[index - 1]
                                                      .requestFocus();
                                                });
                                          }
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
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
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.primary,
                              ),

                              child: const Text(
                                "Make Decision!",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
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
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    showDragHandle: true,
                    context: context,
                    builder: (BuildContext context) {
                      for (var option in options) {
                        focusNodes.add(FocusNode());
                        controllers.add(TextEditingController(text: option));
                      }

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
                                            controller: controllers[index],
                                            focusNode: focusNodes[index],
                                            autofocus:
                                                index == options.length - 1,
                                            onSubmitted: (value) {
                                              FocusScope.of(
                                                context,
                                              ).nextFocus();
                                              setModalState(() {
                                                options.insert((index + 1), "");
                                                focusNodes.insert(
                                                  (index + 1),
                                                  FocusNode(),
                                                );
                                                controllers.insert(
                                                  index + 1,
                                                  TextEditingController(),
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
                                              label: Text(
                                                "Option ${index + 1}",
                                              ),
                                              suffix: IconButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    if (options.length > 1) {
                                                      options.removeAt(index);
                                                      controllers.removeAt(
                                                        index,
                                                      );
                                                      focusNodes.removeAt(
                                                        (index),
                                                      );
                                                    }
                                                  });
                                                  if (index > 0 &&
                                                      focusNodes.length >
                                                          index - 1) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback((
                                                          _,
                                                        ) {
                                                          focusNodes[index - 1]
                                                              .requestFocus();
                                                        });
                                                  }
                                                },
                                                icon: Icon(Icons.delete),
                                              ),
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
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),

                                      child: const Text(
                                        "Make Decision!",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
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
                    for (var node in focusNodes) {
                      node.dispose();
                    }
                    focusNodes.clear();
                  });
                },
                child: Text(
                  "🎉 $decisionMade 🎉",
                  style: TextStyle(fontSize: 42),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
