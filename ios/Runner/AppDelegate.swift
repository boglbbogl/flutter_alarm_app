import UIKit
import Flutter
import Foundation
import UserNotifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    let randomNumberChannel = FlutterEventChannel(name: "random_number_channel", binaryMessenger: controller.binaryMessenger)
    let randomNumberStreamHandler = RandomNumberStreamHandler()

    randomNumberChannel.setStreamHandler(randomNumberStreamHandler)
    let factory = GyeomFactory()
    self.registrar(forPlugin: "GyeomPlugin")?.register(factory, withId: "gyeom-type")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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

class GyeomFactory: NSObject, FlutterPlatformViewFactory{
    private var gyeomView: GyeomView?
    private var messenger: FlutterBinaryMessenger?
    
    override init(){
        super.init()
    }
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
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
        createNativeView(view: returnView!, args: args)
    }
    
    func view() -> UIView {
        return returnView!
    }
    
    func createNativeView(view _view: UIView, args: Any?){
        _view.backgroundColor = UIColor.blue
        nativeLabel.text = "이것은 GyeomView"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        _view.addSubview(nativeLabel)
        nativeLabel.centerXAnchor.constraint(equalTo: _view.centerXAnchor).isActive = true
        nativeLabel.centerYAnchor.constraint(equalTo: _view.centerYAnchor).isActive = true
    }
}

