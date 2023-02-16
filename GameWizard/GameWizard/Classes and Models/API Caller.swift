//
//  API Caller.swift
//  GameWizard
//
//  Created by Letterio Ugo Cangiano on 16/02/23.
//

import Foundation

struct AppName: Codable {
    var appid: Int
    var name: String
    
    init() {
        appid = 0
        name = ""
    }
}

struct AppList: Codable {
    var apps: [AppName]
    
    init() {
        self.apps = []
    }
}

struct Post: Codable{
    var applist = AppList()
    
    init() {
        
    }
    
}

func callAPI(){
    guard let url = URL(string: "https://api.steampowered.com/ISteamApps/GetAppList/v2/") else{
        return
    }


    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let string = String(data: data, encoding: .utf8){
            do {
                try string.write(to: Bundle.main.url(forResource: "Lib", withExtension: "json")!, atomically: true, encoding: .utf8)
            } catch {
                print("Error")
            }
        }
    }

    task.resume()
}
