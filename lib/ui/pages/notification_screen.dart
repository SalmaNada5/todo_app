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
          style: titleStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Hi',
              style: headingStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'You have new reminder',
              style: bodyStyle,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: primaryClr,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    NotificationElement(
                      eIcon: Icons.title,
                      eName: 'Title',
                      ePayload: _payload!.split('|')[0],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    NotificationElement(
                      eIcon: Icons.description,
                      eName: 'Description',
                      ePayload: _payload!.split('|')[1],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    NotificationElement(
                      eIcon: Icons.date_range,
                      eName: 'Date',
                      ePayload: _payload!.split('|')[2],
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class NotificationElement extends StatelessWidget {
  const NotificationElement(
      {Key? key,
      required this.eIcon,
      required this.eName,
      required this.ePayload})
      : super(key: key);
  final IconData eIcon;
  final String eName;
  final String ePayload;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              eIcon,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              eName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          ePayload,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }
}
