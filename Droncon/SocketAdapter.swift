//
//  SocketAdapter.swift
//  Drone_Controller
//
//  Created by Chuan Ren on 4/27/15.
//  Copyright (c) 2015 Ren. All rights reserved.
//

import UIKit

let _SocketAdapterSharedInstance = SocketAdapter()

enum FlyMode {
    case Rtl;
}

class SocketAdapter: NSObject {

    class var sharedInstance : SocketAdapter {
        return _SocketAdapterSharedInstance
    }

    // Socket
    var socket: AsyncSocket = AsyncSocket()
    // Controller
    var controller: UIViewController?

    // MARK: - State
    var ch1: Float = 0.00
    var ch2: Float = 0.50
    var ch3: Float = 0.50
    var ch4: Float = 0.50

    var fm: Int = 0

    // MARK: - AsyncSocket Main

    func connect() -> Bool {
        self.socket.setDelegate(self)

        var error: NSErrorPointer = NSErrorPointer()
        socket.connectToHost("192.168.1.200", onPort: 8002, error: error)
        NSLog("Socket connect error: " + error.debugDescription)

        return true
    }

    func send() -> Bool {
        let array = NSArray(objects: ch1, ch2, ch3, ch4, fm)
        self.socket.writeData(array.JSONData(), withTimeout: 10.0, tag: 0)
        NSLog(array.JSONString())

        return true
    }

    func sendF(f: Float) -> Bool {
        let array = NSArray(objects: f)
        self.socket.writeData(array.JSONData(), withTimeout: 10.0, tag: 0)
        NSLog(array.JSONString())

        return true
    }

    func sendC(c: String) -> Bool {
        let array = NSArray(objects: c)
        self.socket.writeData(array.JSONData(), withTimeout: 10.0, tag: 0)
        NSLog(array.JSONString())

        return true
    }
    
    // MARK: - AsyncSocket Delegate
    
}
