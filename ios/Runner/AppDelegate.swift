import UIKit
import Flutter
import Foundation
import UserNotifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var notificationEventChannelWithBackground : FlutterEventChannel?
    let notificationStreamHandler = NotificationStreamHandler()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    notificationEventChannelWithBackground = FlutterEventChannel(name: "example/notification", binaryMessenger: controller.binaryMessenger)
    notificationEventChannelWithBackground?.setStreamHandler(notificationStreamHandler)

    let randomNumberChannel = FlutterEventChannel(name: "random_number_channel", binaryMessenger: controller.binaryMessenger)
    let randomNumberStreamHandler = RandomNumberStreamHandler()

    randomNumberChannel.setStreamHandler(randomNumberStreamHandler)
    // let factory = GyeomFactory()
    // self.registrar(forPlugin: "GyeomPlugin")?.register(factory, withId: "gyeom-type")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   override func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
             notificationEventChannelWithBackground?.setStreamHandler(notificationStreamHandler)         
        notificationStreamHandler.handleNotification("NOTIFICATION_LISTENER_FROM_SWIFT_BACKGROUND")

            completionHandler()
        }
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        notificationEventChannelWithBackground?.setStreamHandler(notificationStreamHandler)         
        notificationStreamHandler.handleNotification("NOTIFICATION_LISTENER_FROM_SWIFT_BACKGROUND")
        completionHandler([.alert, .badge, .sound])
      }
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       let state = UIApplication.shared.applicationState
        notificationEventChannelWithBackground?.setStreamHandler(notificationStreamHandler)         
        notificationStreamHandler.handleNotification("NOTIFICATION_LISTENER_FROM_SWIFT_BACKGROUND")
    //   if  state == .inactive {
      
    //   } else if state == .background{
       
    //    } 
      //  else if state == .active {
      //  }
     }

}

class RandomNumberStreamHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    var timer: Timer?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendNewRandomNumber), userInfo: nil, repeats: true)
        return nil
    }
    
    @objc func sendNewRandomNumber() {
        guard let sink = sink else { return }
        
        let randomNumber = Int.random(in: 1..<10)
        sink(randomNumber)
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        timer?.invalidate()
        return nil
    }
}

/**
 FlutterPlatformViewFactory를 상속받는 클래스 : FlutterPlatformView를 상속받아 UIView를 리턴하는 그 클래스를 연결하는 클래스(create()가 프로토콜내 필수 구현함수로 등록되어 있다, createArgsCodec()는 optional)
 */
class GyeomFactory: NSObject, FlutterPlatformViewFactory{
    private var gyeomView: GyeomView?
    private var messenger: FlutterBinaryMessenger?

    /**
     Only needs to be implemented if `createWithFrame` needs an arguments parameter.
     Dart에서 파라미터 전달시 필요
     */
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    override init(){
        super.init()
    }
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func callGyeomViewMethod(){
        if let gyeomView = gyeomView {
            gyeomView.receiveGyeomViewMethod()
        }
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        self.gyeomView = GyeomView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
        return gyeomView ?? GyeomView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    
    
}

/**
FlutterPlatformView를 상속받는 클래스: 실제 플러터 내에 포함될 UIView를 리턴하는 클래스(func view() -> UIView {}가 프로토콜내 필수
 구현함수로 구현되어 있다)
 */
class GyeomView: NSObject, FlutterPlatformView{
    private var returnView: UIView?
    var nativeLabel = UILabel()
    
    
    override init() {
        returnView = UIView()
        super.init()
    }
    
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        returnView = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: returnView!, args: args)
    }
    
    func view() -> UIView {
        return returnView!
    }
    
    func receiveGyeomViewMethod(){
        print("receiveGyeomViewMethod")
    }
    
    func createNativeView(view _view: UIView, args: Any?){
        print("createNativeView args: \(args)")
        _view.backgroundColor = UIColor.blue
        nativeLabel.text = "이것은 GyeomView"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        _view.addSubview(nativeLabel)
        nativeLabel.centerXAnchor.constraint(equalTo: _view.centerXAnchor).isActive = true
        nativeLabel.centerYAnchor.constraint(equalTo: _view.centerYAnchor).isActive = true
        
        
        if let args = args {
            if let param = args as? [String:Any]{
                print("param: \(param["param"] ?? "파라미터 없음")")
            }
        }
    }
}

class NotificationStreamHandler : NSObject, FlutterStreamHandler {

  var eventSink: FlutterEventSink?

  // notification will be added to this queue until the sink is ready to process them
  var queuedNotification = [String]()

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    queuedNotification.forEach({ events($0) })
    queuedNotification.removeAll()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }
    
  func handleNotification(_ notification: String) -> Bool {
    guard let eventSink = eventSink else {
      queuedNotification.append(notification)
      return false
    }
    eventSink(notification)
    return true
  }
}
