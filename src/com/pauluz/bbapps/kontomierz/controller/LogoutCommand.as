/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;

    import org.robotlegs.mvcs.SignalCommand;

    public final class LogoutCommand extends SignalCommand
    {
        /** INJECTIONS **/
        [Inject]
        public var model:IKontomierzModel;

        /**
         * Method handle the logic for <code>LogoutCommand</code>
         */        
        override public function execute():void    
        {
        }
    }
}
