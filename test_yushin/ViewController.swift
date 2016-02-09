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
    //audio系宣言
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    //ボタン宣言
    var recordButton: UIButton!
    var playButton: UIButton!
    
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
                        // 録音準備失敗
                    }
                }
            }
        } catch {
            // 録音準備失敗
        }
        
    }
    
    //録音ボタン生成
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
    
    //録音ボタンタッチ時
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(true)
        }
    }

    
    //録音開始
    func startRecording() {
        //保存情報
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        //各種設定(気にしない)
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
            //録音失敗
            finishRecording(false)
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    //レコード終了
    func finishRecording(success: Bool) {
        //平均音量取得
        audioRecorder.updateMeters()
        NSLog("録音音量は%f", audioRecorder.averagePowerForChannel(0))   //必ず0にする！！
        //録音ストップ
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", forState: .Normal)
        } else {
            recordButton.setTitle("Tap to Record", forState: .Normal)   // 録音失敗時
        }
        
        //再生ボタン生成
        playButton = UIButton()
        playButton.frame = CGRectMake(self.view.bounds.width/4, self.view.bounds.height/4*3, self.view.bounds.width/2, 80)
        playButton.backgroundColor = UIColor.redColor()
        playButton.setTitle("Tap to Play", forState: .Normal)
        playButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        playButton.addTarget(self, action: "playTapped", forControlEvents: .TouchUpInside)
        view.addSubview(playButton)
        
    }
    
    //再生ボタンタップ時
    func playTapped(){
        //再生情報
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: audioURL)
        } catch {
            //再生失敗
        }
        audioPlayer.play()
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

