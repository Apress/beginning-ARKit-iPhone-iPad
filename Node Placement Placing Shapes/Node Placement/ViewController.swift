//
//  ViewController.swift
//  Node Placement
//
//  Created by Wallace Wang on 7/5/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var Xslider: UISlider!
    @IBOutlet var Yslider: UISlider!
    @IBOutlet var Zslider: UISlider!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(configuration)
    }

    @IBAction func addButton(_ sender: UIButton) {
        showShape()
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        sceneView.session.pause()

        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "shape" {
              node.removeFromParentNode()
            }
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func showShape() {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.05)
//         node.geometry = SCNBox(width: 0.1, height: 0.2, length: 0.1, chamferRadius: 0.05)
//         node.geometry = SCNTorus(ringRadius: 0.2, pipeRadius: 0.05)
//         node.geometry = SCNTube(innerRadius: 0.08, outerRadius: 0.1, height: 0.2)
//         node.geometry = SCNCapsule(capRadius: 0.06, height: 0.4)
//         node.geometry = SCNCylinder(radius: 0.04, height: 0.3)
//         node.geometry = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.2)
//         node.geometry = SCNPyramid(width: 0.2, height: 0.4, length: 0.2)
//         node.geometry = SCNPlane(width: 0.2, height: 0.3)
       
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        node.position = SCNVector3(Xslider.value,Yslider.value,Zslider.value)
        node.name = "shape"
        sceneView.scene.rootNode.addChildNode(node)
    }
    
}

