//
//  Logger.swift
//  PushLiteDemo
//
//  Created by Anton Bulankin on 18.06.2020.
//  Copyright © 2020 edna. All rights reserved.
//

import UIKit

public class Logger: NSObject{
    private override init() {
        super.init()
    }
    private static let shared = Logger()
    
    private var changedBlock:((String)->())?
    
    var text = "" {
        didSet{
            self.logTextDidChanged()
        }
    }
    
    private func logTextDidChanged(){
        DispatchQueue.main.async { [unowned self] in
            if let changedBlock = self.changedBlock {
                changedBlock(self.text)
            }
        }
    }

    public class func log(_ str: String, params: [String: Any?]? = nil){
        var newText = str;
        if let params = params {
            for (key, value) in params {
                newText += "\n  + \(key) = \(value ?? "nil")"
            }
        }
        shared.text = shared.text != "" ? shared.text + "\n" + newText : newText
        print(newText);
    }
    
    public class func setChangeBlock(_ block: @escaping ((String)->())){
        shared.changedBlock = block
        shared.logTextDidChanged()
    }
    
    public class func clear(){
        shared.text = ""
    }
    
    // Логируем в сеть на несуществующий сервер.
    public class func logAsRequest(_ urlPath: String){
        let session = URLSession(configuration: URLSessionConfiguration.default);
        let task = session.dataTask(with: URL(string: "http://aaa-server-log.com" + urlPath)!, completionHandler: { (data, response, error) in })
        task.resume()
    }
}
