import SwiftUI

// One linear list of screens the pager walks: bracket → each team → each prediction.
enum Page: Hashable {
    case bracket
    case team(Team)
    case prediction(Match)
}

final class Router: ObservableObject {
    let pages: [Page] = [.bracket]
        + MockData.allTeams.map(Page.team)
        + MockData.upcomingMatches.map(Page.prediction)
    @Published var index = 0

    var current: Page { pages[index] }
    var canPrev: Bool { index > 0 }
    var canNext: Bool { index < pages.count - 1 }
    func prev() { if canPrev { index -= 1 } }
    func next() { if canNext { index += 1 } }
    func go(to page: Page) { if let i = pages.firstIndex(of: page) { index = i } }

    var title: String {
        switch current {
        case .bracket: return "Golazo ⚽️"
        case .team(let t): return t.endonym
        case .prediction(let m): return "\(m.home.endonym) v \(m.away.endonym)"
        }
    }
}

struct ContentView: View {
    @StateObject private var router = Router()

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch router.current {
                case .bracket: BracketView()
                case .team(let t): TeamProfileView(team: t)
                case .prediction(let m): PredictionDetailView(match: m)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            PagerBar()
        }
        .environmentObject(router)
    }
}

// Bottom navigation bar: < prev | current title | next >.
struct PagerBar: View {
    @EnvironmentObject private var router: Router

    var body: some View {
        HStack {
            Button(action: router.prev) {
                Image(systemName: "chevron.left").font(.title3.bold()).frame(width: 44, height: 44)
            }
            .disabled(!router.canPrev)

            Spacer()
            Text(router.title).font(.headline).lineLimit(1)
            Spacer()

            Button(action: router.next) {
                Image(systemName: "chevron.right").font(.title3.bold()).frame(width: 44, height: 44)
            }
            .disabled(!router.canNext)
        }
        .padding(.horizontal)
        .padding(.top, 6)
        .background(.bar)
    }
}

// Fixed 4→2→1 bracket geometry + dark palette.
// ponytail: hardcoded for 3 rounds; generalize to an N-round engine only if data grows to R16/R32.
private enum BK {
    static let bg = Color(hex: "1C1C1E")
    static let card = Color(hex: "2C2C2E")
    static let secondary = Color(hex: "8E8E93")
    static let cardW: CGFloat = 232
    static let cardH: CGFloat = 104
    static let colGap: CGFloat = 48
    static let rowGap: CGFloat = 18
    static let headerH: CGFloat = 44
    static var unit: CGFloat { cardH + rowGap }

    static func x(_ r: Int) -> CGFloat { CGFloat(r) * (cardW + colGap) }
    static func centerY(_ r: Int, _ i: Int) -> CGFloat {
        let p = pow(2.0, Double(r))
        let topPad = CGFloat((p - 1) / 2) * unit
        let step = CGFloat(p) * unit
        return headerH + topPad + CGFloat(i) * step + cardH / 2
    }
}

struct BracketView: View {
    private let rounds = MockData.rounds

    private var totalW: CGFloat { BK.x(rounds.count - 1) + BK.cardW }
    private var totalH: CGFloat { BK.centerY(0, rounds[0].matches.count - 1) + BK.cardH / 2 + 8 }

    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                Connectors(rounds: rounds).frame(width: totalW, height: totalH)

                ForEach(Array(rounds.enumerated()), id: \.offset) { r, round in
                    Text(round.stage.rawValue)
                        .font(.headline).foregroundStyle(.white)
                        .frame(width: BK.cardW, alignment: .leading)
                        .offset(x: BK.x(r) + 4, y: 10)

                    ForEach(Array(round.matches.enumerated()), id: \.element.id) { i, match in
                        MatchCard(match: match)
                            .offset(x: BK.x(r), y: BK.centerY(r, i) - BK.cardH / 2)
                    }
                }
            }
            .frame(width: totalW, height: totalH, alignment: .topLeading)
            .padding(20)
        }
        .background(BK.bg)
    }
}

