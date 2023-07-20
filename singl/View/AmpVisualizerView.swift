//
//  AmpVisualizerView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import SwiftUI


struct AmpVisualizerView: View {
    let dataPitch: [Double]
    let height: Double
    
    
    var body: some View {
        GeometryReader { geometry in
            
            Path { path in
                let stepX = geometry.size.width / CGFloat(dataPitch.count - 1)
                let stepY = geometry.size.height / height
                for (index, dataPoint) in dataPitch.enumerated() {
                    let x = stepX * CGFloat(index)
                    let y = geometry.size.height - (CGFloat(dataPoint) * stepY)
                    
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                        
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }.stroke(Color("Yellow"), lineWidth: 3)
        }
    }
}
