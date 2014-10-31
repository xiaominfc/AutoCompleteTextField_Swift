//
//  AutoCompleteTextField.swift
//  AutoCompleteTextFieldApp
//
//  Created by xiaominfc on 10/29/14.
//  Copyright (c) 2014 haitou. All rights reserved.
//

import UIKit



class BottomLineTableCell:UITableViewCell {
    
    let lineColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4);
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect);
        var context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context,kCGLineCapSquare);
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, 0, self.frame.size.height);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
        CGContextStrokePath(context);
        
    }
}


class AutoCompleteTextField: UITextField,UITableViewDelegate,UITableViewDataSource{

    let CELLHEIGHT:CGFloat = 24;
    let AUTOCONTENTHEIGHT:CGFloat = (5 * 24);
    let AUTOCONTENTMARGIN:CGFloat = 2;
    
    
    var autoCompleteTableView : UITableView? = nil;
    var contentSource : NSMutableArray? = nil;
    
    var actionTarget : AnyObject? = nil;
    var workAction : Selector? = nil;
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        println("init");
        initContent();
    }
    
    
    func initContent(){
        super.addTarget(self, action:"valueChanged:", forControlEvents: UIControlEvents.EditingChanged);
        self.contentSource = NSMutableArray();
        self.initData();
    }
    
    
    
    func valueChanged(sender:UITextField){
        self.showAutoTableView();
        if(workAction != nil && actionTarget != nil){
            actionTarget?.targetForAction(workAction!, withSender: sender);
        }
    }
    
    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
        if(controlEvents != UIControlEvents.EditingChanged){
            super.addTarget(target, action: action, forControlEvents: controlEvents);
        }else {
            actionTarget = target;
            workAction = action;
        }
    }
    
    func initData(){
        
    }
    
    func updateData(){
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.contentSource?.count{
            return count;
        }
        
        return 0;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.CELLHEIGHT;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = BottomLineTableCell();
        cell.textLabel.font = UIFont(name: "Helvetica", size: 12);
        cell.textLabel.text = self.contentSource?.objectAtIndex(indexPath.row).description;
        cell.contentMode = UIViewContentMode.Left;
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hideAutoTableView();
        self.text = self.contentSource?.objectAtIndex(indexPath.row).description;
    }
    
    func getRootView() -> UIView?{
        var rootView = self.superview;
        while(rootView?.superview != nil){
            rootView = rootView?.superview;
        }
        return rootView;
    }
    
    func showAutoTableView(){
        let rootView = self.getRootView();
        if(self.autoCompleteTableView == nil && rootView != nil){
            var rect:CGRect = self.convertRect(self.bounds, toView: rootView);
            let y:CGFloat = rect.origin.y;
            
            if(rect.origin.y > AUTOCONTENTHEIGHT + AUTOCONTENTMARGIN + 20){ //20是状态栏的高度
                rect.origin.y = y - self.AUTOCONTENTHEIGHT - self.AUTOCONTENTMARGIN;
            }else {
                rect.origin.y = y + rect.size.height + AUTOCONTENTMARGIN;
            }
            
            rect.size.height = AUTOCONTENTHEIGHT;
            self.autoCompleteTableView = UITableView(frame: rect);
            self.autoCompleteTableView?.dataSource = self;
            self.autoCompleteTableView?.delegate = self;
            let borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4);
            self.autoCompleteTableView?.layer.borderColor = borderColor.CGColor;
            self.autoCompleteTableView?.layer.borderWidth = 0.5;
            self.autoCompleteTableView?.bounces = false;
            self.autoCompleteTableView?.separatorStyle = UITableViewCellSeparatorStyle.None;
        }
        
       
            
        if let animatedView = self.autoCompleteTableView{
            let array:NSArray = (rootView?.subviews)! as NSArray;
            if(!array.containsObject(self.autoCompleteTableView!)) {
                self.autoCompleteTableView?.alpha = 0;
                animatedView.alpha = 0;
                
                UIView.animateWithDuration(0.3, animations:
                    {
                        animatedView.alpha = 1;
                    }, completion:
                    {
                        (Bool finished) in
                        animatedView.alpha = 1;
                    }
                );
                rootView?.addSubview(animatedView);
                
            }
            self.updateData();
            animatedView.reloadData();
        }
    }
    
    func hideAutoTableView(){
        if let animatedView = self.autoCompleteTableView{
            
            UIView.animateWithDuration(0.3, animations:
                {
                    animatedView.alpha = 0;
                }, completion:
                {
                    (Bool finished) in
                    animatedView.alpha = 0;
                    animatedView.removeFromSuperview();
                }
            );
        }
    }
    
    
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder();
    }
}
