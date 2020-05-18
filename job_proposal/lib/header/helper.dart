//flutter
import 'package:flutter/material.dart';

//internal
import 'package:job_proposal/main.dart';

//debug function
visualPrint(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text),
    ),
  );
}

//widgets
class SliverTopAppBar extends StatelessWidget {
  const SliverTopAppBar({
    @required this.clientName,
    Key key,
  }) : super(key: key);

  final String clientName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeData.dark().primaryColorDark,
      //not on top of screen
      primary: false,
      //give the edit half life button space
      centerTitle: false,
      //medication name
      title: Row(
        children: [
          Text(
            "For: ",
            style: TextStyle(
              color: lbGrey,
            ),
          ),
          Text(
            clientName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SliverBottomAppBar extends StatelessWidget {
  const SliverBottomAppBar({
    @required this.bottomAppBarHeight,
    @required this.addingLineItem,
    Key key,
  }) : super(key: key);

  final double bottomAppBarHeight;
  final ValueNotifier<bool> addingLineItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomAppBarHeight,
      child: Material(
        color: lbGreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
              color: Colors.white,
              onPressed: () {
                visualPrint(
                  context,
                  "I'll Be Bach",
                );
              },
            ),
            //spacer so resizing doses doesn't get covered
            Expanded(
              child: Opacity(
                opacity: 1,
                child: ReloadingFormTitle(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 8.0,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  //appBarHeight - (some padding * 2)
                  height: 56.0 - (8 * 2),
                  decoration: BoxDecoration(
                    color: ThemeData.dark().primaryColorDark,
                  ),
                  //ThemeData.dark().primaryColor
                  child: AddItemButton(
                    addingLineItem: addingLineItem,
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

class AddItemButton extends StatefulWidget {
  const AddItemButton({
    Key key,
    @required this.addingLineItem,
  }) : super(key: key);

  final ValueNotifier<bool> addingLineItem;

  @override
  _AddItemButtonState createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  //very tricky bug
  //that I've encountered before
  //know how to fix
  //but forgot why this fixes it
  updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.addingLineItem.addListener(updateState);
  }

  @override
  void dispose() {
    widget.addingLineItem.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //disable the button until the list adds the line item
      onTap: widget.addingLineItem.value
          ? null
          //its false, so the button is active
          //so the user can make it true
          : () {
              widget.addingLineItem.value = true;
            },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 8.0,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            Text(
              "Add Task",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReloadingFormTitle extends StatelessWidget {
  const ReloadingFormTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: JobForm.isOrder,
      builder: (context, child) {
        String formType = JobForm.isOrder.value ? "Order" : "Proposal";
        return Text(
          "Job " + formType,
          style: TextStyle(
            //matches current styling
            //matched by sight
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        );
      },
    );
  }
}
