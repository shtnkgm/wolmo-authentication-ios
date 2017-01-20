//
//  FacebookLoginConfiguration.swift
//  Authentication
//
//  Created by Gustavo Cairo on 1/12/17.
//  Copyright © 2017 Wolox. All rights reserved.
//

import FacebookCore
import FacebookLogin

public final class FacebookLoginConfiguration: LoginProviderConfiguration {
    
    public let readPermissions: [ReadPermission]
    public let publishPermissions: [PublishPermission]
    public let defaultAudience: LoginDefaultAudience
    
    /**
        Initializes a new instance of FacebookLoginConfiguration.
     
        By default, read permissions are included, but not publish permissions.
        If publish permissions are added, the `readPermissions` array will 
        be ignored and the publish permissions array will be used.
    */
    init(readPermissions: [ReadPermission] = [.userFriends, .publicProfile, .email],
         publishPermissions: [PublishPermission] = [],
         defaultAudience: LoginDefaultAudience = .friends) {
        self.readPermissions = readPermissions
        self.publishPermissions = publishPermissions
        self.defaultAudience = defaultAudience
    }
    
}
