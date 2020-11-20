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

let gold = SimpleMaterial(color: .yellow, isMetallic: true)

extension ARView {
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("tap")
        self.shootBox()
//        if let anchor = self.scene.anchors.first, let child = anchor.children.first {
//            print("child: \(child)")
//            let entity = child as! (Entity & HasPhysics)
//            entity.addForce([100,100,100], relativeTo: anchor)
//        }
    }
    
    func shootBox() {
        let cameraTransform = self.cameraTransform
        let box = ModelEntity(mesh: .generateBox(size: 5), materials: [gold])
        
        box.components.set(CollisionComponent(
            shapes: [.generateBox(size: [5, 5, 5])],
            mode: .default,
            filter: .default
        ))
                
        box.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .dynamic))
        
        let x: Float = cameraTransform.rotation.imag.x
        let y: Float = cameraTransform.rotation.imag.y
        let z: Float = cameraTransform.rotation.imag.z
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
        
//        box.components.set(PhysicsMotionComponent(linearVelocity: [velX,0,velZ]))
        box.components.set(PhysicsMotionComponent(linearVelocity: [0,0,-10]))
        
        let lcam = AnchorEntity(world: self.cameraTransform.matrix)
//        let lcam = AnchorEntity(transform: self.cameraTransform.matrix)
        self.scene.addAnchor(lcam)
        lcam.addChild(box)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var abc: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.debugOptions = [.showPhysics]
        
        arView.setupGestures()
        arView.shootBox()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
