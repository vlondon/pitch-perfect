//
//  RecordSoundsViewController.swift
//  Udacity 1
//
//  Created by Vladimirs Matusevics on 07/04/2015.
//  Copyright (c) 2015 vmatusevic. All rights reserved.
//

import UIKit
import AVFoundation

enum recordingAudioProcess {
    case Recording, Paused, Finished
}

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet var recordingProgressLabel: UILabel!
    @IBOutlet var startRecordingButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    @IBOutlet var actionButtonsView: UIView!
    
    @IBOutlet var pauseRecordingButton: UIButton!
    @IBOutlet var continueRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recorderAudio: RecorderAudio!
    
    let moveToPlayViewSegueId = "stopRecordingSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingProgressLabel.text = "Tap to record"
        recordingProgressLabel.hidden = false
        startRecordingButton.enabled = true
        actionButtonsView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        if let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String {
            startRecordingButton.enabled = false
            stopRecordingButton.hidden = false
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            
            changeRecordStatus(.Recording)
        } else {
            println("Can't create path")
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        changeRecordStatus(.Finished)
    }
    
    // Add Pause button
    @IBAction func pauseAudio(sender: UIButton) {
        changeRecordStatus(.Paused)
    }
    
    // Resume button
    @IBAction func resumeAudio(sender: UIButton) {
        changeRecordStatus(.Recording)
    }
    
    func changeRecordStatus(recordStatus: recordingAudioProcess) {
        switch recordStatus {
        case .Recording:
            // Show view with buttons when recording started
            actionButtonsView.hidden = false
            // Make Stop button Active and Visible
            changeButtonStatus(stopRecordingButton, active: true)
            // Pause button Active and Visible
            changeButtonStatus(pauseRecordingButton, active: true)
            // Continue button Inactive and Invisible
            changeButtonStatus(continueRecordingButton, active: false)
            // Change label text and start recording
            recordingProgressLabel.text = "Recording.."
            audioRecorder.record()
            
        case .Paused:
            // Pause button Inactive and Inisible
            changeButtonStatus(pauseRecordingButton, active: false)
            // Continue button Active and Visible
            changeButtonStatus(continueRecordingButton, active: true)
            // Change label text and pause recording
            recordingProgressLabel.text = "Paused"
            audioRecorder.pause()
            
        case .Finished:
            // Pause button Inactive, but Visible
            changeButtonStatus(pauseRecordingButton, active: false, hidden: false)
            // Continue button Inactive and Invisible
            changeButtonStatus(continueRecordingButton, active: false)
            // Make Stop button Inactive and Invisible
            changeButtonStatus(stopRecordingButton, active: false, hidden: false)
            // Change label text and stop recording
            recordingProgressLabel.text = "Processing audio.."
            audioRecorder.stop()
        }
    }
    
    func changeButtonStatus(button: UIButton, active: Bool, hidden: Bool? = nil) {
        button.enabled = active
        if let hiddenVar = hidden {
            button.hidden = hiddenVar
        } else {
            button.hidden = !active
        }
    }
    
    // MARK: AVAudioRecorderDelegate
    // MARK:
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordingProgressLabel.text = "Record saved!"
            let recorderUrl: NSURL = recorder.url
            recorderAudio = RecorderAudio(title: recorderUrl.lastPathComponent!, filePath: recorderUrl)
            performSegueWithIdentifier(moveToPlayViewSegueId, sender: recorderAudio)
        } else {
            println("Record failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == moveToPlayViewSegueId {
            let playSounsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            if let data = sender as? RecorderAudio {
                playSounsVC.recorderAudio = data
            }
        }
    }
}

