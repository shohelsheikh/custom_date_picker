import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:custom_date_picker/model/date_selection_type.dart';
import 'package:custom_date_picker/utils/colors_utils.dart';
import 'package:custom_date_picker/utils/font_constant.dart';
import 'package:custom_date_picker/utils/image_paths.dart';
 import 'package:custom_date_picker/widgets/wrap_text_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:sizer/sizer.dart';

import 'date_picker/date_picker.dart';
import 'date_picker/date_picker_manager.dart';

typedef SetDateActionCallback = Function({DateTime? startDate});
typedef SetDateActionCallbackNeverEnds = Function({String? neverEnds});

class CustomDatePickerDialog extends StatefulWidget {
  final int dialog;
  final String? last7daysTitle;
  final String? last30daysTitle;
  final String? last6monthsTitle;
  final String? lastYearTitle;
  final SetDateActionCallback? setDateActionCallback;
  final SetDateActionCallbackNeverEnds? setDateActionCallbackNeverEnds;
  final DateRangePickerController? datePickerController;
  final TextEditingController? startDateInputController;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Widget>? customDateRangeButtons;
  final DateRangePickerSelectionMode selectionMode;

  const CustomDatePickerDialog(
      {Key? key,
      this.selectionMode = DateRangePickerSelectionMode.single,
      this.dialog = 1,
      this.last7daysTitle,
      this.last30daysTitle,
      this.last6monthsTitle,
      this.lastYearTitle,
      this.startDate,
      this.endDate,
      this.setDateActionCallback,
      this.setDateActionCallbackNeverEnds,
      this.datePickerController,
      this.startDateInputController,
      this.customDateRangeButtons})
      : super(key: key);

