//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Yassin Raman on 19/06/2016.
//  Copyright © 2016 Yassin Raman. All rights reserved.
//

import UIKit
import AVFoundation //sound framework

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.enabled = false
    }

    @IBAction func recordAudio(sender: AnyObject) {
        
        uiElementsState(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordingVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self //setting this view controller as a delegate to AVAudioRecorder
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(sender: AnyObject) {
        uiElementsState(false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func uiElementsState(on: Bool) {
        if on {
            recordingLabel.text = "Recording..."
            stopRecordingButton.enabled = true
            recordingButton.enabled = false
        } else {
            recordingButton.enabled = true
            stopRecordingButton.enabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
    
    
    //can override func since we conform/implements the AVAudioRecorderDelegate interface
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecording finished saving recording")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
        
    }
 
   
    
    
}

