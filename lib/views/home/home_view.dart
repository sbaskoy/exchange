// ignore_for_file: unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kurtakip/controllers/exchange_controller.dart';
import 'package:kurtakip/models/exchange.dart';
import 'package:kurtakip/native/method_channel.dart';
import 'package:kurtakip/widgets/cards/currency_card.dart';
import 'package:kurtakip/widgets/forms/drop_down.dart';
import 'package:kurtakip/widgets/forms/text_form_field.dart';
import 'package:kurtakip/widgets/texts/error_text.dart';
import 'package:kurtakip/widgets/texts/title_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ExchangeController _exchangeController = new ExchangeController();
  final TextEditingController _fromController = new TextEditingController();
  final TextEditingController _toController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _exchangeController.getAllExchange();
    NativeChannel.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverAppBar(
          centerTitle: true,
          title: const TitleText(
            title: "Exchange",
            titleColor: Colors.white,
          ),
          pinned: true,
          floating: true,
          backgroundColor: Colors.pink,
          bottom: AppBar(
            backgroundColor: Colors.pink,
            elevation: 0,
            title: CupertinoSearchTextField(
              placeholder: "Ara",
              onChanged: _exchangeController.filter,
            ),
          ),
        )
      ],
      body: SizedBox(
        child: StreamBuilder<TarihDate>(
          stream: _exchangeController.tarihDate,
          builder: (c, snap) {
            if (snap.hasError) {
              return ErrorText(error: snap.error.toString());
            }
            if (snap.hasData) {
              var data = snap.data!;
              return _buildExchangeList(data);
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      ),
    ));
  }

  Widget _buildExchangeList(TarihDate data) {
    return Stack(
      children: [
        Column(
          children: [
            TitleText(title: data.tarih ?? ""),
            const Divider(),
            Expanded(
                child: RefreshIndicator(
              onRefresh: _exchangeController.getAllExchange,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: data.currency?.length ?? 0,
                itemBuilder: (c, index) {
                  var currency = data.currency![index];
                  return CurrencyCard(
                    currency: currency,
                  );
                },
              ),
            )),
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              height: 150,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: _fromController,
                          onChange: (String? val) => _exchangeController.convert(val, _toController),
                          margin: 8,
                          hint: "From",
                        ),
                      ),
                      CustomDropDown(
                          items: _exchangeController.getAllCurrency
                              .map((e) => CustomDropDownItem(e.kod ?? "", e.kod ?? ""))
                              .toList(),
                          onselected: (selected) {
                            _exchangeController.changeFrom(selected);
                            if (_fromController.text.isNotEmpty && _toController.text.isNotEmpty) {
                              _exchangeController.convert(_fromController.text, _toController);
                            }
                          })
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          controller: _toController,
                          hint: "To",
                          readOnly: true,
                          margin: 8,
                        ),
                      ),
                      CustomDropDown(
                          items: _exchangeController.getAllCurrency
                              .map((e) => CustomDropDownItem(e.kod ?? "", e.kod ?? ""))
                              .toList(),
                          onselected: (selected) {
                            _exchangeController.changeTo(selected);
                            _exchangeController.convert(_fromController.text, _toController);
                          }),
                    ],
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
