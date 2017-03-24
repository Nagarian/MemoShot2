//
//  MemoSoundTableViewCell.swift
//  MemoShot
//
//  Created by Developer on 23/03/2017.
//  Copyright © 2017 Nagarian. All rights reserved.
//

import UIKit
import AVFoundation

class MemoSoundTableViewCell: UITableViewCell {

    private var soundUri : URL?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var progressLink : CADisplayLink? = nil
    @IBOutlet weak var recordingActivity: UIActivityIndicatorView!
    @IBOutlet weak var playProgress: UIProgressView!
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(value: Int32(1)),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
    
    
    
    internal var soundUrl : URL {
        get {
            return soundUri!;
        }
        
        set(value) {
            soundUri = value
        }
    }

    
    
    override func layoutSubviews() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: directoryURL()!, settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {}
    }
    
    @IBAction func doRecordAction(_ sender: AnyObject) {
        playProgress.setProgress(0, animated: false)
        recordingActivity.startAnimating()
        recordingActivity.isHidden = false
        
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {}
        }
    }
    
    @IBAction func doPlayAction(_ sender: AnyObject) {
        if !audioRecorder.isRecording {
            do {
                playProgress.setProgress(0, animated: false)
                
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                progressLink = CADisplayLink(target: self,
                                             selector: #selector(MemoSoundTableViewCell.playerProgress))
                if let progressLink = progressLink {
                    progressLink.preferredFramesPerSecond = 2
                    progressLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
                }
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {}
        }
    }
    
    @IBAction func doStopAction(_ sender: AnyObject) {
        audioRecorder.stop()
        recordingActivity.stopAnimating()
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {}
    }
    
    func playerProgress() {
        var progress = Float(0)
        if let audioPlayer = audioPlayer {
            progress = ((audioPlayer.duration > 0)
                ? Float(audioPlayer.currentTime/audioPlayer.duration)
                : 0)
        }
        
        playProgress.setProgress(progress, animated: true)
    }
    
    func directoryURL() -> URL? {
        let soundURL = soundUrl
        return soundURL
    }
}

extension MemoSoundTableViewCell : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let progressLink = progressLink {
            progressLink.invalidate()
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let progressLink = progressLink {
            progressLink.invalidate()
        }
    }
}
