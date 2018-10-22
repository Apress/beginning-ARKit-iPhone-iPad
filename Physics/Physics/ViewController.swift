//
//  ViewController.swift
//  Physics
//
//  Created by Wallace Wang on 8/16/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        sceneView.addGestureRecognizer(tapGesture)
    }

    @objc func tapResponse(sender: UITapGestureRecognizer) {
        let scene = sender.view as! ARSCNView
        let tapLocation = sender.location(in: scene)
        let hitTest = scene.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if hitTest.isEmpty{
            print ("no plane detected")
        } else {
            print("found a horizontal plane")
            guard let hitResult = hitTest.first else { return }
            addObject(hitResult: hitResult)
        }
    }
    
    func addObject(hitResult: ARHitTestResult) {
        let objectNode = SCNNode()
        objectNode.geometry = SCNSphere(radius: 0.1)
        objectNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        objectNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.5, hitResult.worldTransform.columns.3.z)
        objectNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        sceneView.scene.rootNode.addChildNode(objectNode)
    }

    func displayPlane(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        planeNode.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        
        let ninetyDegrees = GLKMathDegreesToRadians(90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        
        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        let planeNode = displayPlane(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = displayPlane(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
        
    }
    
}

