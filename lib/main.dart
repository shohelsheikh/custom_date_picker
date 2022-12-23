import 'package:custom_date_picker/date_picker/flutter_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:custom_date_picker/date_picker/date_picker_manager.dart';
import 'package:custom_date_picker/custom_date_picker_dialog.dart';
import 'package:custom_date_picker/utils/colors_utils.dart';
import 'package:custom_date_picker/utils/font_constant.dart';
import 'package:custom_date_picker/utils/image_paths.dart';
import 'package:custom_date_picker/widgets/wrap_text_button.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

/// State for MyApp
class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Calendar widgets",
          theme: ThemeData.light(),
          home: SampleDatePicker(),
        );
      },
    );
  }
}

class SampleDatePicker extends StatefulWidget {
  const SampleDatePicker({Key? key}) : super(key: key);

  @override
  State<SampleDatePicker> createState() => _SampleDatePickerState();
}

class _SampleDatePickerState extends State<SampleDatePicker> {
  DateTime? selectedDateWithoutPreset;
  DateTime? selectedDateWith4Preset;
  DateTime? selectedDateWith6Preset;
  String strNeverEnds = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Calendar widgets',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: FontConstant.roboto,
                          color: Colors.black,
                          fontSize: 16.sp),
                    ),

                    SizedBox(height: 10.h),

                    _withoutPreset(),

                    _with4Preset(),

                    _with6Preset(),


                  ]),
            ),
          ),


          _myName()

        ],
      ),
    );
  }

  Widget _withoutPreset() {
    return Column(

      children: [

        WrapTextButton('Without preset',
            height: 6.h,
            minWidth: 90.w,
            backgroundColor: ColorsUtils.colorPrimary,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontConstant.roboto,
                color: Colors.white,
                fontSize: 14.sp),
            onTap: () {
              showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: '',
                  barrierColor: Colors.black54,
                  pageBuilder: (context, animation,
                      secondaryAnimation) {
                    return Dialog(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child: CustomDatePickerDialog(
                          selectionMode: DateRangePickerSelectionMode.single,
                          dialog: 1,
                          setDateActionCallback: ({startDate, endDate}) {
                            setState(() {
                              selectedDateWithoutPreset = startDate;
                            });
                            Navigator.of(context).pop();
                          },
                        ));
                  });
            }),
        SizedBox(height: 2.h,),
        if(selectedDateWithoutPreset != null)
          Container(
            height: 4.h,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
                maxWidth: double.infinity),
            child: TextButton(
              onPressed: null,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<
                      Color>(
                          (Set<MaterialState> states) =>
                      ColorsUtils.colorButtonDisable1),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide.none)),
                  padding: MaterialStateProperty.resolveWith<
                      EdgeInsets>(
                          (Set<MaterialState> states) =>
                      const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6)),
                  elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) => 0)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 1.w,),

                  Image.asset(
                    ImagePaths.calendar_img1,
                    height: 5.h,
                    width: 4.w,
                  ),

                  SizedBox(width: 3.w,),

                  Text(
                    ' ${selectedDateWithoutPreset != null ? DateFormat(
                        'dd MMM yyyy')
                        .format(selectedDateWithoutPreset!) : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(
                        color: ColorsUtils.colorButton,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontConstant.roboto,
                        fontSize: 12),),

                  SizedBox(width: 3.w,),

                  InkWell(
                    onTap: () {
                      selectedDateWithoutPreset = null;
                      setState(() {

                      });
                    },
                    child: Image.asset(
                      'assets/images/closeimg.png',
                      height: 5.h,
                      width: 3.w,
                    ),
                  ),
                  SizedBox(width: 1.w,),


                ],
              ),
            ),
          ),

      ],

    );
  }


  Widget _with4Preset() {
    return Column(

      children: [

        SizedBox(height: 5.h),
        WrapTextButton('With 4 presets',
            height: 6.h,
            minWidth: 90.w,
            backgroundColor: ColorsUtils.colorPrimary,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontConstant.roboto,
                color: Colors.white,
                fontSize: 14.sp),
            onTap: () {
              showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: '',
                  barrierColor: Colors.black54,
                  pageBuilder: (context, animation,
                      secondaryAnimation) {
                    return Dialog(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child: CustomDatePickerDialog(
                          selectionMode: DateRangePickerSelectionMode.range,
                          dialog: 2,
                          setDateActionCallback: ({startDate, endDate}) {
                            setState(() {
                              selectedDateWith4Preset = startDate;
                              strNeverEnds = "";
                            });
                            Navigator.of(context).pop();
                          },


                          setDateActionCallbackNeverEnds: ({ neverEnds}) {
                            setState(() {
                              selectedDateWith4Preset = null;
                              strNeverEnds = neverEnds!;
                            });
                            Navigator.of(context).pop();
                          },


                        ));
                  });
            }),
        SizedBox(height: 2.h,),
        if(selectedDateWith4Preset != null)
          Container(
            height: 4.h,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
                maxWidth: double.infinity),
            child: TextButton(
              onPressed: null,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<
                      Color>(
                          (Set<MaterialState> states) =>
                      ColorsUtils.colorButtonDisable1),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide.none)),
                  padding: MaterialStateProperty.resolveWith<
                      EdgeInsets>(
                          (Set<MaterialState> states) =>
                      const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6)),
                  elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) => 0)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 1.w,),

                  Image.asset(
                    ImagePaths.calendar_img1,
                    height: 5.h,
                    width: 4.w,
                  ),

                  SizedBox(width: 3.w,),

                  Text(
                    ' ${selectedDateWith4Preset != null
                        ? DateFormat(
                        'dd MMM yyyy')
                        .format(selectedDateWith4Preset!)
                        : 'Never Ends Date Set'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(
                        color: ColorsUtils.colorButton,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontConstant.roboto,
                        fontSize: 12),),

                  SizedBox(width: 3.w,),

                  InkWell(
                    onTap: () {
                      selectedDateWith4Preset = null;
                      strNeverEnds = "";

                      setState(() {

                      });
                    },
                    child: Image.asset(
                      'assets/images/closeimg.png',
                      height: 5.h,
                      width: 3.w,
                    ),
                  ),
                  SizedBox(width: 1.w,),


                ],
              ),
            ),
          )
        else
          if(strNeverEnds != "")
            Container(
              height: 4.h,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                  maxWidth: double.infinity),
              child: TextButton(
                onPressed: null,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<
                        Color>(
                            (Set<MaterialState> states) =>
                        ColorsUtils.colorButtonDisable1),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide.none)),
                    padding: MaterialStateProperty.resolveWith<
                        EdgeInsets>(
                            (Set<MaterialState> states) =>
                        const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6)),
                    elevation: MaterialStateProperty.resolveWith<double>(
                            (Set<MaterialState> states) => 0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 1.w,),

                    Image.asset(
                      ImagePaths.calendar_img1, height: 5.h,
                      width: 4.w,
                    ),

                    SizedBox(width: 3.w,),

                    Text(
                      strNeverEnds,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(
                          color: ColorsUtils.colorButton,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontConstant.roboto,
                          fontSize: 12),),

                    SizedBox(width: 3.w,),

                    InkWell(
                      onTap: () {
                        strNeverEnds = "";
                        selectedDateWith4Preset = null;
                        setState(() {

                        });
                      },
                      child: Image.asset(
                        'assets/images/closeimg.png',
                        height: 5.h,
                        width: 3.w,
                      ),
                    ),
                    SizedBox(width: 1.w,),


                  ],
                ),
              ),
            ),
      ],
    );
  }


  Widget _with6Preset() {
    return Column(

      children: [


        SizedBox(height: 5.h),
        WrapTextButton('With 6 presets',
            height: 6.h,
            minWidth: 90.w,
            backgroundColor: ColorsUtils.colorPrimary,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontConstant.roboto,
                color: Colors.white,
                fontSize: 14.sp),
            onTap: () {
              showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: '',
                  barrierColor: Colors.black54,
                  pageBuilder: (context, animation,
                      secondaryAnimation) {
                    return Dialog(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        child: CustomDatePickerDialog(
                          selectionMode: DateRangePickerSelectionMode.range,
                          dialog: 3,
                          setDateActionCallback: ({startDate}) {
                            setState(() {
                              selectedDateWith6Preset = startDate;
                            });
                            Navigator.of(context).pop();
                          },
                        ));
                  });
            }),
        SizedBox(height: 2.h,),
        if(selectedDateWith6Preset != null)
          Container(
            height: 4.h,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
                maxWidth: double.infinity),
            child: TextButton(
              onPressed: null,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<
                      Color>(
                          (Set<MaterialState> states) =>
                      ColorsUtils.colorButtonDisable1),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide.none)),
                  padding: MaterialStateProperty.resolveWith<
                      EdgeInsets>(
                          (Set<MaterialState> states) =>
                      const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6)),
                  elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) => 0)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 1.w,),

                  Image.asset(
                    ImagePaths.calendar_img1, height: 5.h,
                    width: 4.w,
                  ),

                  SizedBox(width: 3.w,),

                  Text(
                    ' ${selectedDateWith6Preset != null ? DateFormat(
                        'dd MMM yyyy')
                        .format(selectedDateWith6Preset!) : ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(
                        color: ColorsUtils.colorButton,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontConstant.roboto,
                        fontSize: 12),),

                  SizedBox(width: 3.w,),

                  InkWell(
                    onTap: () {
                      selectedDateWith6Preset = null;
                      setState(() {

                      });
                    },
                    child: Image.asset(
                      'assets/images/closeimg.png',
                      height: 5.h,
                      width: 3.w,
                    ),
                  ),
                  SizedBox(width: 1.w,),


                ],
              ),
            ),
          ),

      ],
    );
  }

  Widget _myName() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child:
      Center(
        child: Text(
          'Name: Shohel Sheikh',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: FontConstant.roboto,
              color: Colors.black,
              fontSize: 13.sp),
        ),
      ),
    );
  }


}
