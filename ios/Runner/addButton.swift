//
//  addButton.swift
//  Runner
//
//  Created by Gustavo Nogales on 06/02/23.
//

import Foundation
import Flutter
import UIKit
import PassKit

class AddButtonFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
        self.messenger = messenger
        self.channel = channel
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AddButton(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args as! [String: Any],
            binaryMessenger:  messenger,
            flMethodChannel: channel
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}


class AddButton: NSObject, FlutterPlatformView, PKAddPassesViewControllerDelegate {
    private var uiView: UIView
    private var passRaw: FlutterStandardTypedData
    private var channel: FlutterMethodChannel
    private var pass: PKPass?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: [String: Any],
        binaryMessenger messenger: FlutterBinaryMessenger?,
        flMethodChannel: FlutterMethodChannel
    ) {
        uiView = UIView()
        channel = flMethodChannel
        passRaw = args["pass"] as! FlutterStandardTypedData
        super.init()
        createButton(view: uiView)
    }
    
    func view() -> UIView {
        return uiView
    }
    
    func createButton(view _view: UIView){
        let pkPassButton = PKAddPassButton(addPassButtonStyle: PKAddPassButtonStyle.blackOutline)
        pkPassButton.addTarget(self, action: #selector(onPress), for: UIControl.Event.touchUpInside)
        _view.addSubview(pkPassButton)
    }
    
    @objc func onPress() {
        do {
          pass = try PKPass(data: passRaw.data)
       } catch {
           print("No valid Pass data passed")
           return
       }
        guard let addPassViewController = PKAddPassesViewController(pass: pass!) else {
           print("View controller messed up")
           return
       }
//        addPassViewController.delegate = self // this is wrong
       guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
           print("Root VC unavailable")
           return
       }
       rootVC.present(addPassViewController, animated: true)
    }
    
    func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
        let passAdded = PKPassLibrary().containsPass(pass!)
        channel.invokeMethod("didAddToWallet", arguments: passAdded)
    }
    
}



