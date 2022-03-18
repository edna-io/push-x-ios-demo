//
//  LogViewController.swift
//  THRPolarbearGate
//
//  Created by Alexey Khimunin on 12.01.2022.
//

import UIKit

class LogViewController: UIViewController{
    private var textView: UITextView?
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        self.view.backgroundColor = UIColor.colorThemeBackground()
        textView?.font = FontUtils.font("SFProDisplay-Regular", 17, .regular)
        textView?.textColor = UIColor.colorThemePrimary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTextView()
        
        self.navigationItem.title = LocalizedString("lmenu_logs")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(LogViewController.clear))
        Logger.setChangeBlock { [weak self] (newText) in
            self?.textView?.text = newText
        }
        
        updateUI()
    }
    
    private func createTextView(){
        textView = UITextView()
        textView?.isEditable = false
        self.view = textView;
    }
    
    @objc func clear(){
        Logger.clear()
    }
}
