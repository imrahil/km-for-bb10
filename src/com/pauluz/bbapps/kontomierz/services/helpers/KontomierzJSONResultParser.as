/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import com.pauluz.bbapps.kontomierz.constants.ApplicationConstants;
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;

    import qnx.ui.data.DataProvider;

    public class KontomierzJSONResultParser implements IResultParser
    {
        private var logger:ILogger;

        public function KontomierzJSONResultParser()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        public function parseLoginRegisterResponse(result:String):String
        {
            logger.debug(": parseLoginRegisterResponse");

            var resultObject:Object = JSON.parse(result);

            if (resultObject && resultObject.user && resultObject.user.api_key != "")
            {
                return resultObject.user.api_key;
            }
            else
            {
                return "";
            }
        }

        public function parseAllAccountsResponse(result:String):DataProvider
        {
            logger.debug(": parseAllAccountsResponse");

            var output:DataProvider = new DataProvider();
            var resultObject:Object = JSON.parse(result);

            if (resultObject && resultObject is Array && resultObject.length > 0)
            {
                for each (var item:Object in resultObject)
                {
                    if (item && item.user_account && item.user_account.bank_plugin_name != ApplicationConstants.WALLET_ACCOUNT_NAME)
                    {
                        var rawAccount:Object = item.user_account;
                        var account:AccountVO = new AccountVO();

                        account.id = rawAccount.id;
                        account.balance = rawAccount.balance;
                        account.bankName = rawAccount.bank_name;
                        account.bankPluginName = rawAccount.bank_plugin_name;
                        account.currencyBalance = rawAccount.currency_balance;
                        account.currencyName = rawAccount.currency_name;
                        account.displayName = rawAccount.display_name;
                        account.iban = rawAccount.iban;
                        account.ibanChecksum = rawAccount.iban_checksum;
                        account.is_default_wallet = rawAccount.is_default_wallet;

                        output.addItem(account);
                    }
                }
            }

            return output;
        }

        public function parseAllTransactionsResponse(result:String):DataProvider
        {
            logger.debug(": parseAllTransactionsResponse");

            var output:DataProvider = new DataProvider();
            var resultObject:Object = JSON.parse(result);

            if (resultObject && resultObject is Array && resultObject.length > 0)
            {
                for each (var item:Object in resultObject)
                {
                    if (item && item.money_transaction)
                    {
                        var rawTransaction:Object = item.money_transaction;
                        var transaction:TransactionVO = new TransactionVO();

                        transaction.id = rawTransaction.id;
                        transaction.userAccountId = rawTransaction.user_account_id;
                        transaction.currencyAmount = rawTransaction.currency_amount;
                        transaction.currencyName = rawTransaction.currency_name;
                        transaction.amount = rawTransaction.amount;
                        transaction.transactionOn = rawTransaction.transaction_on;
                        transaction.bookedOn = rawTransaction.booked_on;
                        transaction.description = rawTransaction.description;
                        transaction.categoryName = rawTransaction.category_name;
                        transaction.categoryId = rawTransaction.category_id;
                        transaction.tagString = rawTransaction.tag_string;

                        output.addItem(transaction);
                    }
                }
            }

            return output;
        }
    }
}