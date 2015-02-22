//
//  TitleScene.swift
//  modelling
//
//  Created by 小渡広和 on 2015/02/22.
//  Copyright (c) 2015年 odo. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class TitleScene: SKScene {

    var delegate_escape: SceneEscapeProtocol?

    var Start : SKSpriteNode!
    let startTexture = SKTexture(imageNamed: "start")

    let image = UIImage(named: "Start_Button.png") as UIImage!

    var skView: SKView?
    let startButton = UIButton()

    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()

        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)


        let backGround = SKSpriteNode(imageNamed:"Start.png")
        backGround.size = frame.size
        self.addChild(backGround)
        backGround.position = CGPointMake(500,300)

/*        // タイトルを表示。
        let Title = SKLabelNode(fontNamed:"Chalkduster")
        Title.text = "modeling H";
        Title.fontSize = 48;
        Title.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.25);
        Title.color = UIColor.blackColor()
        self.addChild(Title)

        Start = SKSpriteNode(texture: startTexture)
        Start.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/1.75);
        Start.name = "startButton"
        //        self.addChild(Start)
*/

        startButton.frame = CGRectMake(0,0,50,50)
        startButton.layer.masksToBounds = true
        startButton.tag = 4
        startButton.layer.cornerRadius = 20.0
        startButton.layer.position = CGPoint(x: self.view!.frame.width/4, y:self.view!.frame.height/1.8)
        startButton.setImage(image, forState: .Normal)
        startButton.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
        self.view!.addSubview(startButton);
    }

    func clickButton(sender: UIButton) {
        println("hoge")
        delegate_escape!.sceneEscape(self)
        startButton.hidden = !startButton.hidden
    }
    
    override func update(currentTime: CFTimeInterval) {}
    
}