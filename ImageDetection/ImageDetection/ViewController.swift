//
//  ViewController.swift
//  ImageDetection
//
//  Created by Wallace Wang on 8/22/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate  {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    struct Images {
        var title: String
        var info: String
    }
    
    var imageArray: [Images] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        
        guard let storedImages =  ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing AR Resources images")
        }
        
        configuration.detectionImages = storedImages
        
        getData()
        
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARImageAnchor {
            print("Item recognized")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }

        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        
        let planeNode = SCNNode()
        planeNode.geometry = plane
        
        let ninetyDegrees = GLKMathDegreesToRadians(-90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        
        switch imageAnchor.referenceImage.name {
        case "CRS-15":
            let title = SCNText(string: imageArray[0].title, extrusionDepth: 0.0)
            title.flatness = 0.1
            title.font = UIFont.boldSystemFont(ofSize: 10)
            let titleNode = SCNNode()
            titleNode.geometry = title
            titleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            titleNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            titleNode.position.x = -Float(plane.width) / 2.2
            titleNode.position.y = -Float(plane.height) / 2.2
            planeNode.addChildNode(titleNode)
            
            let info = SCNText(string: imageArray[0].info, extrusionDepth: 0.0)
            info.flatness = 0.1
            info.font = UIFont.boldSystemFont(ofSize: 8)
            let infoNode = SCNNode()
            infoNode.geometry = info
            infoNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            infoNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            infoNode.position.x = -Float(plane.width) / 2.2
            infoNode.position.y = -Float(plane.height) / 1.8
            planeNode.addChildNode(infoNode)
            
        case "SaturnV":
            let title = SCNText(string: imageArray[1].title, extrusionDepth: 0.0)
            title.flatness = 0.1
            title.font = UIFont.boldSystemFont(ofSize: 10)
            let titleNode = SCNNode()
            titleNode.geometry = title
            titleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            titleNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            titleNode.position.x = -Float(plane.width) / 2.2
            titleNode.position.y = -Float(plane.height) / 2.2
            planeNode.addChildNode(titleNode)
            
            let info = SCNText(string: imageArray[1].info, extrusionDepth: 0.0)
            info.flatness = 0.1
            info.font = UIFont.boldSystemFont(ofSize: 8)
            let infoNode = SCNNode()
            infoNode.geometry = info
            infoNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            infoNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            infoNode.position.x = -Float(plane.width) / 2.2
            infoNode.position.y = -Float(plane.height) / 1.8
            planeNode.addChildNode(infoNode)
            
        default:
            print("Nothing found")
        }
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        return node
    }
    
    func getData() {
        let item1 = Images(title: "CRS-15 SpaceX rocket", info: "Commercial Resupply Service")
        let item2 = Images(title: "Saturn V rocket", info: "Apollo moon launch vehicle")
        
        imageArray.append(item1)
        imageArray.append(item2)
    }
    
}

