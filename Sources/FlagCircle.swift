import SwiftUI

// Renders the bundled flag asset (named by the team's ISO code) clipped to a circle.
// Falls back to the emoji flag when the image asset isn't bundled — so the UI is complete
// with or without the downloaded PNGs.
struct FlagCircle: View {
    let team: Team
    var size: CGFloat = 56

    var body: some View {
        Group {
            if let ui = UIImage(named: team.id) {
                Image(uiImage: ui).resizable().scaledToFill()
            } else {
                Text(team.flagEmoji)
                    .font(.system(size: size * 0.7))
                    .frame(width: size, height: size)
                    .background(Color(.secondarySystemBackground))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().strokeBorder(.white.opacity(0.6), lineWidth: 1))
        .shadow(radius: 1, y: 1)
    }
}

extension Color {
    init(hex: String) {
        let v = UInt64(hex, radix: 16) ?? 0
        self.init(.sRGB,
                  red: Double((v >> 16) & 0xFF) / 255,
                  green: Double((v >> 8) & 0xFF) / 255,
                  blue: Double(v & 0xFF) / 255)
    }
}
