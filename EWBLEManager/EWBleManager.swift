//
//  EWBleManager.swift
//  EWBLEManagerSDK
//
//  Created by developer on 2024/3/6.
//

import Foundation
import CoreBluetooth

public class EWBleManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    ///单例
    public static let shared = EWBleManager()
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    private var discoverDevices: [CBPeripheral] = []
    public var bleState: CBManagerState = .unknown
    
    public var managerDelegate: EWBleManagerDelegate?
    
    override public init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    ///获取蓝牙状态
    public func ewBleState() -> CBManagerState{
        return bleState
    }
    
    ///搜索外围设备
    public func ewBleScanPeripheral(uuids: [String]){
        guard centralManager?.state == .poweredOn else {
            return
        }
        discoverDevices.removeAll()
        var uuidArr: [CBUUID] = []
        for uuid in uuids {
            uuidArr.append(CBUUID(string: uuid))
        }
        managerDelegate?.ewBleManagerDidStartScan(isScanning: true)
        centralManager?.scanForPeripherals(withServices: uuidArr == [] ? nil : uuidArr)
    }
    
    ///停止搜索
    public func ewBleStopScanPeripheral(){
        managerDelegate?.ewBleManagerDidStartScan(isScanning: false)
        centralManager?.stopScan()
    }
    
    ///连接设备
    public func ewBleConnectPeripheral(peripheral: CBPeripheral){
        var hasDiscover = false
        if discoverDevices.contains(peripheral) {
            hasDiscover = true
            connectedPeripheral = peripheral
            connectedPeripheral?.delegate = self
            centralManager?.connect(peripheral)
        }
        if !hasDiscover {
            managerDelegate?.ewBleManagerDidFailToConnectPeripheral(peripheral: peripheral, error: EWBleError(errorCode: EWBleErrorCode.notFoundDevice.rawValue, errorMessage: "未搜索到设备"))
        }
    }
    
    ///断开连接
    public func ewBleDisconnectPeripheral(peripheral: CBPeripheral){
        if let device = connectedPeripheral {
            if peripheral == device {
                centralManager?.cancelPeripheralConnection(peripheral)
            } else {
                managerDelegate?.ewBleDidDisconnectPeripheral(peripheral: peripheral, error: EWBleError(errorCode: EWBleErrorCode.notFoundDevice.rawValue, errorMessage: "未搜索到设备"))
            }
        } else {
            managerDelegate?.ewBleDidDisconnectPeripheral(peripheral: peripheral, error: EWBleError(errorCode: EWBleErrorCode.notFoundDevice.rawValue, errorMessage: "未搜索到设备"))
        }
    }
    
    //MARK: CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bleState = central.state
        if central.state == .poweredOn {
            ewBleScanPeripheral(uuids: [])
        } else {
            ewBleStopScanPeripheral()
        }
        managerDelegate?.ewBleManagerDidUpdateState(state: central.state)
        print("蓝牙状态：\(bleState)")
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            if !discoverDevices.contains(peripheral) {
                discoverDevices.append(peripheral)
                managerDelegate?.ewBleManagerDiscoverPeripheral(peripheral: peripheral, advertisementData: advertisementData)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        managerDelegate?.ewBleManagerDidConnectPeripheral(peripheral: peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        managerDelegate?.ewBleManagerDidFailToConnectPeripheral(peripheral: peripheral, error: EWBleError(errorCode: EWBleErrorCode.failedToConnect.rawValue, errorMessage: "连接设备失败"))
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let device = connectedPeripheral {
            if device == peripheral {
                connectedPeripheral = nil
            }
        }
        managerDelegate?.ewBleDidDisconnectPeripheral(peripheral: peripheral, error: EWBleError(errorCode: EWBleErrorCode.disconnectError.rawValue, errorMessage: "设备断开连接错误"))
    }
    
}
