/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.controller.offline
{
    import com.pauluz.bbapps.kontomierz.constants.SQLStatements;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    public final class SaveCurrenciesOfflineCommand extends BaseOfflineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var currenciesList:Array;

        /** INJECTIONS **/
        [Inject]
        public var sqlRunner:SQLRunner;

        /**
         * Method handle the logic for <code>SaveCurrenciesCommand</code>
         */        
        override public function execute():void    
        {
            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();

            for each (var currency:CurrencyVO in currenciesList)
            {
                var params:Object = {};
                params["currencyId"] = currency.currencyId;
                params["name"] = currency.name;
                params["fullName"] = currency.fullName;

                stmts[stmts.length] = new QueuedStatement(SQLStatements.INSERT_CURRENCY_SQL, params);
            }

            sqlRunner.executeModify(stmts, null, databaseErrorHandler);
        }
    }
}
