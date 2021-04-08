import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dinamik Not Hesaplama",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int derskredi = 1;
  double DersHarfDegeri = 4;
  List<Dersler> tumDersler;
  double ortalama = 0;
  static int sayac = 0;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
            }
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Dinamik not hesaplama"),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return DinamikNotHesaplama();
            } else {
              return DinamikNotHesaplamaLeant();
            }
          },
        ));
  }

  Widget DinamikNotHesaplama() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adı",
                      labelStyle: TextStyle(fontSize: 22),
                      hintText: "Ders Adını Giriniz",
                      hintStyle: TextStyle(fontSize: 20),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide:
                              BorderSide(color: Colors.black38, width: 2)),
                    ),
                    validator: (girilenDers) {
                      if (girilenDers.length < 4) {
                        return "Lütfen Ders Adi giriniz..";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (gelenDersAdi) {
                      dersAdi = gelenDersAdi;
                      setState(() {
                        tumDersler.add(Dersler(dersAdi, derskredi,
                            DersHarfDegeri, RasgeleRenkOlustur()));
                        ortalama = 0;
                        ortalamaHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: DersKredileri(),
                            value: derskredi,
                            onChanged: (secilenKredi) {
                              setState(() {
                                derskredi = secilenKredi;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black38,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: DersHarfDegerleri(),
                            value: DersHarfDegeri,
                            onChanged: (secilenHarfDegeri) {
                              setState(() {
                                DersHarfDegeri = secilenHarfDegeri;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // color: Colors.green,
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(color: Colors.black12, width: 2),
                bottom: BorderSide(color: Colors.black12, width: 2),
              ),
            ),
            height: 50,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: tumDersler.length == 0
                            ? "Lütfen Ders Ekleyiniz"
                            : "Not Ortalaması :",
                        style: TextStyle(fontSize: 16, color: Colors.black54)),
                    TextSpan(
                        text: tumDersler.length == 0
                            ? ""
                            : "${ortalama.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, color: Colors.black))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            //Dinamik Liste Tutan
            child: Container(
              // color: Colors.indigo,
              child: ListView.builder(
                itemBuilder: _tumDerslerListesi,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DersKredileri() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 0; i < 20; i++) {
      var kredi = DropdownMenuItem(
        value: i + 1,
        child: Text("${i + 1} Kredi"),
      );
      krediler.add(kredi);
    }

    return krediler;
  }

  List<DropdownMenuItem<double>> DersHarfDegerleri() {
    List<DropdownMenuItem<double>> DersHarflerim = [];
    DersHarflerim.add(DropdownMenuItem(
      child: Text(
        " AA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" BA ", style: TextStyle(fontSize: 20)),
      value: 3.5,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" BB ", style: TextStyle(fontSize: 20)),
      value: 3,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" CB ", style: TextStyle(fontSize: 20)),
      value: 2.5,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" CC ", style: TextStyle(fontSize: 20)),
      value: 2,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" DC ", style: TextStyle(fontSize: 20)),
      value: 1.5,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" DD ", style: TextStyle(fontSize: 20)),
      value: 1,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" FD ", style: TextStyle(fontSize: 20)),
      value: 0.5,
    ));
    DersHarflerim.add(DropdownMenuItem(
      child: Text(" FF ", style: TextStyle(fontSize: 20)),
      value: 0,
    ));
    return DersHarflerim;
  }

  Widget _tumDerslerListesi(BuildContext context, int index) {
    sayac++;
    Color olusanRasgeleRenk = RasgeleRenkOlustur();
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: tumDersler[index].renk, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(
            Icons.menu_book,
            color: tumDersler[index].renk,
          ),
          title: Text(tumDersler[index].DersAdi),
          subtitle: Text(tumDersler[index].DersKredi.toString() +
              " Kredi Not Degeri  " +
              tumDersler[index].DersHarfi.toString()),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: tumDersler[index].renk,
          ),
        ),
      ),
    );
  }

  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oankiDers in tumDersler) {
      var kredi = oankiDers.DersKredi;
      var not = oankiDers.DersHarfi;
      toplamNot = toplamNot + (not * kredi);
      toplamKredi = toplamKredi + kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color RasgeleRenkOlustur() {
    return Color.fromARGB(
        150 + Random().nextInt(105),
        150 + Random().nextInt(105),
        150 + Random().nextInt(105),
        150 + Random().nextInt(105));
  }

  Widget DinamikNotHesaplamaLeant() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              // color: Colors.orangeAccent,
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: "Ders Giriniz",
                            hintText: "Ders Giriniz...",
                            border: OutlineInputBorder(),
                          ),
                          validator: (girilenDers) {
                            if (girilenDers.length < 4) {
                              return "Lütfen 4 karakterden fazla giriniz...";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (girilenders) {
                            setState(() {
                              dersAdi = girilenders;

                              tumDersler.add(Dersler(dersAdi, derskredi,
                                  DersHarfDegeri, RasgeleRenkOlustur()));
                              ortalama = 0;
                              ortalamaHesapla();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 10, 5),
                        child: DropdownButton(
                          items: DersKredileri(),
                          value: derskredi,
                          onChanged: (secilenKredi) {
                            setState(() {
                              derskredi = secilenKredi;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 10, 5),
                        child: DropdownButton(
                          items: DersHarfDegerleri(),
                          value: DersHarfDegeri,
                          onChanged: (secilenHarf) {
                            setState(() {
                              DersHarfDegeri = secilenHarf;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: BorderDirectional(
                          top: BorderSide(color: Colors.black54, width: 2),
                          bottom: BorderSide(color: Colors.black54, width: 2),
                        ),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Ortalama :${ortalama.toStringAsFixed(2)}",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              //  color: Colors.greenAccent,
              child: ListView.builder(
                itemBuilder: _tumDerslerListesi,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Dersler {
  String DersAdi;
  int DersKredi;
  double DersHarfi;
  Color renk;

  Dersler(this.DersAdi, this.DersKredi, this.DersHarfi, this.renk);
}
