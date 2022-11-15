//
//  PhotoleapCloneApp.swift
//  PhotoleapClone
//
//  Created by Umberto Breglia on 15/11/22.
//

import SwiftUI

@main
struct PhotoleapCloneApp: App {
    var body: some Scene {
        WindowGroup {
            EditPhotoView()
                .preferredColorScheme(.dark)
        }
    }
}
