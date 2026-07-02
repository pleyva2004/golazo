import SwiftUI
import Charts

struct PredictionDetailView: View {
    let match: Match

    private var chartData: [(model: String, side: String, pct: Int)] {
        match.models.flatMap { m in
            [(m.model, match.home.endonym, m.homeWinPct),
             (m.model, match.away.endonym, m.awayWinPct)]
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                header
                aggregate
                breakdown
                if !match.models.isEmpty { chart }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        HStack {
            VStack(spacing: 6) { FlagCircle(team: match.home, size: 60); Text(match.home.endonym).font(.subheadline) }
                .frame(maxWidth: .infinity)
            Text("vs").font(.headline).foregroundStyle(.secondary)
            VStack(spacing: 6) { FlagCircle(team: match.away, size: 60); Text(match.away.endonym).font(.subheadline) }
                .frame(maxWidth: .infinity)
        }
    }

    private var aggregate: some View {
        VStack(spacing: 10) {
            Text("Aggregated forecast").font(.headline)
            HStack {
                pctBlock(match.homeWinPct ?? 0, "Home", .blue)
                pctBlock(match.drawPct ?? 0, "Draw", .gray)
                pctBlock(match.awayWinPct ?? 0, "Away", .red)
            }
            WinBar(home: match.homeWinPct ?? 0, away: match.awayWinPct ?? 0)
                .frame(height: 10)
            Text("Ensemble of \(match.models.count) models, weighted by recent calibration.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }

    private func pctBlock(_ v: Int, _ label: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(v)%").font(.title2.bold().monospacedDigit()).foregroundStyle(color)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var breakdown: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Model aggregation").font(.headline)
            ForEach(match.models) { m in
                HStack {
                    Text(m.model).font(.subheadline)
                    Spacer()
                    Text("\(m.homeWinPct)% · \(m.drawPct)% · \(m.awayWinPct)%")
                        .font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
                Divider()
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }

    private var chart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Home vs away win % by model").font(.headline)
            Chart(chartData, id: \.model) { row in
                BarMark(
                    x: .value("Model", row.model),
                    y: .value("Win %", row.pct)
                )
                .foregroundStyle(by: .value("Side", row.side))
                .position(by: .value("Side", row.side))
            }
            .chartForegroundStyleScale([match.home.endonym: Color.blue, match.away.endonym: Color.red])
            .frame(height: 220)
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }
}
