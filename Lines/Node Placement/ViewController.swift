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
        let plane = UIBezierPath()
        plane.move(to: CGPoint(x: 0, y: 0))
        plane.addLine(to: CGPoint(x: 0.1, y: 0.1))
        plane.addLine(to: CGPoint(x: 0.1, y: -0.03))
        let customShape = SCNShape(path: plane, extrusionDepth: 0.1)
 

        let node = SCNNode()
        node.geometry = customShape
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.position = SCNVector3(Xslider.value,Yslider.value,Zslider.value)
        node.name = "shape"
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
}

