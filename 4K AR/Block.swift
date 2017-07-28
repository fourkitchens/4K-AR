//
//  Box.swift
//  4K AR
//
//  Created by Flip on 7/19/17.
//  Copyright © 2017 Flip. All rights reserved.
//

import ARKit
import Foundation

class Block: SCNNode {
    
    // Block dimensions
    struct Dimensions {
        static let width = CGFloat(0.05)
        static let height = CGFloat(0.05)
        static let length = CGFloat(0.05)
        static let chamferRadius = CGFloat(0.05) / 25
    }
    
    // Block faces
    static let Faces: [Int: Array<UIImage>] = [
        0: [UIImage(named: "cube-0-0")!, UIImage(named: "cube-0-1")!, UIImage(named: "cube-0-2")!],
        1: [UIImage(named: "cube-1-0")!, UIImage(named: "cube-1-1")!, UIImage(named: "cube-1-2")!],
        2: [UIImage(named: "cube-2-0")!, UIImage(named: "cube-2-1")!, UIImage(named: "cube-2-2")!],
        3: [UIImage(named: "cube-3-0")!, UIImage(named: "cube-3-0")!, UIImage(named: "cube-3-0")!],
    ]
    
    init(type: Int, position: SCNVector3) {
        super.init()
        
        // Create the block
        let node = SCNNode(geometry: SCNBox(width: Dimensions.width, height: Dimensions.height, length: Dimensions.length, chamferRadius: Dimensions.chamferRadius))
        node.position = position
        
        // Decorate the block
        let firstMaterial = SCNMaterial();
        firstMaterial.diffuse.contents = Block.Faces[type]![0];
        let secondMaterial = SCNMaterial();
        secondMaterial.diffuse.contents = Block.Faces[type]![1];
        let thirdMaterial = SCNMaterial();
        thirdMaterial.diffuse.contents = Block.Faces[type]![2];
        let fourthMaterial = SCNMaterial();
        fourthMaterial.diffuse.contents = Block.Faces[type]![0];
        let fifthMaterial = SCNMaterial();
        fifthMaterial.diffuse.contents = Block.Faces[type]![1];
        let sixthMaterial = SCNMaterial();
        sixthMaterial.diffuse.contents = Block.Faces[type]![2];
        node.geometry!.materials = [firstMaterial, secondMaterial, thirdMaterial, fourthMaterial, fifthMaterial, sixthMaterial]
        
        // Do physics to the block
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: node.geometry!, options: nil))
        node.physicsBody!.friction = 1.0
        
        addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


