//
//  WaveView.swift
//  Escape
//
//  Created by Tatiana6mo on 7/18/26.
//

import SwiftUI

struct WaveView: View {
    
    @State private var waveOffset = 0.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let offset = now.remainder(dividingBy: 2) / 2
                
                // WAVE 1 — front wave
                var wave1 = Path()
                wave1.move(to: CGPoint(x: 0, y: size.height * 0.5))
                
                for x in stride(from: 0, to: size.width, by: 1) {
                    let relativeX = x / size.width
                    let y = sin((relativeX + offset) * .pi * 2) * 20 + size.height * 0.5
                    wave1.addLine(to: CGPoint(x: x, y: y))
                }
                
                wave1.addLine(to: CGPoint(x: size.width, y: size.height))
                wave1.addLine(to: CGPoint(x: 0, y: size.height))
                wave1.closeSubpath()
                
                context.fill(wave1, with: .color(.white.opacity(0.3)))
                
                // WAVE 2 — back wave
                var wave2 = Path()
                wave2.move(to: CGPoint(x: 0, y: size.height * 0.6))
                
                for x in stride(from: 0, to: size.width, by: 1) {
                    let relativeX = x / size.width
                    let y = sin((relativeX + offset + 0.5) * .pi * 2) * 15 + size.height * 0.6
                    wave2.addLine(to: CGPoint(x: x, y: y))
                }
                
                wave2.addLine(to: CGPoint(x: size.width, y: size.height))
                wave2.addLine(to: CGPoint(x: 0, y: size.height))
                wave2.closeSubpath()
                
                context.fill(wave2, with: .color(.white.opacity(0.15)))
            }
        }
        .ignoresSafeArea()
    }
}

