import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kurtakip/controllers/exchange_controller.dart';
import 'package:kurtakip/models/exchange.dart';
import 'package:kurtakip/services/exchange.dart';
import 'package:kurtakip/widgets/cards/currency_card.dart';
import 'package:kurtakip/widgets/texts/error_text.dart';
import 'package:kurtakip/widgets/texts/title_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ExchangeController _exchangeController = new ExchangeController();

  @override
  void initState() {
    super.initState();
    _exchangeController.getAllExchange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exchange"),
      ),
      body: SafeArea(
        child: Center(
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
            return const CircularProgressIndicator.adaptive();
          },
        )),
      ),
    );
  }

  Widget _buildExchangeList(TarihDate data) {
    return Column(
      children: [
        TitleText(title: data.tarih ?? ""),
        const Divider(),
        Expanded(
            child: RefreshIndicator(
          onRefresh: _exchangeController.getAllExchange,
          child: ListView.builder(
            itemCount: data.currency?.length ?? 0,
            itemBuilder: (c, index) {
              var currency = data.currency![index];
              return CurrencyCard(
                currency: currency,
              );
            },
          ),
        ))
      ],
    );
  }
}
