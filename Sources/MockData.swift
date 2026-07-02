import Foundation

// Single source of truth for iteration 1. Iteration 2 swaps this enum's guts for a real
// data/prediction layer — the views only ever touch `MockData.rounds`.
enum MockData {

    // MARK: Players helper
    private static func p(_ n: Int, _ name: String, _ pos: String, _ starter: Bool = true) -> Player {
        Player(number: n, name: name, position: pos, isStarter: starter)
    }

    // MARK: Teams (all 4-3-3 for iteration 1 — see TeamProfileView pitch layout)
    // ponytail: single formation layout; add per-team formations in iteration 2.
    static let brasil = Team(id: "br", name: "Brazil", endonym: "Brasil", flagEmoji: "🇧🇷",
        colorHex: "009C3B", formation: "4-3-3", players: [
        p(1,"Alisson","GK"), p(2,"Danilo","DF"), p(4,"Marquinhos","DF"), p(3,"Éder Militão","DF"),
        p(6,"Wendell","DF"), p(5,"Bruno Guimarães","MF"), p(10,"Lucas Paquetá","MF"),
        p(21,"Rodrygo","MF"), p(7,"Vinícius Jr","FW"), p(19,"Raphinha","FW"), p(9,"Endrick","FW"),
        p(12,"Ederson","GK",false), p(14,"Bremer","DF",false), p(15,"Casemiro","MF",false),
        p(18,"Martinelli","FW",false)])

    static let argentina = Team(id: "ar", name: "Argentina", endonym: "Argentina", flagEmoji: "🇦🇷",
        colorHex: "6CACE4", formation: "4-3-3", players: [
        p(23,"E. Martínez","GK"), p(26,"Molina","DF"), p(13,"Romero","DF"), p(19,"Otamendi","DF"),
        p(3,"Tagliafico","DF"), p(7,"De Paul","MF"), p(24,"Enzo Fernández","MF"),
        p(20,"Mac Allister","MF"), p(10,"Messi","FW"), p(9,"J. Álvarez","FW"), p(11,"Di María","FW"),
        p(12,"Armani","GK",false), p(25,"L. Martínez","DF",false), p(5,"Paredes","MF",false),
        p(22,"Lautaro","FW",false)])

    static let espana = Team(id: "es", name: "Spain", endonym: "España", flagEmoji: "🇪🇸",
        colorHex: "C60B1E", formation: "4-3-3", players: [
        p(23,"Unai Simón","GK"), p(2,"Carvajal","DF"), p(14,"Le Normand","DF"), p(24,"Laporte","DF"),
        p(3,"Cucurella","DF"), p(16,"Rodri","MF"), p(9,"Pedri","MF"), p(8,"Fabián Ruiz","MF"),
        p(19,"Lamine Yamal","FW"), p(7,"Morata","FW"), p(17,"Nico Williams","FW"),
        p(1,"Raya","GK",false), p(4,"Vivian","DF",false), p(21,"Dani Olmo","MF",false),
        p(11,"Ferran Torres","FW",false)])

    static let deutschland = Team(id: "de", name: "Germany", endonym: "Deutschland", flagEmoji: "🇩🇪",
        colorHex: "000000", formation: "4-3-3", players: [
        p(1,"Neuer","GK"), p(6,"Kimmich","DF"), p(4,"Tah","DF"), p(2,"Rüdiger","DF"),
        p(18,"Mittelstädt","DF"), p(23,"Andrich","MF"), p(21,"Gündoğan","MF"), p(14,"Musiala","MF"),
        p(19,"Sané","FW"), p(7,"Havertz","FW"), p(10,"Wirtz","FW"),
        p(22,"ter Stegen","GK",false), p(15,"Schlotterbeck","DF",false), p(8,"Groß","MF",false),
        p(9,"Füllkrug","FW",false)])

    static let france = Team(id: "fr", name: "France", endonym: "France", flagEmoji: "🇫🇷",
        colorHex: "0055A4", formation: "4-3-3", players: [
        p(16,"Maignan","GK"), p(5,"Koundé","DF"), p(17,"Saliba","DF"), p(4,"Upamecano","DF"),
        p(22,"T. Hernández","DF"), p(8,"Tchouaméni","MF"), p(14,"Rabiot","MF"), p(7,"Griezmann","MF"),
        p(11,"Dembélé","FW"), p(10,"Mbappé","FW"), p(12,"Kolo Muani","FW"),
        p(23,"Samba","GK",false), p(15,"Konaté","DF",false), p(6,"Camavinga","MF",false),
        p(9,"Thuram","FW",false)])

    static let nederland = Team(id: "nl", name: "Netherlands", endonym: "Nederland", flagEmoji: "🇳🇱",
        colorHex: "AE1C28", formation: "4-3-3", players: [
        p(1,"Verbruggen","GK"), p(22,"Dumfries","DF"), p(6,"de Vrij","DF"), p(4,"Van Dijk","DF"),
        p(5,"Aké","DF"), p(24,"Schouten","MF"), p(14,"Reijnders","MF"), p(11,"Gakpo","MF"),
        p(7,"Simons","FW"), p(10,"Depay","FW"), p(18,"Malen","FW"),
        p(23,"Flekken","GK",false), p(3,"van de Ven","DF",false), p(20,"Veerman","MF",false),
        p(9,"Weghorst","FW",false)])

