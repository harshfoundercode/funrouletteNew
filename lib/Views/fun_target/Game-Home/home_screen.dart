// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funroullete_new/Constant/shared_preference.dart';
import 'package:funroullete_new/Constant/audio-player.dart';
import 'package:funroullete_new/Model/result-history-model.dart';
import 'package:funroullete_new/Provider/result_history_provider.dart';
import 'package:funroullete_new/Provider/result_provider.dart';
import 'package:funroullete_new/Views/fun_target/Game-Home/big_chakra.dart';
import 'package:funroullete_new/Views/fun_target/Game-Home/blinking.dart';
import 'package:funroullete_new/api/bet-service.dart';
import 'package:funroullete_new/api/take-winning-amount-service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../Constant/assets.dart';
import '../../../Constant/color.dart';
import '../../../Provider/profile_provider.dart';
import '../../../Utils/message_utils.dart';
import '../../../main.dart';
import '../../Constant-Widgets/Container/Container_widget.dart';
import '../../Constant-Widgets/TextStyling/smallTextStyle.dart';
import '../../Constant-Widgets/TextStyling/titleStyle.dart';

class ButtonChips {
  final String buttonColor;
  final String price;
  ButtonChips(this.buttonColor, this.price);
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  // late FocusNode _focusNode1;
  // late FocusNode _focusNode2;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();


  WheelSpinController wheelSpinController = WheelSpinController();
  int selectedChip = 0;
  int amount = 0;
  int result = 0;
  int placeBetValue = 0;
  int winnerAmount = 0;
  int totalBetApplied = 0;
  int countdownSeconds = 60;
  bool isBetOk = false;
  bool isBetAllowed = true;
  bool isViewResult = false;
  bool reach5SecondTimer = false;
  bool needToTake = false;
  bool? isTimerDone = true;
  Timer? countdownTimer;
  List<BetOnNumbers> betNumbersList = [
    BetOnNumbers(number: 1, betApplied: 0),
    BetOnNumbers(number: 2, betApplied: 0),
    BetOnNumbers(number: 3, betApplied: 0),
    BetOnNumbers(number: 4, betApplied: 0),
    BetOnNumbers(number: 5, betApplied: 0),
    BetOnNumbers(number: 6, betApplied: 0),
    BetOnNumbers(number: 7, betApplied: 0),
    BetOnNumbers(number: 8, betApplied: 0),
    BetOnNumbers(number: 9, betApplied: 0),
    BetOnNumbers(number: 0, betApplied: 0),
  ];
  List<BetOnNumbers> getBetOnNumber = [];
  List<BetOnNumbers> repeatBetList = [];

  List<ButtonChips> chipsButtonListLeft = [
    ButtonChips(Graphics.onePoint, "1"),
    ButtonChips(Graphics.fivePoint, "5"),
    ButtonChips(Graphics.tenPoint, "10"),
    ButtonChips(Graphics.fiftyPoint, "50"),
  ];
  List<ButtonChips> chipsButtonListRight = [
    ButtonChips(Graphics.skybutton, "100"),
    ButtonChips(Graphics.fiveHPoint, "500"),
    ButtonChips(Graphics.OneTPoint, "1000"),
    ButtonChips(Graphics.fiveTPoint, "5000"),
  ];

  stopAudio() async {
    await audioPlayer.pause();
  }

