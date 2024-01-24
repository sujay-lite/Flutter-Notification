import UIKit
import Flutter

import flutter_local_notification

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }

    AwesomeNotificationsPlugin.initialize(
            // Set the icon for your app notification
//             iconName: "your_app_icon",
            defaultPrivacy: NotificationPrivacy.Public
        )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  // Add these methods to handle notifications when the app is in the foreground
    @available(iOS 10.0, *)
    override func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      completionHandler([.alert, .badge, .sound])
    }

    @available(iOS 10.0, *)
    override func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      AwesomeNotificationsPlugin.didReceiveNotificationResponse(response)
      completionHandler()
    }
  }
}