// Elbow lines from each pair of feeder matches into the next round's match.
struct Connectors: View {
    let rounds: [(stage: Stage, matches: [Match])]

    var body: some View {
        Canvas { ctx, _ in
            var path = Path()
            for r in 1..<rounds.count {
                for j in 0..<rounds[r].matches.count {
                    let px = BK.x(r), pcy = BK.centerY(r, j)
                    for c in [2 * j, 2 * j + 1] where c < rounds[r - 1].matches.count {
                        let cx = BK.x(r - 1) + BK.cardW
                        let ccy = BK.centerY(r - 1, c)
                        let midX = (cx + px) / 2
                        path.move(to: CGPoint(x: cx, y: ccy))
                        path.addLine(to: CGPoint(x: midX, y: ccy))
                        path.addLine(to: CGPoint(x: midX, y: pcy))
                        path.addLine(to: CGPoint(x: px, y: pcy))
                    }
                }
            }
            ctx.stroke(path, with: .color(BK.secondary.opacity(0.5)),
                       style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
        }
    }
}

struct MatchCard: View {
    @EnvironmentObject private var router: Router
    let match: Match

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            header
            teamRow(match.home, score: match.homeScore, pens: match.homePens)
            teamRow(match.away, score: match.awayScore, pens: match.awayPens)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(width: BK.cardW, height: BK.cardH, alignment: .top)
        .background(BK.card, in: RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder private var header: some View {
        if match.hasPrediction {
            // Tapping the header of an upcoming match opens the prediction breakdown.
            Button { router.go(to: .prediction(match)) } label: {
                HStack {
                    Text(match.dateLabel).font(.caption).foregroundStyle(BK.secondary)
                    Spacer()
                    Image(systemName: "chart.bar.xaxis").font(.caption2).foregroundStyle(BK.secondary)
                }
            }
            .buttonStyle(.plain)
        } else {
            HStack {
                Text(match.dateLabel).font(.caption).foregroundStyle(BK.secondary)
                Spacer()
                if let s = match.statusLabel { StatusPill(text: s) }
            }
        }
    }

    private func teamRow(_ team: Team, score: Int?, pens: Int?) -> some View {
        let tbd = match.projected
        let isWin = !tbd && match.winner == team
        let dimmed = match.isPlayed && !isWin
        let color: Color = tbd || dimmed ? BK.secondary : .white

        return Button { if !tbd { router.go(to: .team(team)) } } label: {
            HStack(spacing: 8) {
                if tbd {
                    Image(systemName: "shield.fill").font(.system(size: 15)).foregroundStyle(BK.secondary)
                    Text("TBD").font(.subheadline).foregroundStyle(BK.secondary)
                } else {
                    FlagBadge(team: team)
                    Text(team.endonym)
                        .font(.subheadline).fontWeight(isWin ? .bold : .regular)
                        .foregroundStyle(color).lineLimit(1)
                }
                Spacer()
                if let sc = score {
                    Text(scoreText(sc, pens))
                        .font(.subheadline.monospacedDigit()).fontWeight(isWin ? .bold : .regular)
                        .foregroundStyle(color)
                    if isWin {
                        Image(systemName: "chevron.left").font(.caption2.bold()).foregroundStyle(.white)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(tbd)
    }

    private func scoreText(_ s: Int, _ p: Int?) -> String { p == nil ? "\(s)" : "\(s) (\(p!))" }
}

struct StatusPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(BK.secondary)
            .padding(.horizontal, 7).padding(.vertical, 3)
            .background(Capsule().fill(.white.opacity(0.12)))
    }
}

// Home | draw | away probability bar.
struct WinBar: View {
    let home: Int
    let away: Int
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let draw = max(0, 100 - home - away)
            HStack(spacing: 0) {
                Rectangle().fill(.blue).frame(width: w * CGFloat(home) / 100)
                Rectangle().fill(.gray.opacity(0.4)).frame(width: w * CGFloat(draw) / 100)
                Rectangle().fill(.red).frame(width: w * CGFloat(away) / 100)
            }
        }
        .frame(height: 6)
        .clipShape(Capsule())
    }
}
