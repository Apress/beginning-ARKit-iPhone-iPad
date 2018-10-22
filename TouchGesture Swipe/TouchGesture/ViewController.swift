//
//  ViewController.swift
//  TouchGesture
//
//  Created by Wallace Wang on 8/2/18.
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
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRightGesture.direction = .right
        sceneView.addGestureRecognizer(swipeRightGesture)

        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeftGesture.direction = .left
        sceneView.addGestureRecognizer(swipeLeftGesture)

        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUpGesture.direction = .up
        sceneView.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDownGesture.direction = .down
        sceneView.addGestureRecognizer(swipeDownGesture)
               
        addShapes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }

    func addShapes() {
        let node = SCNNode(geometry: SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        node.position = SCNVector3(0.1,0,-0.1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.name = "box"
        sceneView.scene.rootNode.addChildNode(node)
        
        let node2 = SCNNode(geometry: SCNPyramid(width: 0.05, height: 0.06, length: 0.05))
        node2.position = SCNVector3(0.1,0.1,-0.1)
        node2.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node2.name = "pyramid"
        sceneView.scene.rootNode.addChildNode(node2)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let areaTapped = sender.view as! SCNView
        let tappedCoordinates = sender.location(in: areaTapped)
        let hitTest = areaTapped.hitTest(tappedCoordinates)
        if hitTest.isEmpty {
            print ("Nothing")
        } else {
            let results = hitTest.first!
            let name = results.node.name
            print(name ?? "background")
        }
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        let areaSwiped = sender.view as! SCNView
        let tappedCoordinates = sender.location(in: areaSwiped)
        let hitTest = areaSwiped.hitTest(tappedCoordinates)
        
        if hitTest.isEmpty {
            print ("Nothing")
        } else {
            let results = hitTest.first!
            let name = results.node.name
            print(name ?? "background")
        }
        
        switch sender.direction {
        case.up:
            print("Up")
        case .down:
            print("Down")
        case .right:
            print("Right")
        case .left:
            print("Left")
        default:
            break
        }
    }
    
}

