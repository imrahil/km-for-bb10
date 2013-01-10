/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.view.mediators
{
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;
    
    import com.pauluz.bbapps.kontomierz.view.CategoriesView;
    import org.robotlegs.mvcs.SignalMediator;

    public class CategoriesViewMediator extends SignalMediator
    {
        /**
         * VIEW
         */
        [Inject]
        public var view:CategoriesView;

        /**
         * SIGNALTONS
         */


        /**
         * SIGNAL -> COMMAND
         */

        /** variables **/
        private var logger:ILogger;

        /** 
         * CONSTRUCTOR 
         */
        public function CategoriesViewMediator()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        /** 
         * onRegister 
         * Override the invoked of the <code>IMediator</code> and allow you to place your own initialization. 
         */
        override public function onRegister():void
        {
            logger.debug(": onRegister");
            
        }

        /** methods **/

        /** eventHandlers **/

    }
}
