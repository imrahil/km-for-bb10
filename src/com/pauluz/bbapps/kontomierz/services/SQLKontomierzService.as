/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.model.vo.UserVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class SQLKontomierzService extends Actor implements ISQLKontomierzService
    {
        protected var logger:ILogger;

        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        /** NOTIFICATION SIGNALS */


        /** INJECTS */


        /** Constructor */
        public function SQLKontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function getAllAccounts():void
        {
            throw new Error("Override this method!");
        }

        public function getAllTransactions(accountId:int, wallet:Boolean):void
        {
            throw new Error("Override this method!");
        }

        public function getAllTransactionsForCategory(categoryId:int):void
        {
            throw new Error("Override this method!");
        }

        public function createTransaction(transaction:TransactionVO):void
        {
            throw new Error("Override this method!");
        }

        public function updateTransaction(transaction:TransactionVO):void
        {
            throw new Error("Override this method!");
        }

        public function deleteTransaction(id:int, wallet:Boolean):void
        {
            throw new Error("Override this method!");
        }

        public function getAllWithdrawalCategories():void
        {
            throw new Error("Override this method!");
        }

        public function getAllDepositCategories():void
        {
            throw new Error("Override this method!");
        }

        public function getAllCurrencies():void
        {
            throw new Error("Override this method!");
        }
    }
}
