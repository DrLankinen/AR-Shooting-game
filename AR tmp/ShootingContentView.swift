//
//  ContentView.swift
//  AR tmp
//
//  Created by Elias Lankinen on 11/9/20.
//

import SwiftUI
import RealityKit

struct ShootingContentView : View {
    @State var abc: Bool = false
    var body: some View {
        ARViewContainer(abc: $abc).edgesIgnoringSafeArea(.all)
        Button("hello") { self.abc = !abc }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let box = ModelEntity(mesh: .generateBox(size: 10))
//    let anchor = AnchorEntity(world: [0,0,0])
    let anchor = AnchorEntity()
    @Binding var abc: Bool
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
//        let box = ModelEntity(mesh: .generateBox(size: 0.1))
//        box.components.set(ModelComponent(mesh: .generateBox(size: [0.2, 0.3, 0.2]),materials: [SimpleMaterial(color: .gray, isMetallic: true)]))
        box.components.set(CollisionComponent(
            shapes: [.generateBox(size: [0.2, 0.3, 0.2])],
            mode: .trigger,
            filter: .sensor
        ))
        box.components.set(PhysicsBodyComponent(massProperties: PhysicsMassProperties(mass: 0.05), material: PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.8), mode: .dynamic))
        box.components.set(PhysicsMotionComponent(linearVelocity: [0,-0.02,0], angularVelocity: [0,0,0]))
        anchor.addChild(box)
//        box.addForce(SIMD3([0,0,10]), relativeTo: anchor)
        arView.scene.addAnchor(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if abc {
            box.addForce([1,2,20], relativeTo: anchor)
        }
    }
    
}
