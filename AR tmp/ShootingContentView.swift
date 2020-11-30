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
        
        let box = ModelEntity(mesh: .generateSphere(radius: 5), materials: [gold])
        box.components.set(CollisionComponent(
                            shapes: [.generateBox(size: [5,5,5])],
                            mode: .default,
                            filter: .default
        ))
        

        let e = self.cameraTransform.rotation
        print("normalized: \(e.normalized)")
        print("vector: \(e.vector)")
        let y: Float = 2 * (asin(e.imag.y  * (e.real < 0 ? -1 : 1)) * 180.0 / Float.pi)
        print("y: \(y)")
        var nx: Float = y/90
        var nz: Float = 1 - (y/90)
        
        if y < -90 {
            // 2
            nx = (nx/2+1)*2
            nz = nz - 2
        } else if y < 0 {
            // 1
            nx = abs(nx)
            nz = (2/nz - 1) * (-1)
        } else if y > 90 {
            // 3
            nx = (2/nx - 1) * (-1)
            nz = abs(nz)
        } else if y > 0 {
            // 4
            nx = nx * (-1)
            nz = nz * (-1)
        }
        
        print("nx: \(nx)")
        print("nz: \(nz)")
        let velX = nx * 50
        let velZ = nz * 50
        print("velX: \(velX)")
        print("velZ: \(velZ)")
        print()
        
        box.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic))
        box.components.set(PhysicsMotionComponent(linearVelocity: [velX, 0, velZ]))
//        box.components.set(PhysicsMotionComponent(linearVelocity: [50, 0, 0]))
        
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(box)
        self.scene.addAnchor(anchorEntity)
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
