//
// AnimationFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public typealias Keyframe = Animation.Frame

public extension Animation {
    /// A single keyframe in an animation sequence.
    struct Frame: Hashable, Sendable {
        /// The position in the animation timeline, between `0%` and `100%`
        let position: Percentage

        /// The property transformations to apply at this position
        var styles: OrderedSet<InlineStyle>

        /// Creates a frame with a single predefined animation
        init(_ position: Percentage, data: OrderedSet<InlineStyle> = []) {
            precondition(
                position >= 0% && position <= 100%,
                "Animation frame position must be between 0% and 100%, got \(position)%"
            )
            self.position = position
            self.styles = data
        }
    }
}

public extension Animation.Frame {
    /// Sets a color for this keyframe
    /// - Parameters:
    ///   - area: Which color property to animate (text or background). Default is `.foreground`.
    ///   - value: The color to animate to
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func color(_ area: ColorArea = .foreground, to value: Color) {
        styles.append(.init(animatable: area.property, value: value.description))
    }

    /// Sets the scale transform for this keyframe
    /// - Parameter value: The scale factor to animate to (e.g., 1.5 for 150% size)
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func scale(_ value: Double) {
        styles.append(.init(animatable: .transform, value: "scale(\(value))"))
    }

    /// Sets the rotation transform for this keyframe
    /// - Parameters:
    ///   - angle: The angle to rotate by
    ///   - anchor: The point around which to rotate (defaults to center)
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func rotate(_ angle: Angle, anchor: AnchorPoint = .center) {
        styles.append(.init(animatable: .transformOrigin, value: anchor.value))
        styles.append(.init(animatable: .transform, value: "rotate(\(angle.value))"))
    }

    /// Sets a custom style transformation for this keyframe
    /// - Parameter property: The CSS property to animate
    /// - Parameter value: The CSS value
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func custom(_ property: AnimatableProperty, value: String) {
        styles.append(.init(animatable: property, value: value))
    }
}
