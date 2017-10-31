//
//  MZSimView.swift
//  learnSwift
//
//  Created by MCEJ on 2017/10/6.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let TITLE_HEIGHT = CGFloat(46.0)
let PAYMENT_WIDTH = CGFloat(290.0)
let PWD_COUNT = 6
let DOT_WIDTH = CGFloat(40.0)
let KEYBOARD_HEIGHT = CGFloat(216.0)
let KEY_VIEW_DISTANCE = CGFloat(35.0)
let ALERT_HEIGHT = CGFloat(290.0)
let LABEL_HEIGHT = CGFloat(30.0)

class MZSimView: UIView,UITextFieldDelegate {
    
    var moneyInfor : String?
    var totalString : String?
    
    typealias complete = (String) ->()
    var completeHandle : complete?
    
    var paymentAlert : UIView?
    var titleLabel : UILabel?
    var closeBtn : UIButton?
    var moneyLabel:UILabel?
    var inputsView : UIView?
    var pwdIndicatorArr:NSMutableArray?
    var pwdTextField:UITextField?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.frame = UIScreen.main.bounds
        self.frame = frame
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        drawView()
    }
    
    //重写 swift规定不可以缺少这个request init方法：（编译器会自动提示）
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawView() {
        if paymentAlert == nil {
            paymentAlert = UIView(frame:CGRect(x:(kScreenWidth-PAYMENT_WIDTH)/2,y:(kScreenHeight-KEYBOARD_HEIGHT)/2-ALERT_HEIGHT/2,width:PAYMENT_WIDTH,height:ALERT_HEIGHT))
            paymentAlert?.layer.cornerRadius = 5.0
            paymentAlert?.layer.masksToBounds = true
            paymentAlert?.backgroundColor = UIColor.init(white: 1.0, alpha: 0.95)
            self.addSubview(paymentAlert!)
            
            titleLabel = UILabel(frame:CGRect(x:0,y:0,width:PAYMENT_WIDTH,height:TITLE_HEIGHT))
            titleLabel?.textAlignment = .center
            titleLabel?.font = UIFont.systemFont(ofSize: 17)
            titleLabel?.text = "请输入短信验证码"
            paymentAlert?.addSubview(titleLabel!)
            
            closeBtn = UIButton.init(type: .custom)
            closeBtn?.frame = CGRect(x:(paymentAlert?.frame.size.width)!-TITLE_HEIGHT,y:0,width:TITLE_HEIGHT,height:TITLE_HEIGHT)
            closeBtn?.setTitle("╳", for: .normal)
            closeBtn?.setTitleColor(UIColor.darkGray, for: .normal)
            closeBtn?.addTarget(self, action: #selector(didmiss), for: .touchUpInside)
            paymentAlert?.addSubview(closeBtn!)
            
            let line = UILabel(frame:CGRect(x:0,y:TITLE_HEIGHT,width:PAYMENT_WIDTH,height:0.5))
            line.backgroundColor = UIColor.lightGray
            paymentAlert?.addSubview(line)
            
            moneyLabel = UILabel(frame:CGRect(x:15,y:TITLE_HEIGHT+LABEL_HEIGHT,width:PAYMENT_WIDTH-30,height:LABEL_HEIGHT))
            moneyLabel?.textAlignment = .center
            moneyLabel?.font = UIFont.systemFont(ofSize: 30)
            paymentAlert?.addSubview(moneyLabel!)
            
            inputsView = UIView(frame:CGRect(x:15,y:(paymentAlert?.frame.size.height)!-(PAYMENT_WIDTH-30)/6-110,width:PAYMENT_WIDTH-30,height:(PAYMENT_WIDTH-30)/6))
            inputsView?.backgroundColor = UIColor.white
            inputsView?.layer.cornerRadius = 3
            inputsView?.layer.borderWidth = 1
            inputsView?.layer.borderColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
            paymentAlert?.addSubview(inputsView!)
            
            pwdIndicatorArr = NSMutableArray()
            pwdTextField = UITextField(frame:CGRect(x:0,y:0,width:self.frame.size.width,height:self.frame.size.height))
            pwdTextField?.isHidden = true
            pwdTextField?.delegate = self
            pwdTextField?.keyboardType = .numberPad
//            pwdTextField?.addTarget(self, action: #selector(pwdTextFieldHandle), for: .valueChanged)
            inputsView?.addSubview(pwdTextField!)
            
            let width = (inputsView?.bounds.size.width)!/CGFloat(PWD_COUNT)
            for i in 0..<PWD_COUNT {
                let dot:UILabel = UILabel(frame:CGRect(x:(width-DOT_WIDTH)/2+CGFloat(i)*width,y:((inputsView?.bounds.size.height)!-DOT_WIDTH)/2,width:DOT_WIDTH,height:DOT_WIDTH))
                dot.textAlignment = .center
                dot.font = UIFont.systemFont(ofSize: 38)
                dot.tag = 1000+i
                dot.isHidden = true
                inputsView?.addSubview(dot)
                pwdIndicatorArr?.add(dot)
                
                if i == PWD_COUNT-1 {
                    continue
                }
                let line = UILabel(frame:CGRect(x:CGFloat(i+1)*width,y:0,width:0.5,height:(inputsView?.bounds.size.height)!))
                line.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                inputsView?.addSubview(line)
            }
            let sureBtn = UIButton.init(type: .custom)
            sureBtn.frame = CGRect(x:15,y:235,width:(inputsView?.frame.size.width)!,height:40)
            sureBtn.backgroundColor = UIColor.orange
            sureBtn.setTitle("确认", for: .normal)
            sureBtn.addTarget(self, action: #selector(sureBtnHandle), for: .touchUpInside)
            sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            sureBtn.layer.cornerRadius = 5
            paymentAlert?.addSubview(sureBtn)
        }
    }
    
    //弹出视图
    func show() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        
        moneyLabel?.text = self.moneyInfor
        
        paymentAlert?.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
        paymentAlert?.alpha = 0
        
        UIView.animate(withDuration: 0.7, animations: {
            self.pwdTextField?.becomeFirstResponder()
            self.paymentAlert?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.paymentAlert?.alpha = 1
        })
    }
    
    //隐藏弹出视图
    @objc func didmiss() {
        pwdTextField?.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.paymentAlert?.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
            self.paymentAlert?.alpha = 0
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    //确认
    @objc func sureBtnHandle() {
        print("确认")
        didmiss()
        
        if self.totalString == nil {
            
            let alert = UIAlertView.init(title: "提示", message: "请输入验证码", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        }else{
            
            //block 传值
            completeHandle!(self.totalString!)
        }
    }
    
    func pwdTextFieldHandle() {
        let textLength = (pwdTextField!.text! as NSString).length
        if textLength > PWD_COUNT {
            return
        }
//        self.totalString = (pwdTextField?.text as! String)
        self.totalString = pwdTextField?.text
        DotWithCount(textLength: textLength)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
//        let textLength = textField.text?.lengthOfBytes(using: .utf8)
//        let textLength = textField.text?.characters.count
//        let textLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        
        let textStr = textField.text! + string
        
        var totalStr:String?
        if string.characters.count <= 0 {
            totalStr = (textStr as NSString).substring(to: (textStr as NSString).length-1)
        }else{
            totalStr = textStr
        }
        
        let textLength = (totalStr! as NSString).length
        if textLength > PWD_COUNT {
            return false
        }
        let predicate = NSPredicate(format:"SELF MATCHES %@","^[0-9]*$")
        if predicate.evaluate(with: string) {
            //继续
        }else{
            return false
        }
        
        self.totalString = totalStr
        
        DotWithCount(textLength: textLength)
        
        return true
    }
    
    func DotWithCount(textLength:Int) -> Void {
        for label in pwdIndicatorArr! {
            (label as! UILabel).isHidden = true
        }
        for i in 0..<textLength {
            (pwdIndicatorArr?.object(at: i) as! UILabel).isHidden = false
            (pwdIndicatorArr?.object(at: i) as! UILabel).text = (self.totalString! as NSString).substring(with: NSMakeRange(i, 1))
        }
    }
    
}
