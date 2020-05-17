import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:job_proposal/data/structs.dart';
import 'package:job_proposal/main.dart';

class LineItemList extends StatefulWidget {
  LineItemList({
    @required this.lineItems,
    @required this.addingLineItem,
  });

  //
  final ValueNotifier<List<LineItem>> lineItems;
  //set to true by add list button
  //set to false by us after completing process
  final ValueNotifier<bool> addingLineItem;

  @override
  _LineItemListState createState() => _LineItemListState();
}

class _LineItemListState extends State<LineItemList> {
  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  addingLineItemChanged() {
    //add the line item to the list
    if (widget.addingLineItem.value) {
      //TODO: optimize this

      //make of copy of the list
      List<LineItem> lineItemsCopy = List<LineItem>.from(
        widget.lineItems.value,
      );

      //edit the copy of the list
      lineItemsCopy.add(LineItem());

      //have the notifier update
      widget.lineItems.value = lineItemsCopy;

      //NOTE: addingLineItem is set to false
      //when the rebuild is complete
      //rebuild occurs when lineItems is updated
    }
    //ELSE.... don't react to it
  }

  @override
  void initState() {
    super.initState();
    widget.lineItems.addListener(updateState);
    widget.addingLineItem.addListener(
      addingLineItemChanged,
    );
  }

  @override
  void dispose() {
    widget.addingLineItem.removeListener(
      addingLineItemChanged,
    );
    widget.lineItems.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int lineItemCount = widget.lineItems.value.length;
    int lastIndex = lineItemCount - 1;
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          lineItemCount,
          (indexInVisualList) {
            //the list is added to from the back programatically
            //but the last value added should be on top
            int indexInActualList = lastIndex - indexInVisualList;
            LineItem aLineItem = widget.lineItems.value[indexInActualList];

            //IF... this is the top most item
            //and we are addingALineItem
            //the we autofocus this description field
            //ELSE... we are deleting something
            //and no field should be focused
            bool autoFocusField = false;
            if (indexInVisualList == 0 && widget.addingLineItem.value) {
              print("auto focus field on top");
              autoFocusField = true;
              widget.addingLineItem.value = false;
            }

            //return UI
            return Container(
              decoration: BoxDecoration(
                color: (indexInActualList % 2 == 0) ? Colors.red : Colors.blue,
                border: Border(
                  //styling match
                  bottom: BorderSide(
                    color: lbGrey,
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                title: Text(indexInActualList.toString()),
                trailing: LineItemPopUpMenuButton(
                  lineItems: widget.lineItems,
                  index: indexInActualList,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

enum LineItemAction { delete, addImage }

class LineItemPopUpMenuButton extends StatelessWidget {
  LineItemPopUpMenuButton({
    @required this.lineItems,
    @required this.index,
  });

  final ValueNotifier<List<LineItem>> lineItems;
  final int index;

  deleteLineItem(int index) {
    //TODO: optimize this

    //make of copy of the list
    List<LineItem> lineItemsCopy = List<LineItem>.from(
      lineItems.value,
    );

    //edit the copy of the list
    lineItemsCopy.removeAt(index);

    //have the notifier update, which then updates state
    lineItems.value = lineItemsCopy;
  }

  addImage(int index) {
    print("Adding image to lineItem in index: " + index.toString());
  }

  @override
  Widget build(BuildContext context) {
    String text = "delete";
    IconData icon = Icons.delete;
    return PopupMenuButton<LineItemAction>(
      onSelected: (LineItemAction result) {
        if (result == LineItemAction.delete) {
          deleteLineItem(index);
        } else {
          addImage(index);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<LineItemAction>>[
        PopupMenuItem<LineItemAction>(
          value: LineItemAction.delete,
          child: IconText(
            icon: Icons.delete, 
            text: "delete",
          ),
        ),
        PopupMenuItem<LineItemAction>(
          value: LineItemAction.addImage,
          child: IconText(
            icon: FontAwesome.camera, 
            text: "add image",
          ),
        ),
      ],
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({
    Key key,
    @required this.icon,
    @required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: Icon(
            icon,
          ),
        ),
        Text(
          text,
        ),
      ],
    );
  }
}
