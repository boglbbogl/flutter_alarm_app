import Foundation
import Flutter


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