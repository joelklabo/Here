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

protocol AudioIntesityLevelDelegate {
    func update(intensity: Float)
}

class AudioRecorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    private let session = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder? = nil
    private var player: AVAudioPlayer? = nil 
    
    var delegate: AudioRecorderDelegate?
    var intesityDelegate: AudioIntesityLevelDelegate?
    
    var timer: Timer?
    
    var audioFileURL: URL? {
        didSet {
            if let fileURL = audioFileURL {
                player = try! AVAudioPlayer(contentsOf: fileURL)
                player?.prepareToPlay()
                player?.isMeteringEnabled = true
                player?.numberOfLoops = -1
            }
        }
    }
    
    var isRecording: Bool {
        guard let recorder = recorder else { return false }
        return recorder.isRecording
    }
    
    override init() {
        super.init()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateIntensity()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func updateIntensity() {
        guard player != nil || recorder != nil else { return }
        if let recorder = recorder, recorder.isRecording == true {
            recorder.updateMeters()
            let intensity = recorder.averagePower(forChannel: 0)
            self.intesityDelegate?.update(intensity: translate(intensity: intensity))
        }
        if let player = player, player.isPlaying == true {
            player.updateMeters()
            let intensity = player.averagePower(forChannel: 0)
            self.intesityDelegate?.update(intensity: translate(intensity: intensity))
        }
    }
    
    private func translate(intensity: Float) -> Float {
        // from -160 (minimum) to 0 (maximum)
        return 1 - abs(intensity) / 160
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
            recorder?.isMeteringEnabled = true
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
        player?.stop()
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