    static let hrvatska = Team(id: "hr", name: "Croatia", endonym: "Hrvatska", flagEmoji: "🇭🇷",
        colorHex: "FF0000", formation: "4-3-3", players: [
        p(1,"Livaković","GK"), p(2,"Stanišić","DF"), p(6,"Šutalo","DF"), p(20,"Gvardiol","DF"),
        p(19,"Sosa","DF"), p(10,"Modrić","MF"), p(11,"Brozović","MF"), p(8,"Kovačić","MF"),
        p(9,"Kramarić","FW"), p(17,"Budimir","FW"), p(4,"Perišić","FW"),
        p(12,"Ivušić","GK",false), p(21,"Pongračić","DF",false), p(15,"Pašalić","MF",false),
        p(24,"Baturina","FW",false)])

    static let maroc = Team(id: "ma", name: "Morocco", endonym: "المغرب", flagEmoji: "🇲🇦",
        colorHex: "C1272D", formation: "4-3-3", players: [
        p(1,"Bounou","GK"), p(2,"Hakimi","DF"), p(6,"Aguerd","DF"), p(5,"Saïss","DF"),
        p(3,"Mazraoui","DF"), p(4,"Amrabat","MF"), p(8,"Ounahi","MF"), p(10,"Amallah","MF"),
        p(7,"Ziyech","FW"), p(19,"En-Nesyri","FW"), p(17,"Boufal","FW"),
        p(12,"Munir","GK",false), p(18,"El Yamiq","DF",false), p(11,"Sabiri","MF",false),
        p(9,"Adli","FW",false)])

    // MARK: Bracket
    static let rounds: [(stage: Stage, matches: [Match])] = [
        (.quarterfinal, [
            Match(stage: .quarterfinal, home: brasil, away: hrvatska,
                  homeScore: 2, awayScore: 1, homeWinPct: nil, awayWinPct: nil, models: []),
            Match(stage: .quarterfinal, home: nederland, away: argentina,
                  homeScore: 1, awayScore: 2, homeWinPct: nil, awayWinPct: nil, models: []),
            Match(stage: .quarterfinal, home: espana, away: maroc,
                  homeScore: 2, awayScore: 0, homeWinPct: nil, awayWinPct: nil, models: []),
            Match(stage: .quarterfinal, home: france, away: deutschland,
                  homeScore: 3, awayScore: 1, homeWinPct: nil, awayWinPct: nil, models: []),
        ]),
        (.semifinal, [
            Match(stage: .semifinal, home: brasil, away: argentina,
                  homeScore: nil, awayScore: nil, homeWinPct: 46, awayWinPct: 41, models: [
                    ModelPrediction(model: "Elo", homeWinPct: 44, awayWinPct: 42),
                    ModelPrediction(model: "xG / Poisson", homeWinPct: 48, awayWinPct: 40),
                    ModelPrediction(model: "Market odds", homeWinPct: 45, awayWinPct: 41),
                    ModelPrediction(model: "Form-based", homeWinPct: 47, awayWinPct: 39),
                    ModelPrediction(model: "Neural net", homeWinPct: 46, awayWinPct: 43),
                  ]),
            Match(stage: .semifinal, home: espana, away: france,
                  homeScore: nil, awayScore: nil, homeWinPct: 39, awayWinPct: 47, models: [
                    ModelPrediction(model: "Elo", homeWinPct: 40, awayWinPct: 46),
                    ModelPrediction(model: "xG / Poisson", homeWinPct: 37, awayWinPct: 49),
                    ModelPrediction(model: "Market odds", homeWinPct: 39, awayWinPct: 47),
                    ModelPrediction(model: "Form-based", homeWinPct: 41, awayWinPct: 45),
                    ModelPrediction(model: "Neural net", homeWinPct: 38, awayWinPct: 48),
                  ]),
        ]),
        (.final, [
            // Projected favorites until the semis resolve.
            Match(stage: .final, home: argentina, away: france,
                  homeScore: nil, awayScore: nil, homeWinPct: 48, awayWinPct: 45, models: [
                    ModelPrediction(model: "Elo", homeWinPct: 49, awayWinPct: 44),
                    ModelPrediction(model: "xG / Poisson", homeWinPct: 47, awayWinPct: 46),
                    ModelPrediction(model: "Market odds", homeWinPct: 48, awayWinPct: 45),
                    ModelPrediction(model: "Form-based", homeWinPct: 50, awayWinPct: 43),
                    ModelPrediction(model: "Neural net", homeWinPct: 47, awayWinPct: 46),
                  ]),
        ]),
    ]

    // Smallest thing that fails if the mock is malformed.
    static func selfCheck() {
        for (_, matches) in rounds {
            for m in matches {
                assert(m.home.starters.count == 11, "\(m.home.name) needs 11 starters")
                assert(m.away.starters.count == 11, "\(m.away.name) needs 11 starters")
                if let h = m.homeWinPct, let a = m.awayWinPct {
                    assert(h + a <= 100, "\(m.home.name) v \(m.away.name) win% > 100")
                }
            }
        }
    }
}
