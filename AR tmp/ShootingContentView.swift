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
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
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
}

struct ARViewContainer: UIViewRepresentable {
    let arView = ARView(frame: .zero)
    
    class Coordinator: NSObject, ARSessionDelegate {
        let arView: ARView
        init(arView: ARView) {
            self.arView = arView
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            print("session")
            for anchor in anchors {
                if let anchorName = anchor.name, anchorName == "Particle" {
                    print("anchorName: \(anchorName)")
                    let box = ModelEntity(mesh: .generateBox(size: 5), materials: [gold])
                    box.components.set(CollisionComponent(
                                        shapes: [.generateBox(size: [5,5,5])],
                                        mode: .default,
                                        filter: .default
                    ))
                    

                    let e = simd_quatf(anchor.transform)
                    let x: Float = e.imag.x
                    let y: Float = e.imag.y
                    let z: Float = e.imag.z
                    print("x: \(x) y: \(y) z: \(z)")
                    var nz: Float = y
                    if nz > 0.5 {
                        nz = 2 * (y - 0.5)
                    } else if nz > 0 {
                        nz = 2 * (y - 0.5)
                    } else if nz < -0.5 {
                        nz = -2 * (y + 0.5)
                    } else if nz < 0 {
                        nz = -2 * (y + 0.5)
                    }

                    var nx: Float = 0
                    if y > 0 {
                        nx = (1 - abs(nz)) * -1
                    } else {
                        nx = 1 - abs(nz)
                    }
                    print("nx: \(nx)")
                    print("nz: \(nz)")
                    let velX = nx * 50
                    let velZ = nz * 50
                    print("velX: \(velX)")
                    print("velZ: \(velZ)")
                    
                    box.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic))
                    box.components.set(PhysicsMotionComponent(linearVelocity: [velX, 0, velZ]))
                    
                    let anchorEntity = AnchorEntity(anchor: anchor)
                    anchorEntity.addChild(box)
                    arView.scene.addAnchor(anchorEntity)
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arView: arView)
    }
    
    func makeUIView(context: Context) -> ARView {
        arView.debugOptions = [.showPhysics]
        
        arView.session.delegate = context.coordinator
        arView.setupGestures()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
