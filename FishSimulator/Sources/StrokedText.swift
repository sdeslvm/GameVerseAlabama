import SwiftUI

struct StrokedText: View {
    var text: String
    var font: Font
    var strokeColor: Color
    var textColor: Color
    var strokeWidth: CGFloat
    
    init(text: String,  size: CGFloat = 36, strokeColor: Color = Color(red: 0.482, green: 0.176, blue: 0.051), textColor: Color = .white, strokeWidth: CGFloat = 2) {
        self.text = text
        self.font = .designed(size: size)
        self.strokeColor = strokeColor
        self.textColor = textColor
        self.strokeWidth = strokeWidth
    }

    var body: some View {
        ZStack {
            // Обводка
            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: -strokeWidth, y: -strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: strokeWidth, y: -strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: -strokeWidth, y: strokeWidth)

            Text(text)
                .font(font)
                .foregroundColor(strokeColor)
                .offset(x: strokeWidth, y: strokeWidth)

            // Основной текст
            Text(text)
                .font(font)
                .foregroundColor(textColor)
        }
    }
}