  Future<void> startCountdown() async {
    DateTime now = DateTime.now().toUtc();
    int initialSeconds = 60 - now.second;
    setState(() {
      countdownSeconds = initialSeconds;
    });
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateUI(timer);
    });
  }

  void updateUI(Timer timer) {
    setState(() {
      if (countdownSeconds == 55) {
        setState(() {
          isTimerDone = true;
        });
        stopNetworkSound();
        matchResultWithUserBet();
      } else if (countdownSeconds == 59) {
        setState(() {
          int resultValue = 20 - result * 2;
          wheelSpinController.stopWheel(resultValue);
        });
      } else if (countdownSeconds == 10) {
        setState(() {
          reach5SecondTimer = false;
          isBetAllowed = false;
        });
        if (isBetOk == false &&
            getBetOnNumber.isNotEmpty &&
            totalBetApplied != 0) {
          hitInsertBetApiAndInsertBetData();
        } else {
          if (kDebugMode) {
            print("bet already placed");
          }
        }
      } else if (countdownSeconds == 15) {
        setState(() {
          reach5SecondTimer = true;
        });
      } else if (countdownSeconds == 1) {
        pauseNetworkSound();
        // playNetworkSound("${AppUrls.BaseUrl}assets/music/movechakra.mp3");
      } else if (countdownSeconds == 0) {
        SharedPreferencesUtil.clearLastResult();
        wheelSpinController.startWheel();
        setState(() {
          isTimerDone = false;
          isViewResult = false;
          isBetAllowed = true;
          repeatBetList = List.from(getBetOnNumber);
        });
        _fetchApiData();
        setState(() {
          reach5SecondTimer = false;
        });
      }
      countdownSeconds = (countdownSeconds - 1) % 60;
    });
  }

  hitInsertBetApiAndInsertBetData() async {
    List<Map<String, dynamic>> jsonList = getBetOnNumber.map((bet) => bet.toJson()).toList();
    await context.read<BetService>().InsertBetApi(context,jsonList).then((value) {
      setState(() {
        isBetOk = true;
      });
      if (kDebugMode) {
        print("jsonList:$jsonList");
      }
    }).catchError((err) {
      if (kDebugMode) {
        print("failed to insert");
      }
    });
  }

  void matchResultWithUserBet() {
    if (isBetOk) {
      bool foundWinner = false;
      for (BetOnNumbers bet in getBetOnNumber) {
        if (bet.number.toString() == result.toString()) {
          pauseNetworkSound();
          // playNetworkSound("https://kgfgold.in/assets/music/winnerclap.mp3");
          setState(() {
            winnerAmount = bet.betApplied * 9;
            needToTake = true;
            countdownTimer!.cancel();
            isViewResult = true;
            isBetOk = false;
          });
          Utils.toastMessage("YOU WON",context);
          _focusNode2.requestFocus();
          foundWinner = true;
          break;
        }
      }
      if (!foundWinner) {
        setState(() {
          winnerAmount = 0;
          isBetOk = false;
          selectedChip = 0;
          totalBetApplied = 0;
          for (var element in betNumbersList) {
            element.betApplied = 0;
          }
        });
        Utils.errorToastMessage("YOU LOSE",context);
      }
      getBetOnNumber.clear();
    } else {
      setState(() {
        isBetOk = false;
        winnerAmount = 0;
        selectedChip = 0;
        for (var element in betNumbersList) {
          element.betApplied = 0;
        }
      });
      getBetOnNumber.clear();
    }
  }

  Future<void> _fetchApiData() async {
    try {

      await Future.wait([
        Provider.of<ResultHistoryProvider>(context, listen: false).fetchResulthistoryData(context),
        Provider.of<ResultProvider>(context, listen: false).fetchResultData(context),
        Provider.of<ProfileProvider>(context, listen: false).fetchProfile(context),
      ]);

      final profileData = Provider.of<ProfileProvider>(context, listen: false).profile;

      if (profileData != null && profileData.wallet != "null") {
        setState(() {
          amount = int.parse(profileData.wallet);
        });
      } else {
        if (kDebugMode) {
          print("the profile data is empty");
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error fetching data: $e');
        print(stackTrace);
      }
    }
    setState(() {
      selectedChip = 0;
      for (var element in betNumbersList) {
        element.betApplied = 0;
      }
    });
  }

  betOkButtonAction() {
    if (getBetOnNumber.isNotEmpty && reach5SecondTimer == false) {
      if (isBetOk == false) {
        hitInsertBetApiAndInsertBetData();
      } else {
        Utils.snackBar("You are already confirm bet", context);
      }
    } else {
      Utils.snackBar("Must be enter bet to continue", context);
    }
  }


  void updateBetValue(int number) {
    setState(() {
      if (number >= 0 && number <= 10) {
        tapToPlaceBetOnNumberAction(number);
      }
    });
  }

  void tapToPlaceBetOnNumberAction(int index) {
    if (isBetOk == false && isBetAllowed) {
      setState(() {
        // placeBetValue = SharedPreferencesUtil.getChipsValue();
        placeBetValue = selectedChip;
        if (placeBetValue <= amount) {
          amount = amount - placeBetValue;
          betNumbersList[index].betApplied = betNumbersList[index].betApplied + placeBetValue;
          if (getBetOnNumber.isNotEmpty) {
            pauseNetworkSound();
            // playNetworkSound("https://kgfgold.in/assets/music/placechip.mp3");
            int elementIndex =
            getBetOnNumber.indexWhere((bet) => bet.number == index);

            if (elementIndex != -1) {
              pauseNetworkSound();
              // playNetworkSound("https://kgfgold.in/assets/music/placechip.mp3");
              setState(() {
                getBetOnNumber[elementIndex].betApplied += placeBetValue;
              });
            } else {
              pauseNetworkSound();
              setState(() {
                getBetOnNumber.add(
                  BetOnNumbers(number: index, betApplied: placeBetValue),
                );
              });
            }
          } else {
            pauseNetworkSound();
            // playNetworkSound("https://kgfgold.in/assets/music/placechip.mp3");
            setState(() {
              getBetOnNumber.add(
                BetOnNumbers(number: index, betApplied: placeBetValue),
              );
            });
          }
          totalBetApplied = betNumbersList.fold(0, (previousValue, element) => previousValue + element.betApplied);
        } else {
          Utils.errorToastMessage("You have low balance",context);
        }
      });
    } else {
      Utils.snackBar("bet not allowed", context);
    }
  }

  void repeatPreviousBet() {
    if (isBetOk == false &&
        repeatBetList.isNotEmpty &&
        reach5SecondTimer == false) {
      setState(() {
        getBetOnNumber = List.from(repeatBetList);
      });
      pauseNetworkSound();
      playNetworkSound("https://kgfgold.in/assets/music/placechip.mp3");
      for (var bet in getBetOnNumber) {
        if (bet.number >= 0 && bet.number <= betNumbersList.length) {
          setState(() {
            betNumbersList[bet.number].betApplied = bet.betApplied;
            totalBetApplied += bet.betApplied;
          });
        } else {}
      }
      hitInsertBetApiAndInsertBetData();
      repeatBetList.clear();
    }
  }

  @override
  void initState() {

    _focusNode1.addListener(() {
      if (!_focusNode1.hasFocus) {
        _focusNode2.requestFocus();
      }
    });

    _focusNode2.addListener(() {
      if (!_focusNode2.hasFocus) {
        _focusNode1.requestFocus();
      }
    });
    super.initState();
    startCountdown();
    _fetchApiData();
  }


  Widget sectionOne() {
    return CustomContainer(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              yellowButton(
                  Small_Text(
                    Title: amount.toString() == "null" ? "" : amount.toString(),
                    textColor: ColorConstant.textColorBrown,
                    style: GoogleFonts.dmSerifDisplay(
                      textStyle: TextStyle(
                        fontSize: width / 55,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: ColorConstant.textColorBrown,
                      ),
                    ),
                  ),
                  "Score",
                  const EdgeInsets.only(left: 10)),
              SizedBox(
                height: height / 20,
              ),
              Stack(
                children: [
                  BlinkingTimerBg(
                    isTimetoStartBlinking: reach5SecondTimer,
                  ),
                  yellowButton(
                      Small_Text(
                        Title:
                        "00 : ${countdownSeconds.toString().padLeft(2, '0')}",
                        textColor: Colors.brown,
                        fontWeight: FontWeight.bold,
                        style: TextStyle(
                            height: 0.6,
                            fontFamily: "MyFont",
                            fontSize: width / 50,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                            color: Colors.brown),
                      ),
                      "Time",
                      const EdgeInsets.only(left: 10)),
                ],
              ),
              SizedBox(
                height: height / 20,
              ),
            ],
          ),
          const Spacer(),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              yellowButton(Consumer<ResultProvider>(
                builder: (context, resultProvider, child) {
                  final resultData = resultProvider.result;
                  result = int.parse(resultData!.result);
                  if (isViewResult == true) {
                    return Small_Text(
                        Title: winnerAmount.toString() != "null"
                            ? "$winnerAmount"
                            : resultData.result,
                        style: GoogleFonts.dmSerifDisplay(
                          textStyle: TextStyle(
                            fontSize: width / 55,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textColorBrown,
                          ),
                        ));
                  } else {
                    return Small_Text(
                        Title: "0",
                        fontSize: width / 55,
                        style: GoogleFonts.dmSerifDisplay(
                          textStyle: TextStyle(
                            fontSize: width / 55,
                            fontStyle: FontStyle.normal,
                            color: ColorConstant.textColorBrown,
                          ),
                        ));
                  }
                },
              ), "Winner", const EdgeInsets.only(right: 10)),
              SizedBox(
                height: height / 20,
              ),
              yellowButton(Consumer<ResultHistoryProvider>(
                builder: (context, resultProvider, child) {
                  ResultHistoryModel? result = resultProvider.result;
                  if (result != null) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: result.data.length,
                            itemBuilder: (context, index) {
                              final lastResult = result.data[index].result;
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 310),
                                child: Small_Text(
                                    Title: lastResult.toString(),
                                    style: GoogleFonts.dmSerifDisplay(
                                      textStyle: TextStyle(
                                        fontSize: width / 58,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: ColorConstant.textColorBrown,
                                      ),
                                    )),
                              );
                            }));
                  } else {
                    return Small_Text(
                      Title: "waiting",
                      textColor: ColorConstant.textColorBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: width / 55,
                    );
                  }
                },
              ), "Last 10 Data", const EdgeInsets.only(right: 10)),
              SizedBox(
                height: height / 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sectionTwo() {
    return CustomContainer(
      padding: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.none,
      height: height / 2.4,
      widths: width / 1.2,
      image: const DecorationImage(
        image: AssetImage(Graphics.bottomBadge),
        fit: BoxFit.fill,
      ),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform(
                transform: Matrix4.identity()..rotateX(0.8),
                alignment: FractionalOffset.center,
                child: sideButtons(
                  const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      chipsButtonListLeft.length,
                          (index) => InkWell(
                        onTap: () {
                          if (!isBetOk) {
                            _focusNode1.requestFocus();
                            setState(() {
                              selectedChip = int.parse(chipsButtonListLeft[index].price);
                            });
                            // SharedPreferencesUtil.setChipsValue(selectedChip);
                          } else {
                            Utils.snackBar("Bet already placed", context);
                          }
                        },
                        child: chipButton(
                          chipsButtonListLeft[index].price,
                          chipsButtonListLeft[index].buttonColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  // InkWell(
                  //   onTap: () async {
                  //     if (needToTake) {
                  //       try {
                  //         await context
                  //             .read<WinningAmountService>()
                  //             .InsertWinningAmount(winnerAmount);
                  //         setState(() {
                  //           amount += winnerAmount;
                  //           needToTake = false;
                  //           isBetOk = false;
                  //           totalBetApplied = 0;
                  //           selectedChip = 0;
                  //           for (var element in betNumbersList) {
                  //             element.betApplied = 0;
                  //           }
                  //           startCountdown();
                  //         });
                  //       } catch (err) {
                  //         if (kDebugMode) {
                  //           print("Failed to insert winner amount");
                  //         }
                  //       }
                  //     } else {
                  //       Utils.snackBar("Must play and win to take", context);
                  //     }
                  //   },
                  //   child: BlinkingTakeOption(
                  //     isSide: "left",
                  //     isTimetoStartBlinking: needToTake,
                  //   ),
                  // ),
                  KeyboardListener(
                    focusNode: _focusNode2,
                    autofocus: true,
                    onKeyEvent: (event) async {
                      if (event is KeyDownEvent) {
                        // Handle the Space Key Press
                        if (event.logicalKey == LogicalKeyboardKey.space) {
                          // _toggleFocus(_focusNode1, _focusNode2);
                          _focusNode2.requestFocus();
                          if (needToTake) {
                            try {
                              await context.read<WinningAmountService>().InsertWinningAmount(context,winnerAmount);
                              setState(() {
                                amount += winnerAmount;
                                needToTake = false;
                                isBetOk = false;
                                totalBetApplied = 0;
                                selectedChip = 0;
                                for (var element in betNumbersList) {
                                  element.betApplied = 0;
                                }
                                startCountdown();
                              });
                            } catch (err) {
                              if (kDebugMode) {
                                print("Failed to insert winner amount");
                              }
                            }
                          } else {
                            Utils.snackBar("Must play and win to take", context);
                          }
                        }
                      }

                      if (kDebugMode) {
                        print("Key Pressed: ${event.logicalKey}");
                      }
                    },
                    child: InkWell(
                      onTap: () async {
                        // _toggleFocus(_focusNode1, _focusNode2);
                        _focusNode2.requestFocus();
                        if (needToTake) {
                          try {
                            await context
                                .read<WinningAmountService>()
                                .InsertWinningAmount(context,winnerAmount);
                            setState(() {
                              amount += winnerAmount;
                              needToTake = false;
                              isBetOk = false;
                              totalBetApplied = 0;
                              selectedChip = 0;
                              for (var element in betNumbersList) {
                                element.betApplied = 0;
                              }
                              startCountdown();
                            });
                          } catch (err) {
                            if (kDebugMode) {
                              print("Failed to insert winner amount");
                            }
                          }
                        } else {
                          Utils.snackBar("Must play and win to take", context);
                        }
                      },
                      child: BlinkingTakeOption(
                        isSide: "left",
                        isTimetoStartBlinking: needToTake,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      if (!isBetOk && !reach5SecondTimer) {
                        setState(() {
                          for (var element in betNumbersList) {
                            element.betApplied = 0;
                          }
                          getBetOnNumber.clear();
                        });
                      } else {
                        Utils.snackBar(
                            "Not allowed to cancel bet after placed", context);
                      }
                    },
                    child: BlinkingCancelRepeat(
                      isSide: "left",
                      title: "Cancel Bet",
                      isTimetoStartBlinking:
                      getBetOnNumber.isNotEmpty && !isBetOk,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform(
                transform: Matrix4.identity()..rotateX(0.8),
                alignment: FractionalOffset.center,
                child: sideButtons(
                  const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      chipsButtonListRight.length,
                          (index) => InkWell(
                        onTap: () {
                          _focusNode1.requestFocus();
                          setState(() {
                            // _toggleFocus(_focusNode2,_focusNode1);
                            selectedChip = int.parse(chipsButtonListRight[index].price);
                          });
                          // SharedPreferencesUtil.setChipsValue(selectedChip);
                        },
                        child: chipButton(
                          chipsButtonListRight[index].price,
                          chipsButtonListRight[index].buttonColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      repeatPreviousBet();
                    },
                    child: BlinkingCancelRepeat(
                      isSide: "right",
                      title: "Repeat",
                      isTimetoStartBlinking: !needToTake &&
                          getBetOnNumber.isEmpty &&
                          !isBetOk &&
                          repeatBetList.isNotEmpty,
                    ),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      betOkButtonAction();
                    },
                    child: BlinkingTakeOption(
                      isSide: "right",
                      isTimetoStartBlinking:
                      getBetOnNumber.isNotEmpty && !isBetOk,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBetItem(int index) {
    int betValue = betNumbersList[index].betApplied;
    bool isBetPlaced = betValue != 0;
    return KeyboardListener(
      focusNode: _focusNode1,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          // _toggleFocus(_focusNode2,_focusNode1);
          _focusNode1.requestFocus();
          // Detect if the key pressed is from the standard number row (0-9)
          if (event.logicalKey == LogicalKeyboardKey.digit0 ||
              event.logicalKey == LogicalKeyboardKey.digit1 ||
              event.logicalKey == LogicalKeyboardKey.digit2 ||
              event.logicalKey == LogicalKeyboardKey.digit3 ||
              event.logicalKey == LogicalKeyboardKey.digit4 ||
              event.logicalKey == LogicalKeyboardKey.digit5 ||
              event.logicalKey == LogicalKeyboardKey.digit6 ||
              event.logicalKey == LogicalKeyboardKey.digit7 ||
              event.logicalKey == LogicalKeyboardKey.digit8 ||
              event.logicalKey == LogicalKeyboardKey.digit9) {
            int number = int.parse(event.character ?? '0');
            updateBetValue(number);
            if (kDebugMode) {
              print(number);
              print("number hua keyboard se");
            }
          }
          // Detect if the key pressed is from the numeric keypad (NumLock)
          else if (event.logicalKey == LogicalKeyboardKey.numpad0 ||
              event.logicalKey == LogicalKeyboardKey.numpad1 ||
              event.logicalKey == LogicalKeyboardKey.numpad2 ||
              event.logicalKey == LogicalKeyboardKey.numpad3 ||
              event.logicalKey == LogicalKeyboardKey.numpad4 ||
              event.logicalKey == LogicalKeyboardKey.numpad5 ||
              event.logicalKey == LogicalKeyboardKey.numpad6 ||
              event.logicalKey == LogicalKeyboardKey.numpad7 ||
              event.logicalKey == LogicalKeyboardKey.numpad8 ||
              event.logicalKey == LogicalKeyboardKey.numpad9) {
            int number = int.parse(event.character ?? '0');
            updateBetValue(number);
          }

          if (kDebugMode) {
            print("Key Pressed number : ${event.logicalKey}");
          }
        }
      },
      child: InkWell(
        onTap: () {
          // _toggleFocus(_focusNode2,_focusNode1);
          _focusNode1.requestFocus();
          tapToPlaceBetOnNumberAction(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
              widths: width / 13,
              height: width / 35,
              alignment: Alignment.center,
              image: const DecorationImage(
                image: AssetImage(
                  Graphics.bottomsqrButton,
                ),
                fit: BoxFit.fill,
              ),
              child: Small_Text(
                  alignment: Alignment.center,
                  Title: isBetPlaced ? "$betValue" : "",
                  fontSize: width / 60,
                  style: GoogleFonts.dmSerifDisplay(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width / 60,
                      fontStyle: FontStyle.normal,
                      color: ColorConstant.textColorBrown,
                    ),
                  )),
            ),
            CustomContainer(
              padding: const EdgeInsets.all(5),
              widths: width / 16,
              height: width / 20,
              image: const DecorationImage(
                image: AssetImage(
                  Graphics.bottomcircleButton,
                ),
                fit: BoxFit.fill,
              ),
              child: BlinkingWinnerNumber(
                isTimetoStartBlinking: needToTake == true && result - 1 == index
                    ? needToTake
                    : false,
                index: betNumbersList[index].number.toString(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: betValue == 0 ? Colors.transparent : Colors.green,
                  ),
                  // betValue == 0
                  //     ? Colors.transparent
                  //     : betValue < 5
                  //         ? Colors.green
                  //         : betValue < 10
                  //             ? Colors.yellow
                  //             : betValue < 50
                  //                 ? Colors.pink
                  //                 : betValue < 100
                  //                     ? Colors.red
                  //                     : betValue < 500
                  //                         ? Colors.blue
                  //                         : betValue < 1000
                  //                             ? Colors.pink
                  //                             : betValue < 5000
                  //                                 ? Colors.orange
                  //                                 : Colors.purple),
                  child: Small_Text(
                      alignment: Alignment.center,
                      Title: betNumbersList[index].number.toString(),
                      style: GoogleFonts.dmSerifDisplay(
                        textStyle: TextStyle(
                          fontSize: width / 50,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: ColorConstant.whiteColor,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildBetItem(int index) {
  //   int betValue = betNumbersList[index].betApplied;
  //   bool isBetPlaced = betValue != 0;
  //   return InkWell(
  //     onTap: () {
  //       tapToPlaceBetOnNumberAction(index);
  //     },
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         CustomContainer(
  //           widths: width / 13,
  //           height: width / 35,
  //           alignment: Alignment.center,
  //           image: const DecorationImage(
  //             image: AssetImage(
  //               Graphics.bottomsqrButton,
  //             ),
  //             fit: BoxFit.fill,
  //           ),
  //           child: Small_Text(
  //               alignment: Alignment.center,
  //               Title: isBetPlaced ? "$betValue" : "",
  //               fontSize: width / 60,
  //               style: GoogleFonts.dmSerifDisplay(
  //                 textStyle: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: width / 60,
  //                   fontStyle: FontStyle.normal,
  //                   color: ColorConstant.textColorBrown,
  //                 ),
  //               )),
  //         ),
  //         CustomContainer(
  //           padding: const EdgeInsets.all(5),
  //           widths: width / 16,
  //           height: width / 20,
  //           image: const DecorationImage(
  //             image: AssetImage(
  //               Graphics.bottomcircleButton,
  //             ),
  //             fit: BoxFit.fill,
  //           ),
  //           child: BlinkingWinnerNumber(
  //             isTimetoStartBlinking: needToTake == true && result - 1 == index
  //                 ? needToTake
  //                 : false,
  //             index: betNumbersList[index].number.toString(),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: betValue == 0 ? Colors.transparent : Colors.green,
  //               ),
  //               // betValue == 0
  //               //     ? Colors.transparent
  //               //     : betValue < 5
  //               //         ? Colors.green
  //               //         : betValue < 10
  //               //             ? Colors.yellow
  //               //             : betValue < 50
  //               //                 ? Colors.pink
  //               //                 : betValue < 100
  //               //                     ? Colors.red
  //               //                     : betValue < 500
  //               //                         ? Colors.blue
  //               //                         : betValue < 1000
  //               //                             ? Colors.pink
  //               //                             : betValue < 5000
  //               //                                 ? Colors.orange
  //               //                                 : Colors.purple),
  //               child: Small_Text(
  //                   alignment: Alignment.center,
  //                   Title: betNumbersList[index].number.toString(),
  //                   style: GoogleFonts.dmSerifDisplay(
  //                     textStyle: TextStyle(
  //                       fontSize: width / 50,
  //                       fontWeight: FontWeight.bold,
  //                       fontStyle: FontStyle.normal,
  //                       color: ColorConstant.whiteColor,
  //                     ),
  //                   )),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget sectionThree() {
    return CustomContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          10,
              (index) => buildBetItem(index),
        ),
      ),
    );
  }

  Widget sectionFour() {
    return CustomContainer(
      height: height / 14.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomContainer(
            widths: width / 9,
            height: height / 11,
            image: const DecorationImage(
                image: AssetImage(Graphics.buttonLeft), fit: BoxFit.fitWidth),
            child: Small_Text(
              fontWeight: FontWeight.bold,
              fontSize: width / 60,
              Title: totalBetApplied.toString(),
              textColor: ColorConstant.whiteColor,
            ),
          ),
          CustomContainer(
            height: height / 16,
            widths: width / 2.2,
            alignment: Alignment.bottomCenter,
            image: const DecorationImage(
                image: AssetImage(Graphics.bottomBig), fit: BoxFit.fitWidth),
            child: Small_Text(
              alignment: Alignment.bottomCenter,
              Title: winnerAmount == 0
                  ? "Better luck next time!! You Loss "
                  : winnerAmount == -1
                  ? "You are not placed bet in this match"
                  : "Boohoo!! Congrats Winner no is $result and You Won - $winnerAmount",
              textColor: ColorConstant.textColorBrown,
              fontSize: width / 60,
            ),
          ),
          CustomContainer(
            onTap: () {
              countdownTimer!.cancel();
              pauseNetworkSound();
              Navigator.of(context).pop();
            },
            widths: width / 9,
            height: height / 11,
            image: const DecorationImage(
                image: AssetImage(Graphics.buttonRight), fit: BoxFit.fitWidth),
            child: Small_Text(
              fontWeight: FontWeight.bold,
              fontSize: width / 60,
              Title: "Exit",
              textColor: ColorConstant.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.darkBlackColor,
      body: Center(
        child: CustomContainer(
          widths: width / 1.2,
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 3),
          alignment: Alignment.center,
          image: const DecorationImage(
              image: AssetImage(Graphics.homeBg), fit: BoxFit.cover),
          height: height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sectionOne(),
                  const Spacer(),
                  sectionThree(),
                  sectionFour(),
                ],
              ),
              CustomContainer(
                padding: const EdgeInsets.only(top: 0),
                height: width / 3.2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WheelSpin(
                      controller: wheelSpinController,
                      pathImage: Graphics.bigChakkra,
                      withWheel: width / 1.5,
                      pieces: 20,
                      speed: 600,
                      isShowTextTest: false,
                    ),
                    CustomContainer(
                        alignment: Alignment.center,
                        widths: width / 11,
                        child: isTimerDone == false
                            ? Image.asset(Graphics.vdoMain)
                            : Image.asset(Graphics.chotaChkra))
                  ],
                ),
              ),
              Positioned(
                top: -9,
                child: CustomContainer(
                  widths: width / 16,
                  height: width / 21,
                  clipBehavior: Clip.none,
                  image: const DecorationImage(
                      image: AssetImage(
                        Graphics.scorpio,
                      ),
                      fit: BoxFit.fill),
                ),
              ),
              Positioned(top: height / 2.9, child: sectionTwo()),
              Positioned(
                  top: height / 2.15,
                  left: width / 2.4,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.2,
                  left: width / 2.8,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2,
                  left: width / 4.5,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.3,
                  left: width / 4,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 3.03,
                  left: width / 3.6,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2,
                  right: width / 4.5,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.3,
                  right: width / 4,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 3.03,
                  right: width / 3.6,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.6,
                  right: width / 3,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.6,
                  left: width / 3,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.15,
                  right: width / 3.3,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 2.15,
                  left: width / 3.3,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.83,
                  left: width / 24,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.75,
                  left: width / 9,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.7,
                  left: width / 5.5,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.65,
                  left: width / 4,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.83,
                  right: width / 24,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.75,
                  right: width / 9,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.7,
                  right: width / 5.5,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.65,
                  right: width / 3.8,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.68,
                  right: width / 2.105,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.68,
                  left: width / 2.105,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.46,
                  right: width / 2.05,
                  child: const BlinkingStar()),
              Positioned(
                  top: height / 1.46,
                  left: width / 2.05,
                  child: const BlinkingStar()),
            ],
          ),
        ),
      ),
    );
  }

  Widget yellowButton(
      Widget? innerText, outerText, EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          TitleStyle(
            Title: outerText,
            fontSize: width / 55,
            fontWeight: FontWeight.bold,
            lineheight: 0.6,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomContainer(
              padding: const EdgeInsets.all(2),
              widths: width / 5.8,
              height: width / 28,
              image: const DecorationImage(
                  image: AssetImage(Graphics.homeButton1), fit: BoxFit.fill),
              child: innerText)
        ],
      ),
    );
  }

  Widget sideButtons(
      BorderRadiusGeometry? borderRadius,
      Widget child,
      ) {
    return CustomContainer(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 3, top: 3),
      widths: width / 5,
      borderRadius: borderRadius,
      gradient: LinearGradient(
        colors: [
          Colors.yellow.shade400.withOpacity(0.8),
          Colors.orange.withOpacity(0.7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: child,
    );
  }

  Widget chipButton(String price, imageName) {
    return CustomContainer(
      alignment: Alignment.topCenter,
      borderRadius: BorderRadius.circular(60),
      border: Border.all(
          width: 1.5,
          color: selectedChip.toString() == price
              ? Colors.yellowAccent
              : Colors.transparent),
      widths: width / 23,
      height: height / 15,
      image: DecorationImage(image: AssetImage(imageName), fit: BoxFit.fill),
      child: Small_Text(
        alignment: Alignment.center,
        fontSize: width / 75,
        Title: "",
      ),
    );
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    stopAudio();
    stopNetworkSound();
    releaseNetworkSoundResources();
    audioPlayer.pause();
    audioPlayer.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    super.dispose();
  }
}

class BetOnNumbers {
  int number;
  int betApplied;
  BetOnNumbers({required this.number, required this.betApplied});
  Map<String, int> toJson() {
    return {
      'number': number,
      'amount': betApplied,
    };
  }
}
