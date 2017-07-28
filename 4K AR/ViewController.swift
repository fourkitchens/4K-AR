//
//  ViewController.swift
//  4K AR
//
//  Created by Flip on 7/19/17.
//  Copyright © 2017 Flip. All rights reserved.
//

import ARKit
import UIKit
import SceneKit
import Foundation

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // Keep track of the planes
    var planes: [UUID:Plane] = [:]
    
    // Keep track of which type of block is selected
    var selectedBlockType: Int = 0
    
    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Add planes
    internal func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            planes[planeAnchor.identifier] = Plane(with: planeAnchor)
            node.addChildNode(planes[planeAnchor.identifier]!)
        }
    }
    
    // Update planes
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        planes[anchor.identifier]!.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    // Remove planes
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        planes.removeValue(forKey: anchor.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the scene
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = SCNScene()
        
        // Add physics
        sceneView.scene.physicsWorld.gravity = SCNVector3Make(0.0, -1.225, 0.0)
        sceneView.scene.physicsWorld.speed = 0.5
        sceneView.scene.physicsWorld.contactDelegate = self

        // Attach tap recognition
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))

        // Add toolbar
        let toolbar = Toolbar(viewWidth: view.frame.width, viewHeight: view.frame.height)
        toolbar.blockTypeSelector.addTarget(self, action: #selector(selectBlockType(_:)), for: .valueChanged)
        view.addSubview(toolbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Detect planes
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show welcome prompt
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let messageText = NSMutableAttributedString(
            string: "\n🤳 Move around and you'll see planes indicated by translucent platforms\n\n👉 Tap the platforms to drop blocks onto them!\n",
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: .callout),
                NSAttributedStringKey.foregroundColor : UIColor.black
            ]
        )
        
        let alert = UIAlertController(title: "Four Kitchens + ARKit", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Neato! 👌", style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    
    // Set selected block type
    @objc
    func selectBlockType(_ sender: UISegmentedControl) {
        selectedBlockType = sender.selectedSegmentIndex
    }
    
    // Add a block to the world
    func addBlock(_ coordinates: SCNVector3) {
        if (selectedBlockType == 3) {
            // Sometimes you want just want to be extra... Todd
            for i in 0...2 {
                for j in 0...2 {
                    for k in 0...2 {
                        sceneView.scene.rootNode.addChildNode(Block(type: selectedBlockType, position: SCNVector3(x: coordinates.x + Float(j) * 0.05, y: coordinates.y + 0.02 + Float(i) * 0.05, z: coordinates.z + Float(k) * 0.05)))
                    }
                }
            }
        } else {
            // Add one block
            sceneView.scene.rootNode.addChildNode(Block(type: selectedBlockType, position: SCNVector3(x: coordinates.x, y: coordinates.y + 0.125, z: coordinates.z)))
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let location = gestureRecognize.location(in: view)
        if location.y > view.frame.height - 50 {
            return
        }
        if let result = sceneView.hitTest(location, options: [:]).first {
            addBlock(result.worldCoordinates)
        }
    }
    
}

