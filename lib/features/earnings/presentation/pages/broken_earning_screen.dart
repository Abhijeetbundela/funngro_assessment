// import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';
// import 'package:material_ui/material_ui.dart';
//
// class BrokenEarningsScreen extends StatefulWidget {
//   final String userId;
//   const BrokenEarningsScreen({super.key, required this.userId});
//
//   @override
//   State<BrokenEarningsScreen> createState() => _BrokenEarningsScreenState();
// }
//
// class _BrokenEarningsScreenState extends State<BrokenEarningsScreen> {
//   List<Earning> earnings = [];
//   bool loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     api.fetchEarnings(widget.userId).then((data) {
//       setState(() {
//         earnings = data;
//         loading = false;
//       });
//     });
//
//     api.walletUpdates(widget.userId).listen((update) {
//       setState(() {
//         earnings.insert(0, update.toEarning());
//       });
//     });
//
//     return Scaffold(
//       appBar: AppBar(title: Text('My Earnings')),
//       body: loading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Column(
//           children: earnings.map((e) {
//             final formatted = formatCurrency(e.amount); // parses locale data, ~3ms
//             return EarningTile(
//               earning: e,
//               subtitle: formatted,
//               onTap: () async {
//                 final detail = await api.fetchDetail(e.id);
//                 setState(() {
//                   e.detail = detail;
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => DetailScreen(detail: detail),
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
