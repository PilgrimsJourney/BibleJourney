import 'package:intl/intl.dart';

import 'messages_all.dart';

void main() async {
	var locale = Locale('en', '');
	await initializeMessages(locale);
print("Displaying messages for the '$locale' locale:");
  print('');

  Intl.withLocale(locale, () {
    printMessages();
  });
}

void printMessages() {
  show(Intl.message('plan'));
  show(Intl.message('error'));
  show(Intl.message('addStream'));
  show(Intl.message('removeStream'));
  show(Intl.message('selected'));
  show(Intl.message('addedStream'));
  show(Intl.message('removedStream'));
  show(Intl.message('home'));
  show(Intl.message('plans'));
  show(Intl.message('one_year_plan_name'));
  show(Intl.message('one_year_plan_description'));
  show(Intl.message('two_year_plan_name'));
  show(Intl.message('two_year_plan_description'));
  show(Intl.message('ot_chronological_365_name'));
  show(Intl.message('ot_chronological_730_name'));
  show(Intl.message('nt_writers_365_name'));
  show(Intl.message('nt_writers_365x2_name'));
  show(Intl.message('ot_chronological_365_description'));
  show(Intl.message('ot_chronological_730_description'));
  show(Intl.message('nt_writers_365_description'));
  show(Intl.message('nt_writers_365x2_description'));
  show(Intl.message('daily_psalms_name'));
  show(Intl.message('daily_psalms_description'));
  show(Intl.message('readingPlanTitle'));
  show(Intl.message('availableStreams'));
  show(Intl.message('startReadingPlan'));
  show(Intl.message('noPlanSelected'));
}

void show(String message) {
  print(" - '$message'");
}



