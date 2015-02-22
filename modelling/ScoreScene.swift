//
//  ScoreScene.swift
//  modelling
//
//  Created by 小渡広和 on 2015/02/22.
//  Copyright (c) 2015年 odo. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class ScoreScene: SKScene {

    var delegate_escape: SceneEscapeProtocol?
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func didMoveToView(view: SKView) {
        let backGround = SKSpriteNode(imageNamed:"Result.png")
        backGround.size = frame.size
        self.addChild(backGround)
        backGround.position = CGPointMake(500,300)
        println(appDelegate.data)
    }
}