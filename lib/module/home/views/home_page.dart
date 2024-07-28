import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global/global.dart';
import '../../../models/models.dart';
import '../../../routes/routes.dart';
import '../home.dart';

class HomePage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String walletAmount = '00.00';
  String amountSpentThisMonth = '00.00';
  final amountController = TextEditingController();
  final List<Variables> expensesVariables = [];
  final List<Variables> selectedPrimaryVariables = [];
  final List<Variables> selectedSecondaryVariables = [];
  final List<Variables> primaryVariables = [];
  final List<Variables> secondaryVariables = [];
  final HomeRepository homeRepository = HomeRepository();

  @override
  void initState() {
    super.initState();
    getWalletAmount();
    getExpensesVariable();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Future<void> getWalletAmount() async {
    final UserModel? user = await homeRepository.loggedInUser;
    if (user != null) {
      setState(() {
        walletAmount = user.walletAmount;
        if (user.primaryVariables!.isNotEmpty) {
          primaryVariables
            ..clear()
            ..addAll(
              expensesVariables.where(
                (variable) => user.primaryVariables!.contains(variable.id),
              ),
            );
          selectedPrimaryVariables
            ..clear()
            ..addAll(primaryVariables);
        }
        if (user.secondaryVariables!.isNotEmpty) {
          secondaryVariables
            ..clear()
            ..addAll(
              expensesVariables.where(
                (variable) => user.secondaryVariables!.contains(variable.id),
              ),
            );
          selectedSecondaryVariables
            ..clear()
            ..addAll(secondaryVariables);
        }
      });
      getAmountSpentThisMonth();
    }
  }

  Future<void> getAmountSpentThisMonth() async {
    final int amount = await homeRepository.getAmountSpentThisMonth();
    setState(() {
      amountSpentThisMonth = amount.toString();
    });
  }

  Future<void> getExpensesVariable() async {
    final List<Variables> expenses = await homeRepository.getVariables();
    setState(() {
      expensesVariables.addAll(expenses);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.sp),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          );
        },
        child: Icon(
          Icons.logout,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const WishUser(),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SideCard(
                    title: 'Available Balance',
                    subtitle: 'रू $walletAmount',
                    icon: '0xf520',
                    sideBool: true,
                  ),
                  SideCard(
                    title: 'Add',
                    subtitle: 'Add to wallet',
                    icon: '0xf537',
                    sideBool: false,
                    onPressed: () {
                      ShowCustomBottomSheet().addAmountToWallet(
                          context: context,
                          amountController: amountController,
                          onPressed: () {
                            HomeRepository()
                                .addAmountToWallet(
                              amount: amountController.text,
                            )
                                .then((value) {
                              Navigator.pop(context);
                              setState(() {
                                getWalletAmount();
                              });
                            }).catchError((error) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                ),
                              );
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error.toString()),
                                ),
                              );
                            }).whenComplete(() {
                              amountController.clear();
                            });
                          });
                    },
                  ),
                ],
              ),
              10.verticalSpace,
              SideCard(
                title: 'Spent This Month',
                subtitle: 'रू $amountSpentThisMonth',
                icon: '0xf0058',
                sideBool: false,
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Text(
                  'Primary Expenses',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              10.verticalSpace,
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: primaryVariables.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: homeRepository.getAmountByVariableId(
                      variableId: primaryVariables[index].id,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      return SideCard(
                        onPressed: () {
                          ShowCustomBottomSheet().addAmountToWallet(
                            context: context,
                            amountController: amountController,
                            onPressed: () {
                              HomeRepository()
                                  .addRecord(
                                variableId: primaryVariables[index].id,
                                amount: amountController.text,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                                setState(() {
                                  getWalletAmount();
                                });
                              }).catchError((error) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ),
                                );
                              }).onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ),
                                );
                              }).whenComplete(() {
                                amountController.clear();
                              });
                            },
                          );
                        },
                        title: primaryVariables[index].name,
                        subtitle: 'रू ${snapshot.data}',
                        icon: primaryVariables[index].icon,
                        sideBool: index.isEven,
                      );
                    },
                  );
                },
              ),
              10.verticalSpace,
              SideCard(
                title: 'Add',
                subtitle: 'Add new item',
                icon: '0xf537',
                sideBool: true,
                onPressed: () {
                  ShowCustomBottomSheet().showCustomBottomSheet(
                    context: context,
                    expensesVariable: expensesVariables,
                    selectedPrimaryVariables: selectedPrimaryVariables,
                    selectedSecondaryVariables: selectedSecondaryVariables,
                    variableType: 'primary',
                    onPressed: () {
                      setState(() {
                        homeRepository.updatePrimaryVariables(
                          primaryVariables: selectedPrimaryVariables
                              .map((variable) => variable.id)
                              .toList(),
                        );
                        homeRepository.updateSecondaryVariables(
                          secondaryVariables: selectedSecondaryVariables
                              .map((variable) => variable.id)
                              .toList(),
                        );
                        getWalletAmount();
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
              10.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Text(
                    'Other Expenses',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: secondaryVariables.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: homeRepository.getAmountByVariableId(
                      variableId: secondaryVariables[index].id,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }
                      return SideCard(
                        onPressed: () {
                          ShowCustomBottomSheet().addAmountToWallet(
                            context: context,
                            amountController: amountController,
                            onPressed: () {
                              HomeRepository()
                                  .addRecord(
                                variableId: secondaryVariables[index].id,
                                amount: amountController.text,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                                setState(() {
                                  getWalletAmount();
                                });
                              }).catchError((error) {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ),
                                );
                              }).onError((error, stackTrace) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error.toString()),
                                  ),
                                );
                              }).whenComplete(() {
                                amountController.clear();
                              });
                            },
                          );
                        },
                        title: secondaryVariables[index].name,
                        subtitle: 'रू ${snapshot.data}',
                        icon: secondaryVariables[index].icon,
                        sideBool: index.isOdd,
                      );
                    },
                  );
                },
              ),
              10.verticalSpace,
              SideCard(
                title: 'Add',
                subtitle: 'Add new item',
                icon: '0xf537',
                sideBool: false,
                onPressed: () {
                  ShowCustomBottomSheet().showCustomBottomSheet(
                    context: context,
                    expensesVariable: expensesVariables,
                    selectedPrimaryVariables: selectedPrimaryVariables,
                    selectedSecondaryVariables: selectedSecondaryVariables,
                    variableType: 'secondary',
                    onPressed: () {
                      setState(() {
                        homeRepository.updateSecondaryVariables(
                          secondaryVariables: selectedSecondaryVariables
                              .map((variable) => variable.id)
                              .toList(),
                        );
                        homeRepository.updatePrimaryVariables(
                          primaryVariables: selectedPrimaryVariables
                              .map((variable) => variable.id)
                              .toList(),
                        );
                        getWalletAmount();
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
              10.verticalSpace,
              FutureBuilder(
                future: homeRepository.getRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  return SideCard(
                    title: 'Recent Transactions',
                    subtitle: 'View all',
                    icon: '0xf85e',
                    sideBool: true,
                    onPressed: () {
                      ShowCustomBottomSheet().showRecentTransactions(
                        context: context,
                        transactionRecord: snapshot.data!,
                        expensesVariable: expensesVariables,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowCustomBottomSheet {
  void addAmountToWallet(
      {required BuildContext context,
      required TextEditingController amountController,
      required void Function() onPressed}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          height: MediaQuery.of(context).viewInsets.bottom + 200.sp,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.sp),
              topRight: Radius.circular(8.sp),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.sp,
                  width: 50.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                ),
              ),
              10.verticalSpace,
              Text(
                'Add Amount to Wallet',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              10.verticalSpace,
              CustomTextFormField(
                label: 'Amount',
                hint: 'Enter amount',
                controller: amountController,
                keyboardType: TextInputType.number,
                icon: Icons.account_balance_wallet_rounded,
                onChanged: (value) {},
              ),
              10.verticalSpace,
              PrimaryButton(
                text: 'Add Amount',
                onPressed: onPressed,
              ),
              20.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void showCustomBottomSheet({
    required BuildContext context,
    required List<Variables> selectedPrimaryVariables,
    required List<Variables> selectedSecondaryVariables,
    required List<Variables> expensesVariable,
    required String variableType,
    required void Function() onPressed,
  }) {
    showModalBottomSheet(
      constraints: BoxConstraints(maxHeight: 800.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.sp),
          topRight: Radius.circular(8.sp),
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.sp),
                topRight: Radius.circular(8.sp),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 5.sp,
                    width: 50.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Row(
                    children: [
                      Text(
                        variableType == 'primary'
                            ? 'Primary Expenses'
                            : 'Secondary Expenses',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Selected: ${variableType == 'primary' ? selectedPrimaryVariables.length : selectedSecondaryVariables.length} /${expensesVariable.length}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 300.sp,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: expensesVariable.length,
                    itemBuilder: (context, index) {
                      return SideCard(
                        onPressed: () {
                          setState(() {
                            if (variableType == 'primary') {
                              if (selectedPrimaryVariables
                                  .contains(expensesVariable[index])) {
                                selectedPrimaryVariables
                                    .remove(expensesVariable[index]);
                              } else {
                                selectedPrimaryVariables
                                    .add(expensesVariable[index]);
                                selectedSecondaryVariables
                                    .remove(expensesVariable[index]);
                              }
                            } else {
                              if (selectedSecondaryVariables
                                  .contains(expensesVariable[index])) {
                                selectedSecondaryVariables
                                    .remove(expensesVariable[index]);
                              } else {
                                selectedSecondaryVariables
                                    .add(expensesVariable[index]);
                                selectedPrimaryVariables
                                    .remove(expensesVariable[index]);
                              }
                            }
                          });
                        },
                        title: '${index + 1}',
                        subtitle: expensesVariable[index].name,
                        selected: variableType == 'primary'
                            ? selectedPrimaryVariables
                                .contains(expensesVariable[index])
                            : selectedSecondaryVariables
                                .contains(expensesVariable[index]),
                        icon: expensesVariable[index].icon,
                        sideBool: index.isEven,
                      );
                    },
                  ),
                ),
                10.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: PrimaryButton(
                    text: 'Update',
                    onPressed: onPressed,
                  ),
                ),
                10.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }

  void showRecentTransactions({
    required BuildContext context,
    required List<TransactionRecord> transactionRecord,
    required List<Variables> expensesVariable,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.sp),
          topRight: Radius.circular(8.sp),
        ),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.sp),
              topRight: Radius.circular(8.sp),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.sp,
                  width: 50.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 10.sp,
                ),
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              10.verticalSpace,
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300.sp,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: transactionRecord.length,
                  itemBuilder: (context, index) {
                    return SideCard(
                      title: expensesVariable
                          .firstWhere(
                            (variable) =>
                                variable.id ==
                                transactionRecord[index].variableId,
                          )
                          .name,
                      subtitle:
                          'रू ${transactionRecord[index].amount}\n${transactionRecord[index].createdAt}',
                      icon: expensesVariable
                          .firstWhere(
                            (variable) =>
                                variable.id ==
                                transactionRecord[index].variableId,
                          )
                          .icon,
                      sideBool: index.isEven,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WishUser extends StatelessWidget {
  const WishUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateTime.now().hour < 12
                    ? 'Good Morning!'
                    : DateTime.now().hour < 17
                        ? 'Good Afternoon!'
                        : DateTime.now().hour < 20
                            ? 'Good Evening!'
                            : 'Good Night!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              10.horizontalSpace,
              Icon(
                DateTime.now().hour < 12
                    ? Icons.wb_sunny
                    : DateTime.now().hour < 17
                        ? Icons.brightness_5
                        : DateTime.now().hour < 20
                            ? Icons.brightness_6
                            : Icons.nights_stay,
                color: Theme.of(context).colorScheme.secondary,
                size: 18.sp,
              ),
            ],
          ),
          Text(
            formatDate(DateTime.now()),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
