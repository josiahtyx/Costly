import 'package:costlynew/data/data.dart';
import 'package:flutter/material.dart';

var funcGetPlans = new GetPlans();

class PlannedPurchases extends StatefulWidget {
  const PlannedPurchases({super.key});

  @override
  State<PlannedPurchases> createState() => _PlannedPurchasesState();
}

class _PlannedPurchasesState extends State<PlannedPurchases> {
  late Future<List<dynamic>> plansData;
  late bool _isLoading;
  void wait() async {
    _isLoading = true;
    funcGetPlans.getPlans();
    plansData = funcGetPlans.getPlans();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      }); // Prints after 1 second.
    });
  }

  @override
  void initState() {
    super.initState();
    wait();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: Container(
            width: device.width * 0.30,
            height: device.height * 0.57,
            child: _isLoading
                ? ListView.separated(
                    itemBuilder: ((context, index) => const AsyncBarRow()),
                    separatorBuilder: ((context, index) => SizedBox(
                          height: 0,
                        )),
                    itemCount: 10)
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: plansData,
                            builder: (context, snapshot) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: plannedPurchases.length,
                                itemBuilder: ((context, index) {
                                  final item =
                                      plannedPurchases[index].toString();

                                  return Dismissible(
                                    key: Key(item),
                                    background: Container(
                                      color: Colors.amber[700],
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Icon(
                                        Icons.archive,
                                        color: Colors.white,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                        color: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                    // Provide a function that tells the app
                                    // what to do after an item has been swiped away.
                                    onDismissed: (direction) async {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '${plannedPurchases[index]['itemName']} has been archived.')));
                                        archiveTransaction(
                                          (plannedPurchases[index]['category'])
                                              .toString(),
                                          // (plannedPurchases[index]['costPerDay'])
                                          //     .toString(),
                                          (plannedPurchases[index]['duration'])
                                              .toString(),
                                          (plannedPurchases[index]['endDate'])
                                              .toString(),
                                          (plannedPurchases[index]['itemDate'])
                                              .toString(),
                                          (plannedPurchases[index]['itemName'])
                                              .toString(),
                                          (plannedPurchases[index]['itemPrice'])
                                              .toString(),
                                        );
                                        setState(() {
                                          plannedPurchases.removeAt(index);
                                        });

                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlannedPurchases()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '${plannedPurchases[index]['itemName']} has been deleted.')));
                                        delTransaction(
                                          (plannedPurchases[index]['category'])
                                              .toString(),
                                          // (plannedPurchases[index]['costPerDay'])
                                          //     .toString(),
                                          (plannedPurchases[index]['duration'])
                                              .toString(),
                                          (plannedPurchases[index]['endDate'])
                                              .toString(),
                                          (plannedPurchases[index]['itemDate'])
                                              .toString(),
                                          (plannedPurchases[index]['itemName'])
                                              .toString(),
                                          (plannedPurchases[index]['itemPrice'])
                                              .toString(),
                                        );
                                        // Remove the item from the data source.
                                        setState(() {
                                          plannedPurchases.removeAt(index);
                                        });

                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlannedPurchases()),
                                        );
                                      }

                                      // Then show a snackbar.
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: ListTile(
                                          title: Text(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              (plannedPurchases[index]
                                                      ['itemName'])
                                                  .toString()),
                                          // subtitle: Text(('Item Price: ' +
                                          //         plannedPurchases[index]['itemPrice']
                                          //             .replaceAll(RegExp(r'\.'), ',') +
                                          //         '€' +
                                          //         '\nPurchase Date: ' +
                                          //         plannedPurchases[index]['itemDate'] +
                                          //         '')
                                          //     .toString()),
                                          trailing: Wrap(
                                            spacing:
                                                0, // space between two icons
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 80.0),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50.0),
                                                child: SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      ((plannedPurchases[index][
                                                                  'itemPrice']))
                                                              .toString()
                                                              .replaceAll(
                                                                  RegExp(r'\.'),
                                                                  ',') +
                                                          "€"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            })
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class AsyncBarRow extends StatelessWidget {
  const AsyncBarRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 35, 35, 20),
      child: Container(
        child: Row(
          children: [
            Expanded(child: AsyncBar()),
            Padding(
              padding: const EdgeInsets.fromLTRB(160, 0, 35, 0),
              child: AsyncBar(
                width: 130,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 0, 5, 0),
              child: AsyncBar(
                width: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 8.0, 0),
              child: AsyncBar(
                width: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AsyncBar extends StatelessWidget {
  const AsyncBar({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}
