//
//  PlaySoundsViewController.swift
//  Udacity 1
//
//  Created by Vladimirs Matusevics on 08/04/2015.
//  Copyright (c) 2015 vmatusevic. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet var stopButton: UIButton!
    
    var player = AVAudioPlayer()
    var recorderAudio: RecorderAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing player
        player = AVAudioPlayer(contentsOfURL: recorderAudio.recordingFilePath, error: nil)
        player.delegate = self
        player.enableRate = true
        // Initialize Audio Engine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recorderAudio.recordingFilePath, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        audioIsPlaying(false)
    }

    override func viewWillDisappear(animated: Bool) {
        player.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundAudioSlow(sender: UIButton) {
        playSoundAudio(0.5)
    }
    
    @IBAction func playSoundAudioFast(sender: UIButton) {
        playSoundAudio(1.5)
    }
    
    func playSoundAudio(rate: Float) {
        audioIsPlaying(true)
        if player.isEqual(nil) {
            println("There was an error playing file")
        } else {
            stopAllAudio()
            // set new sound and play it
            player.rate = rate
            player.play()
        }
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // More effects: Echo, Reverb
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAllAudio()
        audioIsPlaying(true)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var delay = AVAudioUnitDelay()
        delay.delayTime = 0.3
        delay.feedback = 40
        audioEngine.attachNode(delay)
        
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.SmallRoom)
        audioEngine.attachNode(reverb)
        
        
        audioEngine.connect(audioPlayerNode, to: delay, format: nil)
        audioEngine.connect(delay, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            println("2. Audio Finished Playing")
            dispatch_async(dispatch_get_main_queue()) {
                self.audioIsPlaying(false)
            }
        })
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAllAudio()
        audioIsPlaying(true)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var delay = AVAudioUnitDelay()
        delay.delayTime = 0.5
        delay.feedback = 80
        audioEngine.attachNode(delay)
        
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.Cathedral)
        reverb.wetDryMix = 45
        audioEngine.attachNode(reverb)
        
        
        audioEngine.connect(audioPlayerNode, to: delay, format: nil)
        audioEngine.connect(delay, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            println("2. Audio Finished Playing")
            dispatch_async(dispatch_get_main_queue()) {
                self.audioIsPlaying(false)
            }
        })
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopSoundAudio(sender: UIButton) {
        stopAllAudio()
        audioIsPlaying(true)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        audioIsPlaying(true)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            println("2. Audio Finished Playing")
            dispatch_async(dispatch_get_main_queue()) {
                self.audioIsPlaying(false)
            }
        })
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopAllAudio() {
        // stop playing AVAudioPlayer
        player.stop()
        player.currentTime = 0.0
        // stop and reset AVAudioEngine
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func audioIsPlaying(status: Bool) {
        stopButton.enabled = status
    }
    
    // MARK: AVAudioPlayerDelegate
    // MARK:
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("1. Audio Finished Playing")
        audioIsPlaying(false)
    }

    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Audio Decode Error")
        audioIsPlaying(false)
    }
    
}
