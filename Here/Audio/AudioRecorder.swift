//
//  AudioRecorder.swift
//  here
//
//  Created by Joel Klabo on 7/17/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioRecorderDelegate {
    func didFinishRecording()
}

class AudioRecorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    private let session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder? = nil
    private var player: AVAudioPlayer? = nil
    
    var delegate: AudioRecorderDelegate?
    
    var audioFileURL: URL? {
        didSet {
            if let fileURL = audioFileURL {
                player = try! AVAudioPlayer(contentsOf: fileURL)
                player?.prepareToPlay()
                player?.numberOfLoops = -1
            }
        }
    }
    
    var isRecording: Bool {
        guard let recorder = recorder else { return false }
        return recorder.isRecording
    }
    
    func prepare() {

        let url = temporaryFileURL()

        do {
            try session.setActive(true)
            let formatSettings = [
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVEncoderBitRateKey: 192000,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ] as [String : Any]
            recorder = try AVAudioRecorder(url: url, settings: formatSettings)
            recorder?.prepareToRecord()
        } catch {
            fatalError("Could not create audio recorder: \(error)")
        }
        
        recorder?.delegate = self
    }
    
    func start() {
        recorder?.record()
    }
    
    func stop() {
        recorder?.stop()
    }
    
    func play() {
        player?.play()
    }
    
    func delete() {
        audioFileURL = nil
        prepare()
    }
    
    func fileURL() -> URL? {
        return audioFileURL
    }
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let recordedFileURL = recorder.url
            audioFileURL = recordedFileURL
            prepare()
            delegate?.didFinishRecording()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    // MARK - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("didFinishPlaying")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("playerDecodeErrorDidOccur")
    }
    
    // MARK - Private Helpers
    
    private func temporaryFileURL() -> URL {
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let tempFile = "\(UUID().uuidString).caf"
        return tempDirectoryURL.appendingPathComponent(tempFile)
    }
}
