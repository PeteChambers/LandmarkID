//
//  WikiSearch.swift
//  Landmark ID
//
//  Created by Pete Chambers on 30/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import WikipediaKit
import UIKit

class WikiSearch: SharedImagePickerController {
    
    let wikipedia = Wikipedia()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
    
extension ImageSourceViewController {
    
    func LandmarkSearch() {
        
        let language = WikipediaLanguage("en")
        
        let title = landmarkResults.text
        
        let _ = Wikipedia.shared.requestArticleSummary(language: language, title: title!) { (article, error) in
            guard error == nil else { return }
            guard let article = article else { return }
            
            print(article.displayText)
            self.wikiResults.text = article.displayText
            self.saveToHistory()
        }
    
    }
    
}


