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

struct BracketView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ForEach(MockData.rounds, id: \.stage) { round in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(round.stage.rawValue)
                            .font(.title3.bold())
                            .padding(.horizontal)
                        ForEach(round.matches) { match in
                            MatchCard(match: match)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct MatchCard: View {
    @EnvironmentObject private var router: Router
    let match: Match

    var body: some View {
        HStack(spacing: 8) {
            teamColumn(match.home)
            centerColumn
            teamColumn(match.away)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    // Tapping a flag jumps the pager to that team's profile.
    private func teamColumn(_ team: Team) -> some View {
        Button { router.go(to: .team(team)) } label: {
            VStack(spacing: 6) {
                FlagCircle(team: team, size: 56)
                Text(team.endonym)
                    .font(.subheadline.weight(isWinner(team) ? .bold : .regular))
                    .foregroundStyle(isWinner(team) ? Color.primary : .secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var centerColumn: some View {
        if match.isPlayed {
            VStack(spacing: 4) {
                Text("\(match.homeScore!)–\(match.awayScore!)")
                    .font(.title2.bold().monospacedDigit())
                Text("FT").font(.caption2).foregroundStyle(.secondary)
            }
            .frame(width: 76)
        } else {
            // Upcoming: tapping the center jumps to the prediction breakdown.
            Button { router.go(to: .prediction(match)) } label: {
                VStack(spacing: 5) {
                    Text("vs").font(.caption).foregroundStyle(.secondary)
                    WinBar(home: match.homeWinPct ?? 0, away: match.awayWinPct ?? 0)
                    HStack(spacing: 3) {
                        Text("\(match.homeWinPct ?? 0)%").font(.caption2.monospacedDigit())
                        Image(systemName: "chart.bar.xaxis").font(.system(size: 9))
                        Text("\(match.awayWinPct ?? 0)%").font(.caption2.monospacedDigit())
                    }
                    .foregroundStyle(.secondary)
                }
                .frame(width: 76)
            }
            .buttonStyle(.plain)
        }
    }

    private func isWinner(_ team: Team) -> Bool { match.winner == team }
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
