//  Created by Daniel Langh

import Foundation

struct Meditation: Decodable, Equatable, Identifiable {
    var id: Int
    var title: String
    var subtitle: String
    var description: String
    var audioFiles: [AudioFile]
    
    static func == (lhs: Meditation, rhs: Meditation) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case description
        case audioFiles = "audio_files"
    }
}

struct AudioFile: Decodable, Identifiable {
    var id: Int
    var audio: URL
    var name: String
    var durationSeconds: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case audio
        case name
        case durationSeconds = "duration_seconds"
    }
}

extension Meditation {
    
    static let formatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter
    }()

    var duration: String {
        if let seconds = audioFiles.first?.durationSeconds,
           let string = Meditation.formatter.string(from: TimeInterval(seconds)) {
            return string
        }
        return "-"
    }
}
