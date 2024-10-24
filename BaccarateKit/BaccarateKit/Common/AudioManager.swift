//
//  AudioManager.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 27/09/23.
//

import Foundation
import AVFoundation

struct SoundQueue {
    var url: URL!
    var audioType: AudioType!
}
public class AudioManager {
    static var player: AVAudioPlayer?
    static var soundQueue: [SoundQueue] = []
    static var delegate: AudioManagerDelegate? = AudioManagerDelegate()
    
    static func playSound(audioType: AudioType, name: String, addInQueue: Bool) {
        var url: URL!
        if audioType == .sound {
            guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
            url = soundURL
        } else {
            let languageCode = Session.shared.getLanguangeCode()
            guard let voiceURL = Bundle.main.url(forResource:
                                                    languageCode + "-" + name, withExtension: "mp3") else { return }
            url = voiceURL
        }
        if Datamanager.shared.isUserAuthenticated {
            if addInQueue {
                soundQueue.append(SoundQueue(url: url!, audioType: audioType))
                if player?.isPlaying == false || player?.isPlaying == nil {
                    playNextSound()
                }
            } else {
                playSoundNow(url: url, audioType: audioType)
            }
        }
        
    }
    static func playNextSound() {
            if !soundQueue.isEmpty {
                let nextSound = soundQueue.removeFirst()
                playSoundNow(url: nextSound.url, audioType: nextSound.audioType)
            }
    }
    static func playSoundNow(url: URL, audioType: AudioType) {
        if Datamanager.shared.isUserAuthenticated {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            switch audioType {
            case .sound:
                player.volume = Datamanager.shared.gameSoundVolume / 10
            case .voice:
                player.volume = Datamanager.shared.gameVoiceVolume / 10
            }
            player.delegate = delegate
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    }
    static func stopSound() {
        player?.stop()
    }
}
class AudioManagerDelegate: NSObject, AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Handle the playback completion here
        AudioManager.playNextSound()
    }
}

enum AudioType {
    case voice
    case sound
}
enum Sounds: String {
    case open = "open"
    case selectchip = "selectChip"
    case openpoke = "openpoke"
    case click = "click"
    case countdown = "countdown"
    case bet = "bet"
    case stop = "stop"
}

enum Voices: String {
    case enter = "enter"
    case placeYourBetStart = "start"
    case stopBet = "stopbet"
    case playerDraw = "23"
    case bankerDraw = "24"
    case pleaseSqueezeCard = "25"
    case playerSqueezing = "26"
    case bankerSqueezing = "27"
    case waitingForSqueezing = "28"
    case openCard = "31"
    case playerNatural = "32"
    case bankerNatural = "33"
    case freeGame = "34"
    case pleaseCutCard = "37"
    case waitingToCutCard = "38"
    case player = "46"
    case banker = "50"
    case bankerPair = "51"
    case playerPair = "52"
    case bankerWin = "161"
    case playerWin = "162"
    case tie = "163"
    case zeroPoint = "64"
    case onePoint = "65"
    case twoPoints = "66"
    case threePoints = "67"
    case fourPoints = "68"
    case fivePoints = "69"
    case sixPoints = "70"
    case sevenPoints = "71"
    case eightPoints = "72"
    case ninePoints = "73"
}
