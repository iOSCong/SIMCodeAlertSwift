//
//  ViewController.swift
//  SIMCodeAlertSwift
//
//  Created by MCEJ on 2017/10/31.
//  Copyright © 2017年 MCEJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let simLabel = UILabel.init(frame: CGRect(x:0,y:200,width:self.view.bounds.size.width,height:50))
        simLabel.text = "点击输入验证码"
        simLabel.textAlignment = .center
        simLabel.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(simLabel)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let simAlert = MZSimView.init(frame: UIScreen.main.bounds)
        simAlert.moneyInfor = "¥ 100.42"
        simAlert.show()
        simAlert.completeHandle = {(complete) -> Void in
            //确认
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

