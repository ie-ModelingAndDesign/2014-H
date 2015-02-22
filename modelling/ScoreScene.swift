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

    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    override func didMoveToView(view: SKView) {
        let backGround = SKSpriteNode(imageNamed:"Result.png")
        backGround.size = frame.size
        self.addChild(backGround)
        backGround.position = CGPointMake(500,300)
        println("スコアは\(appDelegate.data)")

        myLabel.text = "\(appDelegate.data*10)"
        myLabel.fontSize = 200
        myLabel.fontColor = UIColor.blackColor()
        myLabel.position = CGPoint(x:self.frame.width*5/6, y:self.frame.height/4);
        self.addChild(myLabel)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        delegate_escape!.sceneEscape(self)
        myLabel.hidden = !myLabel.hidden
    }
}