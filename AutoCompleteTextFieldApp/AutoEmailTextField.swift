//
//  AutoEmailTextField.swift
//  AutoCompleteTextFieldApp
//
//  Created by xiaominfc on 10/30/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

import UIKit


class AutoEmailTextField: AutoCompleteTextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func updateData() {
        self.contentSource?.removeAllObjects();
        
        var text = String(self.text);
        
        if(text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0){
            hideAutoTableView();
        }else {
            let array = text.componentsSeparatedByString("@") as NSArray;
            text = array.objectAtIndex(0) as String;
            contentSource?.addObject(text.stringByAppendingString("@hotmail.com"));
            contentSource?.addObject(text.stringByAppendingString("@gmail.com"));
            contentSource?.addObject(text.stringByAppendingString("@126.com"));
            contentSource?.addObject(text.stringByAppendingString("@163.com"));
            contentSource?.addObject(text.stringByAppendingString("@qq.com"));
        }
        
    }

}
