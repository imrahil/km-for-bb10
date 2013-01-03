/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.utils
{
    public class StringHelper
    {
        public static function trim(s:String):String
        {
            if (s)
            {
                return s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2");
            }

            return null;
        }

        public static function checkEmail(email:String):Boolean
        {
            var regExpPattern:RegExp =
                    /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;

            if (email.match(regExpPattern) == null)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}
