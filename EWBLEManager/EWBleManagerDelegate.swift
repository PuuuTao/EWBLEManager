//
//  EWBleManagerDelegate.swift
//  EWBLEManagerSDK
//
//  Created by developer on 2024/3/6.
//

import Foundation
import CoreBluetooth

public protocol EWBleManagerDelegate {
    
    ///蓝牙管理器状态变化
    func ewBleManagerDidUpdateState(state: CBManagerState)
    
    ///开始搜索
    func ewBleManagerDidStartScan(isScanning: Bool)
    
    ///发现外围设备
    func ewBleManagerDiscoverPeripheral(peripheral: CBPeripheral, advertisementData: [String : Any])
    
    ///连接外围设备成功
    func ewBleManagerDidConnectPeripheral(peripheral: CBPeripheral)
    
    ///连接外围设备失败
    func ewBleManagerDidFailToConnectPeripheral(peripheral: CBPeripheral, error: EWBleError)
    
    ///外围设备断开连接
    func ewBleDidDisconnectPeripheral(peripheral: CBPeripheral, error: EWBleError?)
}
