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
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
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
            if node.name == "sphere" {
              node.removeFromParentNode()
            }
        }
        sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    func showShape() {
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.05)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.position = SCNVector3(Xslider.value,Yslider.value,Zslider.value)
        node.name = "sphere"
        sceneView.scene.rootNode.addChildNode(node)
    }
    
}

