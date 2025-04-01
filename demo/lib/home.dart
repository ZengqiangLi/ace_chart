import 'package:ace_chart/ace_chart.dart';
import 'package:demo/data.dart';
import 'package:demo/data2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color backgroundColor = Color(0xff151924);
const Color textColor = Colors.white;
const TextStyle style = TextStyle(color: textColor);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

int ii = 0;

class _HomeState extends State<Home> {
  final AceStockMetricController container = AceStockMetricController(
    useVOLMA: true,
    useMACD: true,
    maxLength: list.length,
    // maDays: [5],
    pointWidth: 7,
    useKdj: true,
  );
  final AceStockMetricController container3 = AceStockMetricController(
    useVOLMA: true,
    useMACD: true,
    maxLength: 1,
    pointWidth: 1,
    pointSpace: 1,
    maDays: [],
    useKdj: true,
  );

  @override
  void initState() {
    super.initState();
    container.addAll(list);
    container3.addAll(list2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DEMO",
          style: style,
        ),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AceContainer(
              controller: container3,
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Container(
                        height: 10,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 150,
                        child: LineChart(
                          useShader: true,
                          transformTime: (time) {
                            return millisToHM(time);
                          },
                          lineColor: const Color(0xff697abc),
                          lastClose: 255.90,
                          gridVerticalGrids: 1,
                          gridHorizontalGrids: 2,
                          paddingTop: 20,
                          centralAxisStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          gridLineColor: Colors.white12,
                          crossLineColor: const Color(0xffd13e51),
                          crossTextBgColor: const Color(0xffd13e51),
                          horizontalTextStyle: const TextStyle(
                            color: Color(0xff959FAE),
                            fontSize: 8,
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 40,
                        child: VolChart(
                          showMaLine: true,
                          showText: false,
                          upperStyle: PaintingStyle.stroke,
                        ),
                      ),
                      Container(
                        height: 10,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        height: 80,
                        child: MacdChart(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 10,
              margin: const EdgeInsets.symmetric(vertical: 3),
              color: Colors.black,
            ),
            Container(
              color: Colors.black12,
              child: AceContainer(
                controller: container,
                child: Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: KChart(
                            highMarkColor: Colors.white,
                            lowMarkColor: Colors.white,
                            crossLineColor: const Color(0xffd13e51),
                            crossTextBgColor: const Color(0xffd13e51),
                            gridTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            gridLineColor: Colors.white12,
                            horizontalTextStyle: const TextStyle(
                              color: Color(0xff959FAE),
                              fontSize: 8,
                            ),
                            transformTime: (time) {
                              return millisToMD(time);
                            },
                            onCrossChange: (index, alignment) {
                              if (index == -1) {
                                return;
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 10,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 40,
                          child: VolChart(
                            showMaLine: true,
                            showText: false,
                            upperStyle: PaintingStyle.stroke,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          height: 10,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 80,
                          child: MacdChart(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          height: 10,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 80,
                          child: CapitalFlowChart(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            valueTextFontSize: 8,
                            showText: false,
                            transformBarStyle: (item) {
                              if (item.flow < 0) {
                                return BarStyle.upper;
                              } else {
                                return BarStyle.lower;
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
