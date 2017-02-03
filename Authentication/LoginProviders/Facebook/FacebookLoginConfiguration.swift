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
    
    //TODO: Check if we can add a request for requesting publish permissions
    //  after logging in (like the extra information).
    
    public let readPermissions: [ReadPermission]
    public let publishPermissions: [PublishPermission]
    public let defaultAudience: LoginDefaultAudience
    
    /**
        Initializes a new instance of FacebookLoginConfiguration.
     
        As the user logs in, you can only ask for read permissions
        or publish permissions, not both.
        So if publish permissions are added in the configuration,
        the `readPermissions` array will be ignored and the
        `publishPermissions` array will be used.
        If not, the `readPermissions` will be the ones requested.
        
        The permissions requested are not necessarily the granted permissions
        by Facebook.
     
        - Warning: If your app asks for more than the default readPermissions,
            Facebook must review the app before you release it.
     
        - Parameters:
            - readPermissions: Permissions that define which read information
                is wanted from Facebook about the user who logs in.
                By default, the friends list, the public profile and the email address.
            - publishPermissions: Permissions that define what permissions
                are needed for publishing new information as the user.
            - defaultAudience: the default audience to publish to if publishing
                were to take place. If you are not using publish permissions,
                you can leave the default value, it won't be used.
                By default, the user's friends.
    */
    init(readPermissions: [ReadPermission] = [.userFriends, .publicProfile, .email],
         publishPermissions: [PublishPermission] = [],
         defaultAudience: LoginDefaultAudience = .friends) {
        self.readPermissions = readPermissions
        self.publishPermissions = publishPermissions
        self.defaultAudience = defaultAudience
    }
    
}
