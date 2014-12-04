//
//  GameScene.swift
//  modelling
//
//  Created by 小渡広和 on 2014/11/26.
//  Copyright (c) 2014年 odo. All rights reserved.
//

import SpriteKit


var moving: Int = 30 //ここの60分の1をjumpとdownのdurationに代入
var jp: Int = 0
var time:Int = moving

class GameScene: SKScene {
    var player : SKSpriteNode!
    var afterpos: CGPoint!
    override func didMoveToView(view: SKView) {

        //プレイヤーとなるキャラクター画像
        self.player = SKSpriteNode(imageNamed:"bou")
        self.addChild(player)
        self.player.position = CGPointMake(300,300)
        afterpos = CGPointMake(300,600)

    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {

            if(jp == 0){
                if(time >= moving){
                    jump()
                    jp = 1
                    time = 0
                }
            }
        }
    }

    override func update(currentTime: CFTimeInterval) {
        time += 1
        if(jp == 1){
            if(time >= moving){
                down()
                jp = 0
                time = 0
            }
        }
    }

    func jump(){
        afterpos = CGPointMake(300,500)
        let travelTime = SKAction.moveTo(afterpos, duration: 0.5)
        self.player.runAction(travelTime)
    }

    func down(){
        afterpos = CGPointMake(300,300)
        let travelTime2 = SKAction.moveTo(afterpos, duration: 0.5)
        self.player.runAction(travelTime2)
    }
}
