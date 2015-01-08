//
//  GameScene.swift
//  modelling
//
//  Created by 小渡広和 on 2014/11/26.
//  Copyright (c) 2014年 odo. All rights reserved.
//

import SpriteKit

/*
var moving: Int = 30 //ここの60分の1をjumpとdownのdurationに代入
var jp: Int = 0
var time:Int = moving*/

class GameScene: SKScene, SKPhysicsContactDelegate {
    //Takamiyagi Wall Move 変数? 指定
    var Wall1 : SKSpriteNode!
    var Wall2 : SKSpriteNode!
    var movepos1: CGPoint!
    var movepos2: CGPoint!
    
    
    var player : SKSpriteNode!
//    var afterpos: CGPoint!
    var moving:SKNode!
    var jumpNow: CGPoint!
    var canRestart = Bool()

    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1

    var check = 1

    override func didMoveToView(view: SKView) {
        canRestart = false
        moving = SKNode()
        self.addChild(moving)

        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0, -9.8 )
        self.physicsWorld.contactDelegate = self


        // setup our player
        let playerTexture1 = SKTexture(imageNamed: "sima1")
        playerTexture1.filteringMode = .Nearest
        let playerTexture2 = SKTexture(imageNamed: "sima2")
        playerTexture2.filteringMode = .Nearest

        let anim = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
        let flap = SKAction.repeatActionForever(anim)

        player = SKSpriteNode(texture: playerTexture1)
        player.setScale(0.2)
        player.position = CGPoint(x: self.frame.size.width * 0.20, y:self.frame.size.height * 0.40)
        jumpNow = player.position
        player.runAction(flap)

        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2.0)
        player.physicsBody?.dynamic = false
        player.physicsBody?.allowsRotation = false

        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = worldCategory
        player.physicsBody?.contactTestBitMask = worldCategory

        self.addChild(player)
        
        
        //Takamiyagi Wall(障害物)の設定
        let WallTexture1 = SKTexture(imageNamed: "Object")                                          //使用する画像
        Wall1 = SKSpriteNode(texture: WallTexture1)
        Wall1.setScale(0.4)                                                                         //使用する画像の大きさ（元の画像の大きさの割合）
        Wall1.position = CGPoint(x: self.frame.size.width * 1.20, y:self.frame.size.height * 0.40)  //使用する画像の初期位置
        self.addChild(Wall1)
        
        let WallTexture2 = SKTexture(imageNamed: "Object")
        Wall2 = SKSpriteNode(texture: WallTexture2)
        Wall2.setScale(0.4)
        Wall2.position = CGPoint(x: self.frame.size.width * 1.20, y:self.frame.size.height * 0.40)
        self.addChild(Wall2)
        
        
    

        //プレイヤーとなるキャラクター画像
//        self.player = SKSpriteNode(imageNamed:"bou")
//        self.addChild(player)
//        self.player.position = CGPointMake(300,300)
//        player.size = CGSizeMake(40, 40)
//        afterpos = CGPointmake(300,600)
//      player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
//      player.physicsBody?.dynamic = false
//      physicsWorld.gravity = CGVectorMake(0,-0.5)


    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (moving.speed > 0)  {
//        player.position.x == jumpNow.x + 1
            if(check == 1){
            for touch: AnyObject in touches {
                player.physicsBody?.dynamic = true
                let location = touch.locationInNode(self)

                player.physicsBody?.velocity = CGVectorMake(0, 550)
                player.physicsBody?.applyImpulse(CGVectorMake(0, 0))

                let playerTexture1 = SKTexture(imageNamed: "sima1")
                playerTexture1.filteringMode = .Nearest
                let playerTexture2 = SKTexture(imageNamed: "sima1")
                playerTexture2.filteringMode = .Nearest

                let stop = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
                let dlap = SKAction.repeatActionForever(stop)
                player.runAction(dlap)

                check = 0
            }
        }else if canRestart {
           self.resetScene()
        }
        }

