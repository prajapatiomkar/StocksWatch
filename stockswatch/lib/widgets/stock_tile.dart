import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockTile extends StatelessWidget {
  final Stock stock;

  const StockTile({Key? key, required this.stock}) : super(key: key);

  Color getChangeColor(BuildContext context, double change) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (change > 0) return isDark ?  Colors.greenAccent : Colors.green;
    if (change < 0) return isDark ? Colors.redAccent : Colors.red;
    return Theme.of(context).textTheme.labelLarge?.color ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? Colors.blueGrey : Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: stock.symbol,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.labelLarge?.color)),
                      TextSpan(
                          text: '  ${stock.expiry}',
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${stock.change.toStringAsFixed(2)} (${stock.changePercent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: getChangeColor(context, stock.change),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(stock.buyPrice.toStringAsFixed(2),
                      style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  SizedBox(width: 8),
                  Text(stock.sellPrice.toStringAsFixed(2),
                      style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text('H: ${stock.high.toStringAsFixed(2)} ',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color)),
                  Text('L: ${stock.low.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge?.color)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
