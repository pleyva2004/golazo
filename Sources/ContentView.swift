import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Golazo ⚽️")
            .navigationDestination(for: Team.self) { TeamProfileView(team: $0) }
            .navigationDestination(for: Match.self) { PredictionDetailView(match: $0) }
        }
    }
}

struct MatchCard: View {
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

    // Tapping a flag opens the team profile.
    private func teamColumn(_ team: Team) -> some View {
        NavigationLink(value: team) {
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
            // Upcoming: tapping the center opens the prediction breakdown.
            NavigationLink(value: match) {
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
