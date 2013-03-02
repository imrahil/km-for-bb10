/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.IKontomierzModel;
    import com.pauluz.bbapps.kontomierz.model.vo.ErrorVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ErrorSignal;
    import com.pauluz.bbapps.kontomierz.signals.signaltons.ProvideLoginStatusSignal;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import flash.data.SQLResult;
    import flash.errors.SQLError;

    import mx.logging.ILogger;

    import org.robotlegs.mvcs.Actor;

    public class SQLKontomierzService extends Actor implements ISQLKontomierzService
    {
        protected var logger:ILogger;

        /** MODEL **/
        [Inject]
        public var model:IKontomierzModel;

        /** INJECTS */
        [Inject]
        public var sqlRunner:SQLRunner;

        /** NOTIFICATION SIGNALS */
        [Inject]
        public var provideLoginStatusSignal:ProvideLoginStatusSignal;

        [Inject]
        public var errorSignal:ErrorSignal;

        /** Constructor */
        public function SQLKontomierzService()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function saveUserAPIKey(apiKey:String):void
        {
            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(INSERT_API_KEY_SQL, {apiKey:apiKey})]), null, databaseErrorHandler);
        }

        public function retrieveUserAPIKey():void
        {
            sqlRunner.execute(LOAD_API_KEY_SQL, null, loadAPIKeyResult, null, databaseErrorHandler);
        }

        private function loadAPIKeyResult(result:SQLResult):void
        {
            if (result.data != null && result.data.length > 0)
            {
                model.apiKey = result.data[0].apiKey;

                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_REMEMBERED);
            }
            else
            {
                provideLoginStatusSignal.dispatch(ApplicationConstants.LOGIN_STATUS_NEW);
            }
        }

        public function deleteUserAPIKey():void
        {
            sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(DELETE_API_KEY_SQL)]), null, databaseErrorHandler);
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

        private function databaseErrorHandler(sqlError:SQLError):void
        {
            logger.debug("databaseError: " + sqlError.details);

            var error:ErrorVO = new ErrorVO(sqlError.details);
            errorSignal.dispatch(error);
        }

          // ------- SQL statements -------
        [Embed(source="/assets/sql/InsertAPIKey.sql", mimeType="application/octet-stream")]
        private static const InsertAPIKeyStatementText:Class;
        private static const INSERT_API_KEY_SQL:String = new InsertAPIKeyStatementText();

        [Embed(source="/assets/sql/LoadAPIKey.sql", mimeType="application/octet-stream")]
        private static const LoadAPIKeyStatementText:Class;
        private static const LOAD_API_KEY_SQL:String = new LoadAPIKeyStatementText();

        [Embed(source="/assets/sql/DeleteAPIKey.sql", mimeType="application/octet-stream")]
        private static const DeleteAPIKeyStatementText:Class;
        private static const DELETE_API_KEY_SQL:String = new DeleteAPIKeyStatementText();
    }
}
