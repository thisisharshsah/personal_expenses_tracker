import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global/global.dart';
import '../../../models/models.dart';
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
  final amountController = TextEditingController();
  final HomeRepository homeRepository = HomeRepository();

  @override
  void initState() {
    super.initState();
    getWalletAmount();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    subtitle: '\$$walletAmount',
                    icon: Icons.account_balance_wallet_rounded,
                    sideBool: true,
                  ),
                  SideCard(
                    title: 'Add',
                    subtitle: 'Add to wallet',
                    icon: Icons.add_rounded,
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
              const SideCard(
                title: 'Spent This Month',
                subtitle: '\$500.00',
                icon: Icons.payments_rounded,
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
              const SideCard(
                title: 'Food',
                subtitle: '\$200.00',
                icon: Icons.fastfood_rounded,
                sideBool: true,
              ),
              10.verticalSpace,
              SideCard(
                title: 'Add',
                subtitle: 'Add new item',
                icon: Icons.add_rounded,
                sideBool: true,
                onPressed: () {
                  ShowCustomBottomSheet().showCustomBottomSheet(context);
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
              const SideCard(
                title: 'Medicine',
                subtitle: '\$100.00',
                icon: Icons.medical_services_rounded,
                sideBool: false,
              ),
              10.verticalSpace,
              SideCard(
                title: 'Add',
                subtitle: 'Add new item',
                icon: Icons.add_rounded,
                sideBool: false,
                onPressed: () {
                  ShowCustomBottomSheet().showCustomBottomSheet(context);
                },
              ),
              10.verticalSpace,
              SideCard(
                title: 'Recent Transactions',
                subtitle: 'View all',
                icon: Icons.list_rounded,
                sideBool: true,
                onPressed: () {
                  ShowCustomBottomSheet().showRecentTransactions(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// show bottom sheet to add new expense
class ShowCustomBottomSheet {
  final selectedVariables = [];
  final expensesVariable = [
    {
      'name': 'Food',
      'icon': Icons.fastfood_rounded,
    },
    {
      'name': 'Medicine',
      'icon': Icons.medical_services_rounded,
    },
    {
      'name': 'Travel',
      'icon': Icons.directions_car_rounded,
    },
    {
      'name': 'Shopping',
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'name': 'Entertainment',
      'icon': Icons.movie_rounded,
    },
    {
      'name': 'Health',
      'icon': Icons.local_hospital_rounded,
    },
    {
      'name': 'Education',
      'icon': Icons.school_rounded,
    },
    {
      'name': 'Bills',
      'icon': Icons.receipt_rounded,
    },
    {
      'name': 'Liquor',
      'icon': Icons.local_bar_rounded,
    },
    {
      'name': 'Loan',
      'icon': Icons.money_rounded,
    },
  ];

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

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                child: Row(
                  children: [
                    Text(
                      'Add New Expense',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    //   selected variables
                    const Spacer(),
                    Text(
                      'Selected: ${selectedVariables.length}/${expensesVariable.length}',
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
                      title: '${index + 1}',
                      subtitle: expensesVariable[index]['name'] as String,
                      icon: expensesVariable[index]['icon'] as IconData,
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

  // show bottom sheet to view recent transactions
  void showRecentTransactions(BuildContext context) {
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
                child: Row(
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
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
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return SideCard(
                      title: expensesVariable[index]['name'] as String,
                      subtitle: '\$100.00',
                      icon: expensesVariable[index]['icon'] as IconData,
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

String formatDate(DateTime date) {
  String formattedDate = '';
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  formattedDate =
      '${days[date.weekday]} ${date.day} ${months[date.month - 1]}, ${date.year}';
  return formattedDate;
}

class SideCard extends StatelessWidget {
  const SideCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sideBool,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool sideBool;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Align(
        alignment: sideBool ? Alignment.centerLeft : Alignment.centerRight,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: sideBool ? Radius.circular(50.sp) : Radius.zero,
              bottomRight: sideBool ? Radius.circular(50.sp) : Radius.zero,
              topLeft: sideBool ? Radius.zero : Radius.circular(50.sp),
              bottomLeft: sideBool ? Radius.zero : Radius.circular(50.sp),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20.sp,
                  backgroundColor: sideBool
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    icon,
                    color: sideBool
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                    size: 20.sp,
                  ),
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    5.verticalSpace,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                10.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// single last transaction amount with date and time
class LatestTransactions extends StatelessWidget {
  const LatestTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.sp),
          bottomLeft: Radius.circular(50.sp),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20.sp,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20.sp,
              ),
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Transaction',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                5.verticalSpace,
                Text(
                  '\$100.00',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                5.verticalSpace,
                Text(
                  '12:00 PM, 12th January 2022',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            10.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
