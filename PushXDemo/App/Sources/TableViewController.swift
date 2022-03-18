//
//  TableViewController.swift
//  PushLiteDemo
//
//  Created by Anton Bulankin on 25.05.2020.
//  Copyright © 2020 edna. All rights reserved.
//

import UIKit
import EDNAPushX
import Foundation
import CoreData

class TableViewController: UITableViewController {
    private var onboardingView: OnboardingView?
    
    private var tempCell = MessageTableViewCell()
    enum CellId: String {
        case push = "push"
        
        func id() -> String{
            return "ViewControllerCellId" + self.rawValue;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTitle()
    }
    
    private func showTitle(){
         self.navigationItem.title = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        let code = LocalizableUtils.currentLanguageCode()
        let imageLogoNane = "app_logo_\(code)"
        
        let logoImage = UIImage(named: imageLogoNane)?.withRenderingMode(.alwaysOriginal)
        let logoButton = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = logoButton
        self.navigationItem.leftBarButtonItem?.isEnabled = false

        self.view.backgroundColor = UIColor.colorThemeBackground()

        //onboardingView
        onboardingView?.textLabel.font = FontUtils.font("SFProDisplay-Regular", 22, .regular)
        onboardingView?.textLabel.textColor = UIColor.colorThemePrimary()
        
        onboardingView?.subTextLabel.font = FontUtils.font("SFProText-Regular", 17, .regular)
        onboardingView?.subTextLabel.textColor = UIColor.colorThemeSecondary()

        onboardingView?.loginButton.backgroundColor = UIColor.colorThemePrimary()
        onboardingView?.loginButton.setTitleColor(UIColor.colorThemeBackground(), for: .normal)
        
        onboardingView?.imageView?.image = UIImage(named: "empty")?.withRenderingMode(.alwaysOriginal)
        
        updateData()
    }
    
    func updateData(){
        let infoImage: UIImage?
        let isNeedLigin: Bool
        if let _ = ConnectData.shared.userIdInfo{
            infoImage = UIImage(named: "ico_login")?.withRenderingMode(.alwaysOriginal)
            isNeedLigin = false
            
        }else{
            infoImage = UIImage(named: "ico_anonimus")?.withRenderingMode(.alwaysOriginal)
            isNeedLigin = true
        }
        onboardingView?.loginButton.isHidden = !isNeedLigin
        onboardingView?.setNeedsLayout()
        let infoButton = UIBarButtonItem(image: infoImage, style: .plain, target: self, action: #selector(infoClick(_:)))
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc func infoClick(_ button: UIBarButtonItem){
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    func reloadFromBD(){
        if let context = context{
            let rows = PushData.allRows(context: context)
            pushViewDataList = rows.asPushViewDatas()
            tableView.reloadData()
        }
    }
    
    private var pushViewDataList = [PushViewData]()
    private var context: NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        context = PushXContainer.shared.container.viewContext
        
        if let context = context{
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: context, queue: OperationQueue.main) { [weak self] _ in
                self?.reloadFromBD()
            }
        }
        
        
        showTitle()
        reloadFromBD()

        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: CellId.push.id())
        tableView.separatorColor = UIColor.clear
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        onboardingView?.frame = self.view.bounds
    }
    
    @objc func loginClick(){
        let vc = LoginController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TableViewController{
    func findPushViewData(indexPath: IndexPath) -> PushViewData?{
        if indexPath.row >= 0 && indexPath.row < pushViewDataList.count {
            return pushViewDataList[indexPath.row]
        }
        return nil
    }
    
    func openDetailPush(cell: MessageTableViewCell, pushViewData: PushViewData){

        Logger.log("Show push info: " + (pushViewData.title ?? ""));

        let navController = MessageDetailNavController()
        let detailController = MessageDetailViewController(pushViewData: pushViewData)
        navController.viewControllers = [detailController]
        self.navigationController?.present(navController, animated: true)
    }
}

extension TableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pushViewDataList.count > 0 {
            onboardingView?.removeFromSuperview()
            onboardingView = nil
        }else{
            if onboardingView == nil {
                onboardingView = OnboardingView()
            }
            if let onboardingView = onboardingView{
                onboardingView.getTop = {
                    return self.topbarHeight
                }
                
                onboardingView.textLabel.text = LocalizedString("notif_list_onboarding_header")
                onboardingView.subTextLabel.text = LocalizedString("notif_list_onboarding_subheader")
                onboardingView.loginButton.setTitle(LocalizedString("login_btn"), for: .normal)
                onboardingView.loginButton.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
                
                if onboardingView.superview == nil {
                    view.addSubview(onboardingView)
                }
                updateUI()
            }
        }
        
        return pushViewDataList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.push.id(), for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if let pushViewData = self.findPushViewData(indexPath: indexPath){
            cell.fill(pushViewData: pushViewData)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pushViewData = findPushViewData(indexPath: indexPath) else {
            return;
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell else {
            return;
        }
        openDetailPush(cell: cell, pushViewData: pushViewData)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let pushViewData = findPushViewData(indexPath: indexPath){
            tempCell.fill(pushViewData: pushViewData)
            
            var width = self.view.frame.width
            
            if #available(iOS 11.0, *) {
                width -= self.tableView.safeAreaInsets.left + self.tableView.safeAreaInsets.right
            }
            
            let size = tempCell.getSizeByWidth(width, isUpdate: false)
            return size.height
        }
        return 0
    }
}

