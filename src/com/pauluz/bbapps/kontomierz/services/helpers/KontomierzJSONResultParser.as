/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    public class KontomierzJSONResultParser implements IResultParser
    {
        private var logger:ILogger;

        public function KontomierzJSONResultParser()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function parseLoginRegisterResponse(result:String):String
        {
            logger.debug(": parseLoginRegisterResponse");

            var resultObject:Object = JSON.parse(result);

            if (resultObject && resultObject.user && resultObject.user.api_key != "")
            {
                return resultObject.user.api_key;
            }
            else
            {
                return "";
            }
        }
    }
}
