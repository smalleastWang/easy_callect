import 'package:flutter/material.dart';

OverlayEntry? dropDownMenuOverlayEntry;

dropDownMenuOverlayEntryRemove() {
  if (dropDownMenuOverlayEntry != null) {
    dropDownMenuOverlayEntry!.remove();
    dropDownMenuOverlayEntry = null;
  }
}

OverlayEntry? dropDownMenuRangeDateOverlayEntry;

dropDownMenuRangeDateOverlayEntryRemove() {
  if (dropDownMenuRangeDateOverlayEntry != null) {
    dropDownMenuRangeDateOverlayEntry!.remove();
    dropDownMenuRangeDateOverlayEntry = null;
  }
}


overlayEntryAllRemove() {
  if (dropDownMenuOverlayEntry != null) {
    dropDownMenuOverlayEntry!.remove();
    dropDownMenuOverlayEntry = null;
  }
  if (dropDownMenuRangeDateOverlayEntry != null) {
    dropDownMenuRangeDateOverlayEntry!.remove();
    dropDownMenuRangeDateOverlayEntry = null;
  }
}