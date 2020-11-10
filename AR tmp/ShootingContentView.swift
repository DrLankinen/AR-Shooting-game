//
//  ContentView.swift
//  AR tmp
//
//  Created by Elias Lankinen on 11/9/20.
//

import SwiftUI
import RealityKit

struct ShootingContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let box = ModelEntity(mesh: .generateBox(size: 0.1))
        box.position = SIMD3(x: 0, y: -0.05, z: -0.4)
        box.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic))
        let anchor = AnchorEntity(world: [0,0,0])
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
