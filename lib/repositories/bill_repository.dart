import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:rent_bill_maker/models/bill/bill_model.dart';
import 'package:rent_bill_maker/utils/constants.dart';

class BillRepository {
  final Box<BillModel> _box = Hive.box<BillModel>(Constants.billsBox);

  Future<List<BillModel>> getAll() async => _box.values.toList()
    ..sort((BillModel a, BillModel b) => b.createdAt.compareTo(a.createdAt));

  Future<BillModel?> getById(String id) async => _box.get(id);

  Future<List<BillModel>> getByTenant(String tenantId) async =>
      _box.values.where((BillModel b) => b.tenantId == tenantId).toList()..sort(
        (BillModel a, BillModel b) => b.createdAt.compareTo(a.createdAt),
      );

  Future<List<BillModel>> getByProperty(String propertyId) async =>
      _box.values.where((BillModel b) => b.propertyId == propertyId).toList()
        ..sort(
          (BillModel a, BillModel b) => b.createdAt.compareTo(a.createdAt),
        );

  Future<List<BillModel>> getOverdue() async =>
      _box.values
          .where(
            (BillModel b) => b.isOverdue && b.status != PaymentStatus.paid,
          )
          .toList()
        ..sort((BillModel a, BillModel b) => b.dueDate.compareTo(a.dueDate));

  Future<List<BillModel>> getPending() async =>
      _box.values
          .where(
            (BillModel b) =>
                b.status == PaymentStatus.pending ||
                b.status == PaymentStatus.partiallyPaid,
          )
          .toList()
        ..sort((BillModel a, BillModel b) => b.dueDate.compareTo(a.dueDate));

  Future<List<BillModel>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async =>
      _box.values
          .where(
            (BillModel b) =>
                b.createdAt.isAfter(start) && b.createdAt.isBefore(end),
          )
          .toList()
        ..sort(
          (BillModel a, BillModel b) => b.createdAt.compareTo(a.createdAt),
        );

  Future<List<BillModel>> getLatestByTenant(String tenantId) async =>
      getByTenant(tenantId);

  Future<void> add(BillModel bill) async => _box.put(bill.id, bill);

  Future<void> update(BillModel bill) async => _box.put(bill.id, bill);

  Future<void> delete(String id) async => _box.delete(id);

  Future<void> markAsPaid(String id, String? paymentMode) async {
    final BillModel? bill = _box.get(id);
    if (bill == null) return;
    await _box.put(
      id,
      bill.copyWith(
        status: PaymentStatus.paid,
        paidAmount: bill.totalAmount,
        paidDate: DateTime.now(),
        paymentMode: paymentMode,
      ),
    );
  }

  Future<void> markAsUnpaid(String id) async {
    final BillModel? bill = _box.get(id);
    if (bill == null) return;
    await _box.put(
      id,
      bill.copyWith(
        status: PaymentStatus.pending,
        paidAmount: 0,
        paidDate: null,
        paymentMode: null,
      ),
    );
  }

  Future<void> updatePdfPath(String id, String path) async {
    final BillModel? bill = _box.get(id);
    if (bill == null) return;
    await _box.put(id, bill.copyWith(pdfPath: path));
  }
}
