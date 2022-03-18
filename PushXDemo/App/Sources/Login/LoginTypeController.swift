//
//  LoginTypeController.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 14.02.2022.
//

import UIKit

class LoginTypeController: UITableViewController {
    var onChangeType: ((_ type: LoginType) -> Void)?
    
    private func showTitle(){
         self.navigationItem.title = LocalizedString("login_type")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        self.view.backgroundColor = UIColor.colorThemeLight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(LoginTypeCell.self, forCellReuseIdentifier: "LoginTypeCell")
        
        showTitle()
        
        updateUI()
    }
}

extension LoginTypeController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = LoginType.allCases.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = LoginType.allCases[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTypeCell", for: indexPath)
        cell.textLabel?.text = type.title()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = LoginType.allCases[indexPath.row]
        onChangeType?(type)
        self.navigationController?.popViewController(animated: true)
    }
}
