/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.signals.signaltons
{
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;

    import org.osflash.signals.Signal;

    public class InfoSignal extends Signal
    {
        public function InfoSignal()
        {
            super(ErrorVO);
        }
    }
}
