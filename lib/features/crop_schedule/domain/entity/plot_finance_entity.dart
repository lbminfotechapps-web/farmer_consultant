import 'package:equatable/equatable.dart';

class PlotFinanceEntity extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double profit;
  final bool status;
  final List<PlotFinanceItemEntity> result;
  final String message;

  const PlotFinanceEntity({
    required this.totalIncome,
    required this.totalExpense,
    required this.profit,
    required this.status,
    required this.result,
    required this.message,
  });

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        profit,
        status,
        result,
        message,
      ];
}

class PlotFinanceItemEntity extends Equatable {
  final String date;
  final double amount;
  final String remark;
  final String farmerId;
  final String plotId;
  final String type;
  final double acre;
  final String plotName;
  final String farmerName;
  final String cropName;
  final String plotFinanceId;

  const PlotFinanceItemEntity({
    required this.date,
    required this.amount,
    required this.remark,
    required this.farmerId,
    required this.plotId,
    required this.type,
    required this.acre,
    required this.plotName,
    required this.farmerName,
    required this.cropName,
    required this.plotFinanceId,
  });

  bool get isIncome => type.toLowerCase() == 'income';

  bool get isExpense => type.toLowerCase() == 'expense';

  @override
  List<Object?> get props => [
        date,
        amount,
        remark,
        farmerId,
        plotId,
        type,
        acre,
        plotName,
        farmerName,
        cropName,
        plotFinanceId,
      ];
}