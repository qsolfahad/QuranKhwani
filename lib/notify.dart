import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:qurankhwani/main.dart' as data;



class NotificationServices {
  
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings  _androidInitializationSettings  = const AndroidInitializationSettings('logo');
  
 
  
 void intializationNotification()async{
     InitializationSettings initializationSettings = InitializationSettings(android: _androidInitializationSettings);
 await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void showNotify () async {
   
  // Create a PrayerTimes instance for the desired date and coordinates
  var params = CalculationMethod.NorthAmerica();
  print(data.dropdownvalue);
  switch(data.dropdownvalue){
 case 'Dubai':
   params = CalculationMethod.Dubai();
   break;
  case 'Egyptian':
   params = CalculationMethod.Egyptian();
   break;
  case 'Karachi':
   params = CalculationMethod.Karachi();
   break;
    case 'Kuwait':
   params = CalculationMethod.Kuwait();
   break;
    case 'MoonsightingCommittee':
   params = CalculationMethod.MoonsightingCommittee();
   break;
    case 'MuslimiorldLeague':
   params = CalculationMethod.MuslimWorldLeague();
   break;
    case 'Qatar':
   params = CalculationMethod.Qatar();
   break; 
   case 'Singapore':
   params = CalculationMethod.Singapore();
   break;
   case 'Tehran':
   params = CalculationMethod.Tehran();
   break;
   case 'Turkey':
   params = CalculationMethod.Turkey();
   break;
   case 'UmmAlQura':
   params = CalculationMethod.UmmAlQura();
   break;
   case 'Other':
   params = CalculationMethod.Other();
   break;
  default:
   params = CalculationMethod.NorthAmerica();
  break;
}
var date = DateTime.now();

  final prayerTimes = PrayerTimes(data.coordinates, date, params,precision: true);

  
    // List of prayer names
    final prayerNames = [
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
    ];
  var prayerTime = prayerTimes.timeForPrayer(Prayer.Fajr);
    

    // Schedule notification for each prayer time
    for (var i = 0; i < prayerNames.length; i++) {
      final prayerName = prayerNames[i];
      if(prayerName == 'Fajr') {
        prayerTime = tz.TZDateTime.from(prayerTimes.fajr!, data.location);
      }
      if(prayerName == 'Dhuhr') {
        prayerTime = tz.TZDateTime.from(prayerTimes.dhuhr!, data.location);
      }
      if(prayerName == 'Asr') {
        prayerTime = tz.TZDateTime.from(prayerTimes.asr!, data.location);
      }
      if(prayerName == 'Maghrib') {
        prayerTime = tz.TZDateTime.from(prayerTimes.maghrib!, data.location);
      }
      if(prayerName == 'Isha') {
        prayerTime = tz.TZDateTime.from(prayerTimes.isha!, data.location);
      }

    // Subtract a notification lead time (e.g., 15 minutes) from the prayer time
  //  final notificationTime = prayerTime!.subtract(Duration(minutes: 15));
final tzDateTime = tz.TZDateTime.from(prayerTime!, data.location);
print(tzDateTime);
    // Define notification details
  AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails('channelID','channelName',importance: Importance.max,priority: Priority.high,sound: RawResourceAndroidNotificationSound('azhan'));
  AndroidNotificationDetails fajrandroidNotificationDetails = const AndroidNotificationDetails('channelI','channelNam',importance: Importance.max,priority: Priority.high,sound: RawResourceAndroidNotificationSound('fajr'));
   NotificationDetails fajrnotificationDetails = NotificationDetails(android: fajrandroidNotificationDetails);
  
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
   // await _flutterLocalNotificationsPlugin.periodicallyShow(0, title, body, RepeatInterval.everyMinute, notificationDetails);
  

  await _flutterLocalNotificationsPlugin.zonedSchedule(
      i,
      'Upcoming Prayer',
      'It is almost time for $prayerName prayer.',
      tzDateTime.subtract(const Duration(minutes: 2)),
      (prayerName == 'Fajr')?fajrnotificationDetails:notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  }
}