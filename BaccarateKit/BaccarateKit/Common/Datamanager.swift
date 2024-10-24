//
//  Datamanager.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 06/09/23.
//

import Foundation

class Datamanager {
    static let shared = Datamanager()
    private init() {}
    private let userDefaults = UserDefaults.standard
    
    var isUserAuthenticated: Bool {
        get {
            return userDefaults.bool(forKey: "isUserAuthenticated")
        } set {
            userDefaults.set(newValue, forKey: "isUserAuthenticated")
            userDefaults.synchronize()
        }
    }
    var accessToken: String! {
        get {
            return userDefaults.string(forKey: "accessToken")
        } set {
            userDefaults.set(newValue, forKey: "accessToken")
            userDefaults.synchronize()
        }
    }
    var gameVoiceVolume: Float {
        get {
            return userDefaults.float(forKey: "gameVoiceVolume")
        } set {
            userDefaults.set(newValue, forKey: "gameVoiceVolume")
            userDefaults.synchronize()
        }
    }
    var gameSoundVolume: Float {
        get {
            return userDefaults.float(forKey: "gameSoundVolume")
        } set {
            userDefaults.set(newValue, forKey: "gameSoundVolume")
            userDefaults.synchronize()
        }
    }
    var isAppLoadedFirstTime: Bool {
        get {
            return userDefaults.bool(forKey: "isAppLoadedFirstTime")
        } set {
            userDefaults.set(newValue, forKey: "isAppLoadedFirstTime")
            userDefaults.synchronize()
        }
    }
    var gameSwitch: Bool {
        get {
            return userDefaults.bool(forKey: "gameSwitch")
        } set {
            userDefaults.set(newValue, forKey: "gameSwitch")
            userDefaults.synchronize()
        }
    }
}

class GameRoomStack {
    static let shared = GameRoomStack()
    private init() {}
    
    var previousRoundNumber: Int = 0
    var pPairStack = [ChipStack]()
    var tiePairStack = [ChipStack]()
    var bPairStack  = [ChipStack]()
    var playerStack = [ChipStack]()
    var bankerStack = [ChipStack]()
    var chipTuple = [(String, String, [ChipStack], ChipValueView)]()
}
