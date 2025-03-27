import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wasteapp/core/resources/colors.dart';
import 'package:wasteapp/core/resources/text_styles.dart';
import 'package:wasteapp/features/home/data/Services/firebase_services.dart';
import 'package:wasteapp/features/home/data/model/accounts_model.dart';
import 'package:wasteapp/features/home/data/model/detail_model.dart';
import 'package:wasteapp/features/home/presentation/widgets/title_text.dart';
import 'package:wasteapp/utils/constants.dart';

class PaymentsView extends StatefulWidget {
  const PaymentsView({super.key});

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  late FlutterSecureStorage secureStorage;
  late FirebaseServices firebaseServices;

  late List<CommonDetailModel> lisPaymentData = [];
  late Account? account;

  @override
  void initState() {
    firebaseServices = FirebaseServices();
    secureStorage = const FlutterSecureStorage();

    super.initState();
    getAccountData();
    getPaymentRecordListData();
  }

  void getPaymentRecordListData() async {
    lisPaymentData = [];

    List<CommonDetailModel> fetchedData = await firebaseServices.fetchAllData(
      collectionName: DBConstants.paymentsRecordsCollection,
    );

    var uid = await secureStorage.read(key: 'uid');

    if (uid != "") {
      for (CommonDetailModel model in fetchedData) {
        if (model.uId == uid || model.BUId == uid) {
          lisPaymentData.add(model);
        }
      }
    }

    setState(() {});
  }

  void getAccountData() async {
    account = Account(
      currentBalance: 0.0,
      earnings: 0.0,
      dueAmount: 0.0,
      notes: "",
    );

    var uid = await secureStorage.read(key: 'uid');

    account = await firebaseServices.getUserAccountsData(uid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Payments", style: TextStyles(context).appBarText),
        elevation: 0,
      ),
      backgroundColor: ApplicationColors(context).appWhiteBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: TitleText(titleText: "Payments Summary"),
            ),
            const SizedBox(height: 8.0),
            PaymentSummeryContainer(
              account:
                  account ??
                  Account(
                    currentBalance: 0.0,
                    earnings: 0.0,
                    dueAmount: 0.0,
                    notes: "notes",
                  ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: lisPaymentData.length,
                itemBuilder: (context, index) {
                  final item = lisPaymentData[index];
                  return PaymentCardView(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCardView extends StatelessWidget {
  const PaymentCardView({super.key, required this.item});

  final CommonDetailModel item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "${item.notes}",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Text(
              "LKR ${item.price}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSummeryContainer extends StatelessWidget {
  const PaymentSummeryContainer({super.key, required this.account});

  final Account account;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Current Balance",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 5),
          Text(
            "Rs ${account.currentBalance}",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 20),
          Divider(thickness: 1, color: Colors.grey[300]),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    "TOLTAL EARNINGS",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Rs ${account.earnings}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ONGOING DUE",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Rs ${account.dueAmount}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
}
