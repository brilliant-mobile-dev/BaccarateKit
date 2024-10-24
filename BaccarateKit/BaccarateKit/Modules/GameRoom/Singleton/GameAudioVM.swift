//
//  GameAudioVM.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 28/09/23.
//

import Foundation

public class GameAudioVM {
    static let shared = GameAudioVM()
    private init() {}
    
    func playAudio(audioType: AudioType, sound: Sounds?, voice: Voices?, addInQueue: Bool) {
        switch audioType {
        case .voice:
            // Game Voices
            if let voice = voice {
                AudioManager.playSound(audioType: .voice, name: voice.rawValue, addInQueue: addInQueue)
            }
            
        case .sound:
            // Game Sounds
            if let sound = sound {
                AudioManager.playSound(audioType: .sound, name: sound.rawValue, addInQueue: addInQueue)
            }
        }
    }
}
