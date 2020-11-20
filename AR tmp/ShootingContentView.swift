//
//  ContentView.swift
//  AR tmp
//
//  Created by Elias Lankinen on 11/9/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ShootingContentView : View {
    @State var abc: Bool = false
    var body: some View {
        ARViewContainer(abc: $abc).edgesIgnoringSafeArea(.all)
        Button("hello") { self.abc = !abc }
    }
}

let gold = SimpleMaterial(color: .yellow, isMetallic: true)

extension ARView {
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("tap")
        
        let anchor = ARAnchor(name: "Particle", transform: self.cameraTransform.matrix)
        self.session.add(anchor: anchor)
    }
    
    func shootBox() {
        let box = ModelEntity(mesh: .generateBox(size: 5), materials: [gold])
        
        box.components.set(CollisionComponent(
            shapes: [.generateBox(size: [5, 5, 5])],
            mode: .default,
            filter: .default
        ))
                
        box.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic))
        
        box.components.set(PhysicsMotionComponent(linearVelocity: [0,0,-50]))
        
        let lcam = AnchorEntity(world: self.cameraTransform.matrix)
        self.scene.addAnchor(lcam)
        lcam.addChild(box)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var abc: Bool
    
    class Coordinator: NSObject, ARSessionDelegate {
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            print("session")
            for anchor in anchors {
                if let anchorName = anchor.name, anchorName == "Particle" {
                    print("anchorName")
                    let box = ModelEntity(mesh: .generateBox(size: 5), materials: [gold])
                    
                    box.components.set(CollisionComponent(
                        shapes: [.generateBox(size: [5, 5, 5])],
                        mode: .default,
                        filter: .default
                    ))
                            
                    box.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic))
                    
                    box.components.set(PhysicsMotionComponent(linearVelocity: [0,0,-10]))
//                    let lcam = AnchorEntity(anchor: anchor)
//                    lcam.addChild(box)
//                    session.add(anchor: lcam)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.debugOptions = [.showPhysics]
        
        arView.session.delegate = context.coordinator
        
        arView.setupGestures()
        arView.shootBox()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
