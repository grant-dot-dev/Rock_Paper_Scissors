import UIKit
extension String {
    func image(pointSize: CGFloat, backgroundColor: UIColor = .clear) -> UIImage {
        let font = UIFont.systemFont(ofSize: pointSize)
        let emojiSize = self.size(withAttributes: [.font: font])

        return UIGraphicsImageRenderer(size: emojiSize).image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: emojiSize))
            self.draw(at: .zero, withAttributes: [.font: font])
        }
    }
}
