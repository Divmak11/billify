import '../model/item_details.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
class PdfMaker extends StatelessWidget {

  double itemFontSize = 16;
  double titleFontSize =18;
  double itemTitleWith = 160;
  double itemQuantityWidth = 120;
  double itemAmountWidth = 100;
  double itemTitleSizeBoxWidth = 30;
  double itemQuantitySizeBoxWidth = 60;


  pw.Document makePdf({String name,String id,String timeStamp,List<ItemDetails> items,String total})
  {
    int roundedMoney = double.parse(total).round();
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(0.0),
            child: pw.Column(
              children: [
                pw.Row(
                    children: [
                      pw.Text('BILLIFY',
                          style: pw.TextStyle(
                              color: PdfColors.brown,
                              fontSize: 26,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Expanded(child: pw.Container()),
                      pw.Text('INVOICE',
                          style: pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 32,
                              fontWeight: pw.FontWeight.bold)),
                    ]
                ),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 20,),
                pw.Row(
                  children:[
                    pw.Text('Recipient ID: ',
                        style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold)
                    ),
                    pw.Text(id.substring(20,id.length),
                        style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.normal)
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Row(
                      children:[
                        pw.Text('Recipient Name: ',
                            style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)
                        ),
                        pw.Text(
                            name,
                            style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.normal)
                        ),
                      ],
                    ),
                    pw.Expanded(child: pw.Container(),),
                    pw.Row(
                      children:[
                        pw.Text('Dated: ',
                            style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold)
                        ),
                        pw.Text(DateFormat('yyyy-MM-dd kk:mm').format(DateTime.parse(timeStamp)),
                            style: pw.TextStyle(
                                color: PdfColors.black,
                                fontSize: 16,
                                fontWeight: pw.FontWeight.normal)
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40,),
                pw.Container(
                  height: 35,
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                      color: PdfColor(0,0.7,0),
                      border: pw.BoxBorder(
                        color: PdfColor(0, 0.7, 0),
                      ),
                      shape: pw.BoxShape.rectangle
                  ),
                  child:  pw.Row(
                    children: [
                      pw.SizedBox(width: 5),
                      pw.Text('Description',
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: titleFontSize,
                              fontBold: pw.Font.courierBold(),
                              fontWeight: pw.FontWeight.normal)
                      ),
                      pw.Spacer(flex: 2,),
                      pw.Text('Quantity',
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: titleFontSize,
                              fontBold: pw.Font.courierBold(),
                              fontWeight: pw.FontWeight.normal)
                      ),
                      pw.Spacer(flex: 1,),
                      pw.Text('Amount',
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: titleFontSize,
                              fontBold: pw.Font.courierBold(),
                              fontWeight: pw.FontWeight.normal)
                      ),
                      pw.SizedBox(width: 5),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10,),
                pw.ListView.builder(
                  itemCount: items.length,
                    itemBuilder: (ctx,index)
                {
                  double itemPrice = items[index].price * items[index].counter;
                  return  pw.Column(
                    children:[
                      pw.Row(
                        children: [
                          pw.Container(
                              width: itemTitleWith,
                              child: pw.Text(items[index].name,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold)
                              )),
                          pw.SizedBox(
                            width: itemTitleSizeBoxWidth,
                          ),
                          pw.Container(
                              width: itemQuantityWidth,
                              child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(items[index].counter.toString(),
                                      style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold)
                                  ))),
                          pw.SizedBox(
                            width: itemQuantitySizeBoxWidth,
                          ),
                          pw.Container(
                              width: itemAmountWidth,
                              child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(itemPrice.toStringAsFixed(2),
                                      style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold)
                                  ))),
                        ],
                      ),
                    ],
                  );
                }
                ),
                pw.SizedBox(height: 5,),
                pw.Divider(color: PdfColor(0,0.7,0),thickness: 2,),
                pw.Column(
                  children:[
                    pw.Row(
                      children: [
                        pw.Container(
                            width: itemTitleWith,
                          ),
                        pw.SizedBox(
                          width: itemTitleSizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemQuantityWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text('Subtotal',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                        pw.SizedBox(
                          width: itemQuantitySizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemAmountWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(
                                    total,
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  children:[
                    pw.Row(
                      children: [
                        pw.Container(
                            width: itemTitleWith,
                        ),
                        pw.SizedBox(
                          width: itemTitleSizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemQuantityWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text('Discount',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                        pw.SizedBox(
                          width: itemQuantitySizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemAmountWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text('0',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 1,color: PdfColors.grey,),
                pw.Column(
                  children:[
                    pw.Row(
                      children: [
                        pw.Container(
                            width: itemTitleWith,
                        ),
                        pw.SizedBox(
                          width: itemTitleSizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemQuantityWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text('Total',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                        pw.SizedBox(
                          width: itemQuantitySizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemAmountWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text(roundedMoney.toString(),
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  children:[
                    pw.Row(
                      children: [
                        pw.Container(
                          width: itemTitleWith,
                        ),
                        pw.SizedBox(
                          width: itemTitleSizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemQuantityWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text('Balance Due',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: 18,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                        pw.SizedBox(
                          width: itemQuantitySizeBoxWidth,
                        ),
                        pw.Container(
                            width: itemAmountWidth,
                            child: pw.Align(
                                alignment: pw.Alignment.centerRight,
                                child: pw.Text('Rs $roundedMoney',
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: itemFontSize,
                                        fontWeight: pw.FontWeight.bold)
                                ))),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 50,),
                pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text("Note",
                        style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: itemFontSize,
                            fontWeight: pw.FontWeight.bold))),
                pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('If You have any query regarding this bill,Kindly Contact Supplier',
                        style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: itemFontSize,
                            fontWeight: pw.FontWeight.bold)))
              ],
            ),
          );
        })); // Page

    return pdf;
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//make container for items
