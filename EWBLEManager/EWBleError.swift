//
//  EWBleError.swift
//  EWBLEManagerSDK
//
//  Created by developer on 2024/3/6.
//

import Foundation

public struct EWBleError: Error {
    public var errorCode: Int
    public var errorMessage: String
    
    public init(errorCode: Int, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

public enum EWBleErrorCode: Int{
    ///未知错误
    case unknownError = 0
    ///连接设备失败
    case failedToConnect = 1
    ///未搜索到设备
    case notFoundDevice = 2
    ///设备断开连接错误
    case disconnectError = 3
    ///蓝牙未打开
    case bleNotPoweredOn = 4
}
