//
//  ViewController.swift
//  PhysicsForce
//
//  Created by Wallace Wang on 8/17/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate  {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    enum contactType : Int {
        case projectile = 1
        case target = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self

        sceneView.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        sceneView.addGestureRecognizer(tapGesture)
        
        addTargets()
    }

    @objc func tapResponse(sender: UITapGestureRecognizer) {
        guard let scene = sender.view as? ARSCNView else { return }
        guard let pov = scene.pointOfView else { return }
        let transform = pov.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let position = SCNVector3(orientation.x + location.x, orientation.y + location.y, orientation.z + location.z)
        let projectile = SCNNode()
        projectile.geometry = SCNSphere(radius: 0.35)
        projectile.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        projectile.position = position
        projectile.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: projectile, options: nil))
        projectile.physicsBody?.isAffectedByGravity = false
        projectile.physicsBody?.categoryBitMask = contactType.projectile.rawValue
        projectile.physicsBody?.contactTestBitMask = contactType.target.rawValue
        projectile.name = "Projectile"
        let force: Float = 50
        projectile.physicsBody?.applyForce(SCNVector3(orientation.x * force, orientation.y * force, orientation.z * force), asImpulse: true)
        sceneView.scene.rootNode.addChildNode(projectile)
    }
    
    func addTargets() {
        let pyramidNode = SCNNode()
        pyramidNode.geometry = SCNPyramid(width: 4, height: 4.5, length: 4)
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        pyramidNode.position = SCNVector3(-3, 1, -15)
        pyramidNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        pyramidNode.physicsBody?.categoryBitMask = contactType.target.rawValue
        pyramidNode.name = "Pyramid"
        sceneView.scene.rootNode.addChildNode(pyramidNode)
        
        let torusNode = SCNNode()
        torusNode.geometry = SCNTorus(ringRadius: 2, pipeRadius: 0.5)
        torusNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        torusNode.position = SCNVector3(0, -2, -15)
        torusNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: torusNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
        torusNode.physicsBody?.categoryBitMask = contactType.target.rawValue
        torusNode.name = "Torus"
        
        let ninetyDegrees = GLKMathDegreesToRadians(90)
        torusNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        
        sceneView.scene.rootNode.addChildNode(torusNode)

        let boxNode = SCNNode()
        boxNode.geometry = SCNBox(width: 3.5, height: 3.5, length: 3.5, chamferRadius: 0)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        boxNode.position = SCNVector3(5, 1, -15)
        boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        boxNode.physicsBody?.categoryBitMask = contactType.target.rawValue
        boxNode.name = "Box"
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var targetNode : SCNNode!
        
        if contact.nodeA.name == "Projectile" {
            targetNode = contact.nodeB
        } else {
            targetNode = contact.nodeA
        }
        
        switch targetNode.name {
        case "Pyramid":
            targetNode.geometry?.firstMaterial?.diffuse.contents = UIColor.magenta
        case "Torus":
            targetNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        case "Box":
            targetNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        default:
            return
        }
    }
}

