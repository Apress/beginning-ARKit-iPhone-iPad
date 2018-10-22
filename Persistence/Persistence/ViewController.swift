//
//  ViewController.swift
//  Persistence
//
//  Created by Wallace Wang on 9/7/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate , ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var lblMessage: UILabel!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        sceneView.session.delegate = self
        configuration.planeDetection = .horizontal
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGesture)
        
        self.lblMessage.text = "Tap to place a virtual object"
        sceneView.session.run(configuration)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {
            return
        }
        
        let touch = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touch, types: [.featurePoint, .estimatedHorizontalPlane])
        if hitTestResults.isEmpty == false {
            if let hitTestResult = hitTestResults.first {
                let virtualAnchor = ARAnchor(transform: hitTestResult.worldTransform)
                self.sceneView.session.add(anchor: virtualAnchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            return
        }
        
        let newNode = SCNNode(geometry: SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0))
        newNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.addChildNode(newNode)
    }
    
    func saveMap() {
        self.sceneView.session.getCurrentWorldMap { worldMap, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let map = worldMap {
                
                let data = try! NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                
                // save in user defaults
                let savedMap = UserDefaults.standard
                savedMap.set(data, forKey: "worldmap")
                savedMap.synchronize()
                DispatchQueue.main.async {
                    self.lblMessage.text = "World map saved"
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    func loadMap() {
        let storedData = UserDefaults.standard
        if let data = storedData.data(forKey: "worldmap") {
            if let unarchived = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [ARWorldMap.classForKeyedUnarchiver()], from: data), let worldMap = unarchived as? ARWorldMap {
                let configuration = ARWorldTrackingConfiguration()
                configuration.initialWorldMap = worldMap
                configuration.planeDetection = .horizontal
                self.lblMessage.text = "Previous world map loaded"
                sceneView.session.run(configuration)
            }
        } else {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
        }
    }
    
    @IBAction func saveButton(_ sender: UIButton) {       
        saveMap()
    }
    
    func clearMap() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        self.lblMessage.text = "Tap to place a virtual object"
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        clearMap()
    }
    
    @IBAction func loadButton(_ sender: UIButton) {
        loadMap()
    }
}

