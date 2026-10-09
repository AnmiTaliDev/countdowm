// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';

import '../domain/billing_period.dart';
import '../domain/subscription_category.dart';

@DataClassName('SubscriptionRow')
class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get cost => real()();
  TextColumn get currency => text()();
  TextColumn get periodUnit => textEnum<PeriodUnit>()();
  IntColumn get periodCount => integer()();
  DateTimeColumn get nextChargeDate => dateTime()();
  TextColumn get category => textEnum<SubscriptionCategory>()();
  TextColumn get note => text()();
  TextColumn get serviceUrl => text()();
  IntColumn get color => integer()();
  IntColumn get reminderDays => integer().nullable()();
}
