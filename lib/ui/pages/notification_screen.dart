import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        title: Text(
          _payload.toString().split('|')[0],
          style: headingStyle.copyWith(fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'You have new reminder',
              style: titleStyle,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                margin: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NotificationElement(
                        eName: 'Description',
                        ePayload: _payload!.split('|')[1],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        height: 30,
                        thickness: 0.2,
                        indent: 0.5,
                        endIndent: 0.5,
                        color: white,
                      ),
                      NotificationElement(
                        eName: 'Time',
                        ePayload: _payload!.split('|')[2],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationElement extends StatelessWidget {
  const NotificationElement(
      {Key? key, required this.eName, required this.ePayload})
      : super(key: key);
  final String eName;
  final String ePayload;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eName,
            style: headingStyle.copyWith(color: Colors.white, fontSize: 20)),
        const SizedBox(
          height: 10,
        ),
        Text(
          ePayload,
          style: titleStyle.copyWith(color: Colors.white, fontSize: 18),
        )
      ],
    );
  }
}
