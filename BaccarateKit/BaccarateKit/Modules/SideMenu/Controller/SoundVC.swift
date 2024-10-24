//
//  SoundVC.swift
//  BaccaratLiveStream
//
//  Created by Kamesh Bala on 11/09/23.
//

import UIKit

class SoundVC: UIViewController {
    @IBOutlet weak var soundVolumeLbl: UILabel!
    @IBOutlet weak var voiceVolumeLbl: UILabel!
    @IBOutlet weak var soundLbl: UILabel!
    @IBOutlet weak var gameVoiceLbl: UILabel!
    @IBOutlet weak var soundMuteButton: UIButton!
    @IBOutlet weak var voiceMuteButton: UIButton!
//    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var gameVoiceSlider: UISlider!
    @IBOutlet weak var gameSlider: UISlider!
    @IBOutlet weak var soundSwitch: UISwitch!
    var isVoiceMuted = false
    var isSoundMuted = false
    
    var delegate: SoundDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageSetup()
        gameVoiceSlider.value = Datamanager.shared.gameVoiceVolume
        gameSlider.value = Datamanager.shared.gameSoundVolume
        if Datamanager.shared.gameVoiceVolume > 0 || Datamanager.shared.gameSoundVolume > 0 {
            Datamanager.shared.gameSwitch = true
            soundSwitch.isOn = true
        } else {
            Datamanager.shared.gameSwitch = false
            soundSwitch.isOn = false
        }
        sliderValueChange(gameVoiceSlider)
        sliderValueChange(gameSlider)
    }
    func languageSetup() {
        self.titleLbl.text = "Sound".localizable
        self.gameVoiceLbl.text = "Game voice".localizable
        self.soundLbl.text = "Sound".localizable
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        delegate?.updatedSound()
        Datamanager.shared.gameSoundVolume = gameSlider.value
        Datamanager.shared.gameVoiceVolume = gameVoiceSlider.value
        dismiss(animated: true)
    }
    @IBAction func soundSwitchAction(_ sender: Any) {
        if soundSwitch.isOn {
            if Datamanager.shared.gameSoundVolume == 0 {
                Datamanager.shared.gameSoundVolume = 10
            }
            if Datamanager.shared.gameVoiceVolume == 0 {
                Datamanager.shared.gameVoiceVolume = 10
            }
            gameSlider.value = Datamanager.shared.gameSoundVolume
            gameVoiceSlider.value = Datamanager.shared.gameVoiceVolume
            Datamanager.shared.gameSwitch = true
        } else {
            gameSlider.value = 0
            gameVoiceSlider.value = 0
            Datamanager.shared.gameSwitch = false
        }
        sliderValueChange(gameSlider)
        sliderValueChange(gameVoiceSlider)
    }
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let sliderValue: Int = Int(floor(sender.value))
        if sender == gameVoiceSlider {
            voiceVolumeLbl.text = "\(sliderValue)"
            gameVoiceSlider.value = Float(sliderValue)
            switch sliderValue {
            case 8...10:
                voiceMuteButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
                isVoiceMuted = false
            case 4...7:
                voiceMuteButton.setImage(UIImage(systemName: "volume.2.fill"), for: .normal)
                isVoiceMuted = false
            case 1...3:
                voiceMuteButton.setImage(UIImage(systemName: "volume.1.fill"), for: .normal)
                isVoiceMuted = false
            case 0:
                voiceMuteButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
                isVoiceMuted = true
            default:
                break
            }
        } else {
            soundVolumeLbl.text = "\(sliderValue)"
            gameSlider.value = Float(sliderValue)
            switch sliderValue {
            case 8...10:
                soundMuteButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
                isSoundMuted = false
            case 4...7:
                soundMuteButton.setImage(UIImage(systemName: "volume.2.fill"), for: .normal)
                isSoundMuted = false
            case 1...3:
                soundMuteButton.setImage(UIImage(systemName: "volume.1.fill"), for: .normal)
                isSoundMuted = false
            case 0:
                soundMuteButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
                isSoundMuted = true
            default:
                break
            }
        }
        if gameSlider.value == 0 && gameVoiceSlider.value == 0 {
            soundSwitch.isOn = false
        } else {
            soundSwitch.isOn = true
        }
    }
    @IBAction func gameVoiceMuteButton(_ sender: Any) {
        if isVoiceMuted {
            isVoiceMuted = false
            voiceMuteButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
            gameVoiceSlider.value = 10
            voiceVolumeLbl.text = "10"
            Datamanager.shared.gameVoiceVolume = 10.0
        } else {
            isVoiceMuted = true
            voiceMuteButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
            gameVoiceSlider.value = 0
            voiceVolumeLbl.text = "0"
            Datamanager.shared.gameVoiceVolume = 0.0
        }
        if gameSlider.value == 0 && gameVoiceSlider.value == 0 {
            soundSwitch.isOn = false
        } else {
            soundSwitch.isOn = true
        }
    }
    @IBAction func soundMuteButtonAction(_ sender: Any) {
        if isSoundMuted {
            isSoundMuted = false
            soundMuteButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
            gameSlider.value = 10
            soundVolumeLbl.text = "10"
            Datamanager.shared.gameSoundVolume = 10.0
        } else {
            isSoundMuted = true
            soundMuteButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
            gameSlider.value = 0
            soundVolumeLbl.text = "0"
            Datamanager.shared.gameSoundVolume = 0.0
        }
        if gameSlider.value == 0 && gameVoiceSlider.value == 0 {
            soundSwitch.isOn = false
        } else {
            soundSwitch.isOn = true
        }
    }
}

