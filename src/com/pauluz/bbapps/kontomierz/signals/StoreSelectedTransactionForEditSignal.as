/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.signals
{
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import org.osflash.signals.Signal;

    public class StoreSelectedTransactionForEditSignal extends Signal
    {
        public function StoreSelectedTransactionForEditSignal()
        {
            super(TransactionVO);
        }
    }
}
