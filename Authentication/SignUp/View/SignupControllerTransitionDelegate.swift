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
public protocol SignupControllerTransitionDelegate {
    
    /**
         Function that reacts to the user signing up
         succesfully.
         
         Should take care of the screen transition,
         if wanting to there be one.
     */
    func onSignupSuccess(_ controller: SignupController)
    
    /**
         Function that reacts to the user pressing "Log In"
         in the signup screen.
     
         Should take care of the screen transition.
     */
    func toLogin(_ controller: SignupController)
    
    /**
         Function that reacts to the user pressing
         "Terms and Services" in the signup screen.
         
         Should take care of the screen transition.
     */
    func onTermsAndServices(_ controller: SignupController)
    
}
