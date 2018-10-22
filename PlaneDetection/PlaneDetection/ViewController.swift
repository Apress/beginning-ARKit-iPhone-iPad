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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }

    func displayTexture(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        planeNode.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "water.jpg")
        planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        
        let ninetyDegrees = GLKMathDegreesToRadians(90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        
        return planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        let planeNode = displayTexture(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
        print ("plane detected")
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

