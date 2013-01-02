/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.utils
{
    import flash.utils.getQualifiedClassName;

    import mx.logging.ILogger;
    import mx.logging.Log;

    public class LogUtil
    {
        /**
         * Get a logger for
         */
        public static function getLogger(obj:Object):ILogger
        {
            return Log.getLogger(getQualifiedClassName(obj).replace("::", "."));
        }
    }
}
