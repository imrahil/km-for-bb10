/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;

    import org.robotlegs.mvcs.SignalCommand;

    public final class LoginCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var user:UserVO;

        /** INJECTIONS **/
        [Inject]
        public var kontomierzService:IKontomierzService;

        /**
         * Method handle the logic for <code>LoginCommand</code>
         */        
        override public function execute():void    
        {
            kontomierzService.login(user);
        }
    }
}
