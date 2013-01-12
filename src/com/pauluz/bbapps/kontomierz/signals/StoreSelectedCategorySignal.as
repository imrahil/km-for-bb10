/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.signals
{
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;

    import org.osflash.signals.Signal;

    public class StoreSelectedCategorySignal extends Signal
    {
        public function StoreSelectedCategorySignal()
        {
            super(CategoryVO);
        }
    }
}
