import 'package:flutter/material.dart';
import 'package:kurtakip/models/exchange.dart';
import 'package:kurtakip/widgets/badge/badge.dart';
import 'package:kurtakip/widgets/texts/custom_text.dart';

class CurrencyCard extends StatefulWidget {
  final Currency currency;
  const CurrencyCard({Key? key, required this.currency}) : super(key: key);

  @override
  State<CurrencyCard> createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  bool _isForex = true;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomText(
                text: widget.currency.kod ?? "",
                fontSize: 18,
                color: Colors.redAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomText(
                text: widget.currency.currencyName ?? "",
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                _buildBuySellContainer(
                    "Alış: ",
                    _isForex ? (widget.currency.forexBuying ?? "") : (widget.currency.banknoteBuying ?? ""),
                    Colors.green),
                _buildBuySellContainer(
                    "Satış: ",
                    _isForex ? (widget.currency.forexSelling ?? "") : (widget.currency.banknoteSelling ?? ""),
                    Colors.redAccent),
                const Spacer(),
                CustomBadge(
                  text: "Forex",
                  color: _isForex ? Colors.green : null,
                  onPressed: () {
                    setState(() {
                      _isForex = true;
                    });
                  },
                ),
                CustomBadge(
                  text: "Banknote",
                  color: _isForex ? null : Colors.green,
                  onPressed: () {
                    setState(() {
                      _isForex = false;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBuySellContainer(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          CustomText(
            text: title,
            fontSize: 10,
          ),
          CustomText(
            text: value,
            fontSize: 12,
            color: color,
          )
        ],
      ),
    );
  }
}
