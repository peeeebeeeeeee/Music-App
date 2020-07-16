import 'package:components/imageModule/mainModule.dart';
import 'package:components/imageModule/widgets/transactionImageView.dart';
import 'package:flutter/material.dart';

class ViewTransactions extends StatefulWidget {
  @override
  _ViewTransactionsState createState() => _ViewTransactionsState();
}

class _ViewTransactionsState extends State<ViewTransactions> {
  ImageModule module = ImageModule();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: StreamBuilder(
          stream: module.getTransactionStream().stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              List transactionList = snapshot.data;
              return ListView.builder(
                  itemCount: transactionList.length,
                  itemBuilder: (context, position) {
                    return ListTile(
                      title: Text("Doc id : ${transactionList[position]}"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionImageView(
                                      transactionId: transactionList[position],
                                    )));
                      },
                    );
                  });
            }
          }),
    );
  }
}
