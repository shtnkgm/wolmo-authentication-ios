//
//  SignupControllerTransitionDelegate.swift
//  Authentication
//
//  Created by Daniela Riesgo on 7/29/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

/**
     Protocol for handling transition events occured during signup.
 */
public protocol SignupControllerTransitionDelegate {    //swiftlint:disable:this class_delegate_protocol
    
    /**
         Function that reacts to the user signing up
         succesfully.
         
         Should take care of the screen transition,
         if wanting to there be one.
     */
    func onSignupSuccess(from controller: SignupController)
    
    /**
         Function that reacts to the user pressing "Log In"
         in the signup screen.
     
         Should take care of the screen transition.
     */
    func toLogin(from controller: SignupController)
    
    /**
         Function that reacts to the user pressing
         "Terms and Services" in the signup screen.
         
         Should take care of the screen transition.
     */
    func onTermsAndServices(from controller: SignupController)
    
}
