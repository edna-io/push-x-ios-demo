//
//  SettingsViewController.swift
//  PushXDemo
//
//  Created by Alexey Khimunin on 11.02.2022.
//

import UIKit
import EDNAPushX

class SettingsViewController: UITableViewController{
    
    struct rowData{
        let CellReuseIdentifier: String
    }
    
    struct sectionData{
        let name: String
        let rows: [rowData]
    }

    let data: [sectionData] = [sectionData(name: LocalizedString("lmenu_client_subheader"), rows:
                                            [rowData(CellReuseIdentifier: "SettingsClientInfoCell"),
                                             rowData(CellReuseIdentifier: "SettingsClientLoginCell"),
                                             rowData(CellReuseIdentifier: "SettingsClearHistoryCell")]),
                               sectionData(name: LocalizedString("lmenu_lib_version_header"), rows:
                                            [rowData(CellReuseIdentifier: "SettingsPushXCell"),
                                             rowData(CellReuseIdentifier: "SettingsPushXNECell")]),
                               sectionData(name: LocalizedString("lmenu_device_info_header"), rows:
                                            [rowData(CellReuseIdentifier: "SettingsDevaceNameCell"),
                                             rowData(CellReuseIdentifier: "SettingsDevaceAddressCell"),
                                             rowData(CellReuseIdentifier: "SettingsDevaceIdCell"),
                                             rowData(CellReuseIdentifier: "SettingsCopyInfoCell")]),
                               sectionData(name: "", rows:
                                            [rowData(CellReuseIdentifier: "SettingsLogsCell")])
    ]
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUI(){
        self.view.backgroundColor = UIColor.colorThemeSettingsTable()
    }
    
    private func showTitle(){
         self.navigationItem.title = LocalizedString("settings")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.tableView.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTitle()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let doneButton = UIBarButtonItem(title: LocalizedString("done_btn"), style: .done, target: self, action: #selector(doneClick(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        
        tableView.register(SettingsClientInfoCell.self, forCellReuseIdentifier: "SettingsClientInfoCell")
        tableView.register(SettingsClientLoginCell.self, forCellReuseIdentifier: "SettingsClientLoginCell")
        tableView.register(SettingsClearHistoryCell.self, forCellReuseIdentifier: "SettingsClearHistoryCell")
        tableView.register(SettingsLogsCell.self, forCellReuseIdentifier: "SettingsLogsCell")
        tableView.register(SettingsDevaceNameCell.self, forCellReuseIdentifier: "SettingsDevaceNameCell")
        
        tableView.register(SettingsDevaceAddressCell.self, forCellReuseIdentifier: "SettingsDevaceAddressCell")
        tableView.register(SettingsDevaceIdCell.self, forCellReuseIdentifier: "SettingsDevaceIdCell")
        tableView.register(SettingsCopyInfoCell.self, forCellReuseIdentifier: "SettingsCopyInfoCell")
        
        tableView.register(SettingsPushXCell.self, forCellReuseIdentifier: "SettingsPushXCell")
        tableView.register(SettingsPushXNECell.self, forCellReuseIdentifier: "SettingsPushXNECell")
        
        updateUI()
    }

    @objc func doneClick(_ button: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = data[section]
        return sectionData.rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let sectionData = data[section]
        return sectionData.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = data[indexPath.section]
        let rowData = sectionData.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowData.CellReuseIdentifier, for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionData = data[indexPath.section]
        let rowData = sectionData.rows[indexPath.row]
        //Login-Logout
        if rowData.CellReuseIdentifier == "SettingsClientLoginCell" {
            if let _ = ConnectData.shared.userIdInfo{
                EDNAPushX.logout()
                Logger.log("[APP] pushX.logout")
                ConnectData.shared.userIdInfo = nil
                tableView.reloadData()
            }else{
                let vc = LoginController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        //Logs
        if rowData.CellReuseIdentifier == "SettingsLogsCell" {
            let vc = LogViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //Clear messages
        if rowData.CellReuseIdentifier == "SettingsClearHistoryCell" {
            let alertController = UIAlertController(title: LocalizedString("clear_history_header"), message: LocalizedString("clear_history_subheader"), preferredStyle: UIAlertController.Style.alert)
            
            let clearAction = UIAlertAction(title: LocalizedString("lmenu_clear_history_btn"), style: .default) {_ in
                let context = PushXContainer.shared.container.viewContext
                PushData.clearAll(context: context)
                PushXContainer.shared.save()
            }
            alertController.addAction(clearAction)
            
            alertController.addAction(.init(title: LocalizedString("cancel_btn"), style: .cancel, handler: nil))
            
            alertController.preferredAction = clearAction
            
            self.present(alertController, animated: true, completion: {})
        }
        //Copy info
        if rowData.CellReuseIdentifier == "SettingsCopyInfoCell" {
            
            let infoRes = "\(LocalizedString("lmenu_device_name")): \(UIDevice.current.name)\n\(LocalizedString("lmenu_device_address")): \(ConnectData.shared.deviceAddress ?? "-")\n\(LocalizedString("lmenu_device_id")): \(ConnectData.shared.deviceUid ?? "-")"
            
            let rsToShare = [ infoRes ]
            let activityViewController = UIActivityViewController(activityItems: rsToShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

protocol CellSizeProtocol{
    func getSizeByWidth(_ width: CGFloat, isUpdate: Bool) -> CGSize
}
                                           
