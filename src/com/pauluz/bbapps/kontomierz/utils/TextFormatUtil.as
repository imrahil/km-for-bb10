/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.utils
{
    import qnx.fuse.ui.text.TextAlign;
    import qnx.fuse.ui.text.TextFormat;

    public class TextFormatUtil
    {
        public function TextFormatUtil()
        {
            super();
        }

        public static function setFormat(format:TextFormat, fontSize:int = 54, color:uint = 0xFAFAFA):TextFormat
        {
            format.size = fontSize;
            format.color = color;
            format.italic = true;
            format.font = "Slate Pro Light";

            return format;
        }

        public static function setFormatAlignRight(format:TextFormat):TextFormat
        {
            format.size = 50;
            format.color = 0xFAFAFA;
            format.italic = true;
            format.font = "Slate Pro Light";
            format.align = TextAlign.RIGHT;

            return format;
        }

        public static function setErrorFormat(format:TextFormat):TextFormat
        {
            format.size = 45;
            format.color = 0xFF0000;
            format.italic = true;
            format.font = "Slate Pro Light";

            return format;
        }
    }
}
