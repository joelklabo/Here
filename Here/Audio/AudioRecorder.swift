//
//  AudioRecorder.swift
//  here
//
//  Created by Joel Klabo on 7/17/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    private let session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder? = nil
    private var player: AVAudioPlayer? = nil
    var audioFileURL: URL? {
        didSet {
            if let fileURL = audioFileURL {
                player = try! AVAudioPlayer(contentsOf: fileURL)
                player?.prepareToPlay()
            }
        }
    }
    
    func prepare() {
        let sampleRate: Double = 48000
        let channelCount: AVAudioChannelCount = 2
        let url = temporaryFileURL()
        guard let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: channelCount) else {
            fatalError("Invalid audio format")
        }
        do {
            try recorder = AVAudioRecorder(url: url, format: audioFormat)
            try session.setActive(true)
        } catch {
            fatalError("Could not create audio recorder: \(error)")
        }
        recorder?.delegate = self
        recorder?.prepareToRecord()
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
