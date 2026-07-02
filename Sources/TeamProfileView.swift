import SwiftUI

struct TeamProfileView: View {
    let team: Team

    // 4-3-3 slot coordinates (x,y in 0…1, GK at the bottom). Starters are ordered
    // GK, 4×DF, 3×MF, 3×FW in MockData, so index maps straight onto these.
    // ponytail: single 4-3-3 layout; branch on team.formation in iteration 2.
    private let slots: [CGPoint] = [
        CGPoint(x: 0.50, y: 0.92),                                              // GK
        CGPoint(x: 0.15, y: 0.72), CGPoint(x: 0.38, y: 0.74),
        CGPoint(x: 0.62, y: 0.74), CGPoint(x: 0.85, y: 0.72),                   // DF
        CGPoint(x: 0.25, y: 0.50), CGPoint(x: 0.50, y: 0.48), CGPoint(x: 0.75, y: 0.50), // MF
        CGPoint(x: 0.22, y: 0.24), CGPoint(x: 0.50, y: 0.20), CGPoint(x: 0.78, y: 0.24),  // FW
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                Text("Predicted XI · \(team.formation)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                pitch
                bench
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var header: some View {
        HStack(spacing: 14) {
            FlagCircle(team: team, size: 64)
            VStack(alignment: .leading, spacing: 2) {
                Text(team.endonym).font(.title.bold())
                Text(team.name).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private var pitch: some View {
        GeometryReader { geo in
            ZStack {
                // Field markings.
                let stripe = Color(hex: "2E8B57")
                RoundedRectangle(cornerRadius: 16).fill(stripe)
                RoundedRectangle(cornerRadius: 16).strokeBorder(.white.opacity(0.7), lineWidth: 2)
                Rectangle().fill(.white.opacity(0.5))
                    .frame(height: 1.5).frame(maxWidth: .infinity).position(x: geo.size.width/2, y: 6)
                Circle().strokeBorder(.white.opacity(0.5), lineWidth: 1.5)
                    .frame(width: 70, height: 70).position(x: geo.size.width/2, y: 0)

                ForEach(Array(team.starters.enumerated()), id: \.element.id) { i, player in
                    if i < slots.count {
                        PlayerDot(player: player, tint: Color(hex: team.colorHex))
                            .position(x: slots[i].x * geo.size.width,
                                      y: slots[i].y * geo.size.height)
                    }
                }
            }
        }
        .frame(height: 440)
    }

    private var bench: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bench").font(.headline)
            ForEach(team.bench) { player in
                HStack(spacing: 12) {
                    Text("\(player.number)")
                        .font(.subheadline.monospacedDigit().bold())
                        .frame(width: 26)
                        .foregroundStyle(Color(hex: team.colorHex))
                    Text(player.name).font(.subheadline)
                    Spacer()
                    Text(player.position).font(.caption).foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
                Divider()
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }
}

struct PlayerDot: View {
    let player: Player
    let tint: Color
    var body: some View {
        VStack(spacing: 3) {
            Text("\(player.number)")
                .font(.caption.bold().monospacedDigit())
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Circle().fill(tint))
                .overlay(Circle().strokeBorder(.white, lineWidth: 1.5))
            Text(player.name)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .shadow(radius: 1)
        }
        .frame(width: 72)
    }
}
