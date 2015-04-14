//
//  RecorderAudio.swift
//  Udacity 1
//
//  Created by Vladimirs Matusevics on 11/04/2015.
//  Copyright (c) 2015 vmatusevic. All rights reserved.
//

import UIKit

class RecorderAudio: NSObject {
   
    var title: String!
    var recordingFilePath: NSURL!
    
    init(title: String, filePath: NSURL) {
        self.title = title
        self.recordingFilePath = filePath
    }
    
}
