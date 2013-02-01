/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.signals.signaltons
{
    import org.osflash.signals.Signal;

    import qnx.ui.data.SectionDataProvider;

    public class ProvideAllWithdrawalCategoriesSignal extends Signal
    {
        public function ProvideAllWithdrawalCategoriesSignal()
        {
            super(Array);
        }
    }
}