  @override
  State<CustomDatePickerDialog> createState() =>
      _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState
    extends State<CustomDatePickerDialog> {
  final String dateTimePattern = 'dd/MM/yyyy';
  final String dateTimePattern2 = 'dd MMM yyyy';

  late DateRangePickerController _datePickerController;

  DateTime? _startDate;
  late Debouncer _denounceStartDate, _denounceEndDate;
  String startDateString = "";

  bool neverends = false;
  bool after15days = false;
  bool after30days = false;
  bool after60days = false;

  bool yesterday = false;
  bool today = false;
  bool tomorrow = false;
  bool thisSaturday = false;
  bool thisSunday = false;
  bool nextTuesday = false;

  int selection = 1;

  DateRangePickerSelectionMode selectionMode =
      DateRangePickerSelectionMode.single;

  @override
  void initState() {
    selectionMode=widget.selectionMode;
    _datePickerController =
        widget.datePickerController ?? DateRangePickerController();
    _startDate = widget.startDate ?? DateTime.now();
    _initDebounceTimeForDate();
    _updateDateTextInput();
    super.initState();
  }

  void _initDebounceTimeForDate() {
    _denounceStartDate =
        Debouncer<String>(const Duration(milliseconds: 300), initialValue: '');
    _denounceEndDate =
        Debouncer<String>(const Duration(milliseconds: 300), initialValue: '');

    _denounceStartDate.values.listen((value) => _onStartDateTextChanged(value));
    _denounceEndDate.values.listen((value) => _onEndDateTextChanged(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: ColorsUtils.colorShadow,
                spreadRadius: 32,
                blurRadius: 32,
                offset: Offset.zero),
            BoxShadow(
                color: ColorsUtils.colorShadow,
                spreadRadius: 12,
                blurRadius: 12,
                offset: Offset.zero)
          ]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        widget.dialog == 2 || widget.dialog == 3
            ? Container(
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
                child: Column(children: [
                  widget.dialog == 2
                      ? SizedBox(
                          height: 2.h,
                        )
                      : Container(),
                  widget.dialog == 2
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: neverends
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: neverends
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "Never ends", onTap: () {
                              neverends = true;
                              after15days = false;
                              after30days = false;
                              after60days = false;

                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;

                              widget.setDateActionCallbackNeverEnds?.call(
                                  neverEnds: "Date is set to never ends");
                            }),
                            SizedBox(width: 2.w),
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: after15days
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: after15days
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "15 days later", onTap: () {
                              neverends = false;
                              after15days = true;
                              after30days = false;
                              after60days = false;

                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.after15days);
                            })
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 2.h,
                  ),
                  widget.dialog == 2
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: after30days
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: after30days
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "30 days later", onTap: () {
                              neverends = false;
                              after15days = false;
                              after30days = true;
                              after60days = false;

                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.after30days);
                            }),
                            SizedBox(width: 2.w),
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: after60days
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: after60days
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "60 days later", onTap: () {
                              neverends = false;
                              after15days = false;
                              after30days = false;
                              after60days = true;

                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.after60days);
                            })
                          ],
                        )
                      : Container(),
                  widget.dialog == 3
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: yesterday
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: yesterday
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "Yesterday", onTap: () {
                              yesterday = true;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.yesterday);
                            }),
                            SizedBox(width: 2.w),
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: today
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: today
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "Today", onTap: () {
                              yesterday = false;
                              today = true;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.today);
                            })
                          ],
                        )
                      : Container(),
                  widget.dialog == 3
                      ? SizedBox(
                          height: 2.h,
                        )
                      : Container(),
                  widget.dialog == 3
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: tomorrow
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: tomorrow
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "Tomorrow", onTap: () {
                              yesterday = false;
                              today = false;
                              tomorrow = true;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.tomorrow);
                            }),
                            SizedBox(width: 2.w),
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: thisSaturday
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: thisSaturday
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "This Saturday", onTap: () {
                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = true;
                              thisSunday = false;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.thisSaturday);
                            })
                          ],
                        )
                      : Container(),
                  widget.dialog == 3
                      ? SizedBox(
                          height: 2.h,
                        )
                      : Container(),
                  widget.dialog == 3
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: thisSunday
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: thisSunday
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "This Sunday", onTap: () {
                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = true;
                              nextTuesday = false;
                              setState(() {});

                              _selectDateRange(DateSelectionType.thisSunday);
                            }),
                            SizedBox(width: 2.w),
                            WrapTextButton(
                                minWidth: 34.w,
                                textStyle: TextStyle(
                                    color: nextTuesday
                                        ? Colors.white
                                        : ColorsUtils.colorButton,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontConstant.roboto,
                                    fontSize: 12),
                                radius: 5,
                                backgroundColor: nextTuesday
                                    ? ColorsUtils.colorButton
                                    : ColorsUtils.colorButtonDisable1,
                                "Next Tuesday", onTap: () {
                              yesterday = false;
                              today = false;
                              tomorrow = false;
                              thisSaturday = false;
                              thisSunday = false;
                              nextTuesday = true;
                              setState(() {});

                              _selectDateRange(DateSelectionType.nextTuesday);
                            })
                          ],
                        )
                      : Container()
                ]),
              )
            : Container(),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: SfDateRangePicker(
                controller: _datePickerController,
                onSelectionChanged: _onSelectionChanged,
                view: DateRangePickerView.month,
                selectionMode: selectionMode,
                initialDisplayDate: _startDate,
                initialSelectedRange: PickerDateRange(_startDate, _startDate),
                enableMultiView: false,
                enablePastDates: true,
                viewSpacing: 16,
                headerHeight: 52,
                // backgroundColor: Colors.white,
                selectionShape: DateRangePickerSelectionShape.circle,
                showNavigationArrow: true,
                selectionRadius: 25,
                monthViewSettings: DateRangePickerMonthViewSettings(
                    dayFormat: 'E',

                    // firstDayOfWeek: 1,
                    viewHeaderHeight: 48,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: FontConstant.roboto,
                            color: ColorsUtils.colorHederText,
                            fontSize: 11.sp))),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  cellDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  todayTextStyle: const TextStyle(
                      color: ColorsUtils.colorButton,
                      fontWeight: FontWeight.bold),
                  disabledDatesTextStyle: const TextStyle(
                      color: ColorsUtils.colorButton,
                      fontWeight: FontWeight.bold),
                ),
                headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                        fontFamily: FontConstant.roboto,
                        color: ColorsUtils.colorHederText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500)),
                rangeSelectionColor: Colors.transparent)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10),
          child: _buildBottomView(context),
        ),
        SizedBox(
          height: 2.h,
        )
      ]),
    );
  }

  Widget _buildBottomView(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            ImagePaths.calendar_img,
            height: 2.5.h,
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: Text(
              DateFormat(dateTimePattern2).format(_startDate!),
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: FontConstant.roboto,
                  color: ColorsUtils.colorHederText,
                  fontSize: 12.sp),
            ),
          ),
        ],
      )),
      SizedBox(
        width: 5.w,
      ),
      WrapTextButton(
        "Cancel",
        textStyle: const TextStyle(
            color: ColorsUtils.colorButton,
            fontWeight: FontWeight.w500,
            fontFamily: FontConstant.roboto,
            fontSize: 12),
        radius: 5,
        backgroundColor: ColorsUtils.colorButtonDisable1,
        onTap: () => Navigator.of(context).pop(),
      ),
      SizedBox(
        width: 2.w,
      ),
      WrapTextButton(
        "Save",
        textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: FontConstant.roboto,
            fontSize: 10.sp),
        radius: 5,
        backgroundColor: ColorsUtils.colorButton,
        onTap: () => widget.setDateActionCallback?.call(startDate: _startDate),
      ),
    ]);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {



    if (args.value is PickerDateRange) {
      _startDate = args.value.startDate;
      _updateDateTextInput();
    } else {
      _startDate = args.value;
    }

    setState(() {

    });


  }

  void _onStartDateTextChanged(String value) {
    if (value.isNotEmpty && !value.contains('-')) {
      final startDate = DateFormat(dateTimePattern).parse(value);
      _startDate = startDate;
      _updateDatePickerSelection();
    }
  }

  void _onEndDateTextChanged(String value) {
    if (value.isNotEmpty && !value.contains('-')) {
      final endDate = DateFormat(dateTimePattern).parse(value);
      _updateDatePickerSelection();
    }
  }

  void _selectDateRange(DateSelectionType dateRangeType) {
    switch (dateRangeType) {
      case DateSelectionType.neverends:
        final today = DateTime.now();
        _startDate = today;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;

      case DateSelectionType.after15days:
        final today = DateTime.now();
        final after15days = today.add(const Duration(days: 15));
        _startDate = after15days;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateSelectionType.after30days:
        final today = DateTime.now();
        final after30days = today.add(const Duration(days: 30));
        _startDate = after30days;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateSelectionType.after60days:
        final today = DateTime.now();
        final after60days = today.add(const Duration(days: 60));
        _startDate = after60days;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;

      case DateSelectionType.yesterday:
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));
        _startDate = yesterday;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateSelectionType.today:
        final today = DateTime.now();
        _startDate = today;
        _updateDateTextInput();
        _updateDatePickerSelection();

        break;
      case DateSelectionType.tomorrow:
        final today = DateTime.now();
        final tomorrow = today.add(const Duration(days: 1));
        _startDate = tomorrow;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateSelectionType.thisSaturday:
        // TODO: Handle this case.

        final thisSaturday = getFirstDayOfWeek();
        final saturday = thisSaturday.add(const Duration(days: 6));
        _startDate = saturday;
        _updateDateTextInput();
        _updateDatePickerSelection();
        print(saturday);

        break;
      case DateSelectionType.thisSunday:
        // TODO: Handle this case.

        final thisSunday = getFirstDayOfWeek();
        _startDate = thisSunday;
        _updateDateTextInput();
        _updateDatePickerSelection();
        print(thisSunday);

        break;
      case DateSelectionType.nextTuesday:
        // TODO: Handle this case.

        final nextTuesday = getFirstDayOfWeek();
        final tuesday = nextTuesday.add(const Duration(days: 9));
        _startDate = tuesday;
        _updateDateTextInput();
        _updateDatePickerSelection();
        print(tuesday);

        break;
    }
  }

  Future<void> _updateDatePickerSelection() async {
    _datePickerController.selectedRange =
        PickerDateRange(_startDate, _startDate);
    _datePickerController.displayDate = _startDate;
  }

  void _updateDateTextInput() {
    if (_startDate != null) {
      startDateString = DateFormat(dateTimePattern).format(_startDate!);
    } else {
    }
    setState(() {});
  }

  bool _isVerticalArrangement(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  @override
  void dispose() {
    _denounceStartDate.cancel();
    _denounceEndDate.cancel();
    _datePickerController.dispose();
    super.dispose();
  }

  DateTime getFirstDayOfWeek() {
    DateTime today = DateTime.now();
    DateTime _firstDayOfTheweek =
        today.subtract(new Duration(days: today.weekday));
    DateFormat(DateFormat.WEEKDAY).format(_firstDayOfTheweek); // Tuesday
    print(DateFormat(DateFormat.WEEKDAY).format(_firstDayOfTheweek));
    print(_firstDayOfTheweek);

    return _firstDayOfTheweek;
  }
}
