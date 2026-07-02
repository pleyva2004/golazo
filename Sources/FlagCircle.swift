import SwiftUI

// Shared flag artwork: bundled asset named by ISO code, else the emoji flag fallback.
struct FlagContent: View {
    let team: Team
    var emojiSize: CGFloat

    var body: some View {
        if let ui = UIImage(named: team.id) {
            Image(uiImage: ui).resizable().scaledToFill()
        } else {
            Text(team.flagEmoji)
                .font(.system(size: emojiSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
        }
    }
}

// Circular flag — used on team profile & prediction headers.
struct FlagCircle: View {
    let team: Team
    var size: CGFloat = 56

    var body: some View {
        FlagContent(team: team, emojiSize: size * 0.7)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(.white.opacity(0.6), lineWidth: 1))
            .shadow(radius: 1, y: 1)
    }
}

// Rounded-rectangle flag — used in the bracket cards.
struct FlagBadge: View {
    let team: Team
    var width: CGFloat = 26
    var height: CGFloat = 18

    var body: some View {
        FlagContent(team: team, emojiSize: height * 0.95)
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(.white.opacity(0.15), lineWidth: 0.5))
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