/*        for touch: AnyObject in touches {


            if(jp == 0){
                if(time >= moving){
                    jump()
                    jp = 1
                    time = 0
                }
            }
        }*/
}


        func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
            if( value > max ) {
                return max
            } else if( value < min ) {
                return min
            } else {
                return value
            }
        }

     override func update(currentTime: CFTimeInterval) {
        
        //　Takamiyagi
        if(Wall1.position.x >= self.frame.size.width * 0.0){
            movepos1 = CGPoint(x: self.frame.size.width * -1.0, y:self.frame.size.height * 0.40)
            let travelTime = SKAction.moveTo(movepos1, duration: 2.0)
            self.Wall1.runAction(travelTime)
        }
        else{
            Wall1.position = CGPoint(x: self.frame.size.width * 1.20, y:self.frame.size.height * 0.40)
        }
        
        
        if(Wall2.position.x >= self.frame.size.width * 0.1){
            movepos2 = CGPoint(x: self.frame.size.width * -1.0, y:self.frame.size.height * 0.40)
            let travelTime = SKAction.moveTo(movepos2, duration: 2.0)
            self.Wall2.runAction(travelTime)
        }
        else{
            Wall2.position = CGPoint(x: self.frame.size.width * 1.20, y:self.frame.size.height * 0.40)
        }
        
        
        
/*        time += 1
        if(jp == 1){
            if(time >= moving){
                down()
                jp = 0
                time = 0
            }
        }*/

        /* Called before each frame is rendered */
        /*
        player.zRotation = clamp( -1, max: 0.5, value: player.physicsBody!.velocity.dy * ( player.physicsBody!.velocity.dy < 0 ? 0.00 : 0.00 ) )
        */

   /*     if(player.position.x < jumpNow.x){
            player.physicsBody?.dynamic = false
        }*/
        if(player.position.y < jumpNow.y){
            player.physicsBody?.dynamic = false
            self.resetScene()
        }
        
    }

    func jump(){
/*        afterpos = CGPointMake(300,500)
        let travelTime = SKAction.moveTo(afterpos, duration: 0.5)
        self.player.runAction(travelTime)
         player.physicsBody?.dynamic = false*/
    }

    func down(){
/*        afterpos = CGPointMake(300,300)
        let travelTime2 = SKAction.moveTo(afterpos, duration: 0.5)
        self.player.runAction(travelTime2)*/
    }


    func resetScene (){
        // Move player to original position and reset velocity
        player.position.y = jumpNow.y
        player.physicsBody?.velocity = CGVectorMake( 0, 0 )
        player.physicsBody?.collisionBitMask = worldCategory
        player.speed = 1.0
        player.zRotation = 0.0

        // Reset _canRestart
        canRestart = false

        // Restart animation
        moving.speed = 1

        let playerTexture1 = SKTexture(imageNamed: "sima1")
        playerTexture1.filteringMode = .Nearest
        let playerTexture2 = SKTexture(imageNamed: "sima2")
        playerTexture2.filteringMode = .Nearest

        let anim = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
        let flap = SKAction.repeatActionForever(anim)
        player.runAction(flap)

        check = 1
    }
}

/*
//
//  GameScene.swift
//  atari
//
//  Created by Arakaki Daichi on 2014/12/04.
//  Copyright (c) 2014年 Arakaki Daichi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

// カテゴリを用意しておく。
let redCategory: UInt32 = 0x1 << 0    //赤のブロックのカテゴリー（障害物に）
let greenCategory: UInt32 = 0x1 << 1  //緑のブロックのカテゴリー（主人公に）

var gameover : SKSpriteNode!
var Hero : SKSpriteNode!
var butu : SKSpriteNode!






override func didMoveToView(view: SKView) {

// デリゲートをselfにしておく。
self.physicsWorld.contactDelegate = self

self.size = view.bounds.size
self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
self.physicsWorld.gravity = CGVectorMake(0.0, -3.0)


self.gameover = SKSpriteNode(imageNamed: "AA.jpg")
self.addChild(gameover)
self.gameover.position = CGPointMake(3333333,2222222)

self.Hero = SKSpriteNode(imageNamed: "a.png")
self.addChild(Hero)
self.Hero.position = CGPointMake(3333333,2222222)

self.butu = SKSpriteNode(imageNamed: "b.png")
self.addChild(butu)
self.butu.position = CGPointMake(3333333,2222222)


// 赤い正方形を真ん中に固定しておく。ここを障害物に書き換える







let redSquare = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(50, 50)) //赤い四角

redSquare.position = CGPoint(
x: CGRectGetMidX(self.frame),
y: CGRectGetMidY(self.frame)
)

redSquare.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 50)) //当たり判定


redSquare.physicsBody?.affectedByGravity = false
redSquare.physicsBody?.dynamic = false


// カテゴリを設定する。
redSquare.physicsBody?.categoryBitMask = redCategory
redSquare.physicsBody?.contactTestBitMask = greenCategory

self.addChild(redSquare)
}

override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {



// タップする度に、その位置にグリーンの長方形を出す。ここをキャラクターに書き換える
for touch in touches {

let location = touch.locationInNode(self)
let greenRectangle = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(50, 100))//青い四角

greenRectangle.position = location
greenRectangle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 100))//当たり判定


// カテゴリを設定する。
greenRectangle.physicsBody?.categoryBitMask = greenCategory
greenRectangle.physicsBody?.contactTestBitMask = redCategory

self.addChild(greenRectangle)
}

}

override func update(currentTime: CFTimeInterval) {
}






// 衝突したとき。ここをいろいろ表示出来るようにする
func didBeginContact(contact: SKPhysicsContact!) {

var firstBody, secondBody: SKPhysicsBody

// firstを赤、secondを緑とする。
if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
firstBody = contact.bodyA
secondBody = contact.bodyB
} else {
firstBody = contact.bodyB
secondBody = contact.bodyA
}

// 赤と緑が接したときの処理。ここをキャラクターと障害物の接触したときのアクションにする
if firstBody.categoryBitMask & redCategory != 0 &&
secondBody.categoryBitMask & greenCategory != 0 {


self.gameover.position.x = 250
self.gameover.position.y = 300;//ここを書き換える

}
}
}







*/
