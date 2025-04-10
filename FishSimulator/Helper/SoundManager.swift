//
//  MusicCentre.swift
//  DesertEagle
//
//  Created by Pavel Ivanov on 22.03.2025.
//

import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    @Published var isSoundOn: Bool = false {
        didSet {
            if isSoundOn {
                player?.volume = 1
            } else {
                player?.volume = 0
            }
        }
    }

    private init() {
        // Загружаем музыку из файла
        if let url = Bundle.main.url(forResource: "bckSound", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
    }

    func play() {
        player?.play()
    }

    func stop() {
        player?.stop()
    }
}
