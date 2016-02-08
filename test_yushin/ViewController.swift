//
//  ViewController.swift
//  test_yushin
//
//  Created by 荒川陸 on 2016/01/06.
//  Copyright © 2016年 com.litech. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class ViewController: UIViewController,AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordButton: UIButton!
    var playButton: UIButton!
    var recordingSession: AVAudioSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    
    func loadRecordingUI() {
        recordButton = UIButton()
        recordButton.frame = CGRectMake(self.view.bounds.width/4, self.view.bounds.height/4, self.view.bounds.width/2, 80)
        recordButton.backgroundColor = UIColor.redColor()
        recordButton.setTitle("Tap to Record", forState: .Normal)
        //recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        recordButton.addTarget(self, action: "recordTapped", forControlEvents: .TouchUpInside)
        view.addSubview(recordButton)
        print ("success")
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

    
    //レコード開始
    func startRecording() {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            //音量測定をできるようにしておく
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", forState: .Normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    //レコード終了
    func finishRecording(success success: Bool) {
        
       
        //audioRecorder.updateMeters()
        NSLog("recorder音量は%f", audioRecorder.averagePowerForChannel(0))

        audioRecorder.stop()
        
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", forState: .Normal)
        } else {
            recordButton.setTitle("Tap to Record", forState: .Normal)
            // recording failed
        }
        
        playButton = UIButton()
        playButton.frame = CGRectMake(self.view.bounds.width/4, self.view.bounds.height/4*3, self.view.bounds.width/2, 80)
        playButton.backgroundColor = UIColor.redColor()
        playButton.setTitle("Tap to Play", forState: .Normal)
        playButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        playButton.addTarget(self, action: "playTapped", forControlEvents: .TouchUpInside)
        view.addSubview(playButton)
        
       
    }
    
    func playTapped(){
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioURL)
        } catch {
            //fail to play!
        }
        audioPlayer.play()
        
        /*これじゃうまくいかない
        NSLog("音量は%f", audioPlayer.volume)
        */
        
        audioPlayer.updateMeters()
        NSLog("player音量は%f", audioPlayer.averagePowerForChannel(1))
       
        
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

