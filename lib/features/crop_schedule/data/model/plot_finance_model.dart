import '../../domain/entity/plot_finance_entity.dart';

class PlotFinanceModel extends PlotFinanceEntity {
  const PlotFinanceModel({
    required super.totalIncome,
    required super.totalExpense,
    required super.profit,
    required super.status,
    required super.result,
    required super.message,
  });

  factory PlotFinanceModel.fromJson(Map<String, dynamic> json) {
    return PlotFinanceModel(
      totalIncome: _toDouble(json['total_income']),
      totalExpense: _toDouble(json['total_expense']),
      profit: _toDouble(json['profit']),
      status: _toBool(json['status']),
      result: (json['result'] is List)
          ? (json['result'] as List)
              .whereType<Map>()
              .map(
                (item) => PlotFinanceItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      message: _toString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'profit': profit,
      'status': status,
      'result': result.map((item) {
        return {
          'fld_date': item.date,
          'fld_amount': item.amount.toStringAsFixed(2),
          'fld_remark': item.remark,
          'fld_farmer_id': item.farmerId,
          'fld_plot_id': item.plotId,
          'fld_type': item.type,
          'fld_acre': item.acre.toStringAsFixed(2),
          'fld_plot_name': item.plotName,
          'fld_farmer_name': item.farmerName,
          'fld_crop_name': item.cropName,
          'fld_plot_finance_id': item.plotFinanceId,
        };
      }).toList(),
      'message': message,
    };
  }
}

class PlotFinanceItemModel extends PlotFinanceItemEntity {
  const PlotFinanceItemModel({
    required super.date,
    required super.amount,
    required super.remark,
    required super.farmerId,
    required super.plotId,
    required super.type,
    required super.acre,
    required super.plotName,
    required super.farmerName,
    required super.cropName,
    required super.plotFinanceId,
  });

  factory PlotFinanceItemModel.fromJson(Map<String, dynamic> json) {
    return PlotFinanceItemModel(
      date: _toString(json['fld_date']),
      amount: _toDouble(json['fld_amount']),
      remark: _toString(json['fld_remark']),
      farmerId: _toString(json['fld_farmer_id']),
      plotId: _toString(json['fld_plot_id']),
      type: _toString(json['fld_type']),
      acre: _toDouble(json['fld_acre']),
      plotName: _toString(json['fld_plot_name']),
      farmerName: _toString(json['fld_farmer_name']),
      cropName: _toString(json['fld_crop_name']),
      plotFinanceId: _toString(json['fld_plot_finance_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fld_date': date,
      'fld_amount': amount.toStringAsFixed(2),
      'fld_remark': remark,
      'fld_farmer_id': farmerId,
      'fld_plot_id': plotId,
      'fld_type': type,
      'fld_acre': acre.toStringAsFixed(2),
      'fld_plot_name': plotName,
      'fld_farmer_name': farmerName,
      'fld_crop_name': cropName,
      'fld_plot_finance_id': plotFinanceId,
    };
  }
}

// ============================================================
// SAFE JSON CONVERSION HELPERS
// ============================================================

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();

  return double.tryParse(value.toString().trim()) ?? 0.0;
}

String _toString(dynamic value) {
  return value?.toString() ?? '';
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;

  final text = value?.toString().toLowerCase().trim();

  return text == 'true' || text == '1';
}