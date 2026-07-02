import Foundation

// Iteration 1: everything here is hand-mocked. Iteration 2 replaces MockData with a real
// data pipeline + prediction service; the UI reads only these types, so it won't change.

struct Team: Identifiable, Hashable {
    let id: String          // flagcdn / ISO code, e.g. "br"
    let name: String        // English name
    let endonym: String     // cultural spelling shown in the UI, e.g. "Brasil"
    let flagEmoji: String   // fallback when the bundled flag image isn't present
    let colorHex: String    // accent used on the pitch / bars
    let formation: String   // e.g. "4-3-3"
    let players: [Player]   // 11 starters + bench, order = shirt list

    var starters: [Player] { players.filter { $0.isStarter } }
    var bench: [Player] { players.filter { !$0.isStarter } }
}

struct Player: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let name: String
    let position: String    // "GK","DF","MF","FW"
    let isStarter: Bool
}

enum Stage: String { case quarterfinal = "Quarterfinals", semifinal = "Semifinals", final = "Final" }

// A single model's view of a matchup (iteration 2: real model outputs).
struct ModelPrediction: Identifiable, Hashable {
    let id = UUID()
    let model: String       // "Elo", "xG / Poisson", ...
    let homeWinPct: Int
    let awayWinPct: Int
    var drawPct: Int { max(0, 100 - homeWinPct - awayWinPct) }
}

struct Match: Identifiable, Hashable {
    let id = UUID()
    let stage: Stage
    let home: Team
    let away: Team
    // Played matches carry a score; upcoming matches carry a prediction instead.
    let homeScore: Int?
    let awayScore: Int?
    let homeWinPct: Int?    // aggregated prediction (upcoming only)
    let awayWinPct: Int?
    let models: [ModelPrediction]

    var isPlayed: Bool { homeScore != nil && awayScore != nil }
    var winner: Team? {
        guard let h = homeScore, let a = awayScore, h != a else { return nil }
        return h > a ? home : away
    }
    var drawPct: Int? {
        guard let h = homeWinPct, let a = awayWinPct else { return nil }
        return max(0, 100 - h - a)
    }
}
