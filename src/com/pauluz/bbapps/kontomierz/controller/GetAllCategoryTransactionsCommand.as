/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller 
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.services.IKontomierzService;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public final class GetAllCategoryTransactionsCommand extends SignalCommand
    {
        [Inject]
        public var model:IKontomierzModel;

        [Inject]
        public var kontomierzService:IKontomierzService;

        [Inject]
        public var errorSignal:ErrorSignal;

        /**
         * Method handle the logic for <code>GetAllCategoryTransactionsCommand</code>
         */        
        override public function execute():void    
        {
            if (model.isConnected)
            {
                kontomierzService.getAllTransactionsForCategory(model.selectedCategory.categoryId);
            }
            else
            {
                var error:ErrorVO = new ErrorVO("Wymagane połączenie z internetem. Proszę spróbować później.", true);
                errorSignal.dispatch(error);
            }
        }
    }
}
