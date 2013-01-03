/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class KontomierzService extends Actor implements IKontomierzService
    {
        private var logger:ILogger;

        /** INJECTS */


        /** Constructor */
        public function KontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function login(user:UserVO):void
        {
            logger.debug(": login service call");

        }

        public function register(user:UserVO):void
        {
            logger.debug(": register service call");

        }
    }
}
