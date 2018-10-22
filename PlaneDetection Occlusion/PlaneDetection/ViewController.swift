//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Wallace Wang on 8/10/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    var x : Float = 0
    var y : Float = 0
    var z : Float = 0
    
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
        let boxNode = SCNNode()
        boxNode.geometry = SCNBox(width: 0.08, height: 0.08, length: 0.08, chamferRadius: 0)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        boxNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    func displayTexture(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        planeNode.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode.geometry?.firstMaterial?.colorBufferWriteMask = []
        planeNode.renderingOrder = -1
        planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        
        x = anchor.center.x
        y = anchor.center.y - 0.4
        z = anchor.center.z
        
        let ninetyDegrees = GLKMathDegreesToRadians(90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        
        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        let planeNode = displayTexture(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = displayTexture(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
        
        print("updating plane anchor")
    }
    
}

