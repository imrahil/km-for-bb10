/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.model
{
    import org.robotlegs.mvcs.*;

    public class KontomierzModel extends Actor implements IKontomierzModel
    {
        private var _apiKey:String = "";

        public function get apiKey():String
        {
            return _apiKey;
        }

        public function set apiKey(value:String):void
        {
            _apiKey = value;
        }
    }
}