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
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CurrencyVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;
    import com.pauluz.bbapps.kontomierz.utils.LogUtil;

    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;

    import qnx.ui.data.DataProvider;
    import qnx.ui.data.SectionDataProvider;

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

            try {
                var resultObject:Object = JSON.parse(result);
            }
            catch (e:Error)
            {
                logger.error("JSON Parse Error - parseLoginRegisterResponse");
            }

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

            try {
                var resultObject:Object = JSON.parse(result);
            }
            catch (e:Error)
            {
                logger.error("JSON Parse Error - parseAllAccountsResponse");
            }

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

        public function parseAllAccountsResponseAndFindDefaultWalletId(result:String):int
        {
            logger.debug(": parseAllAccountsResponseAndFindDefaultWalletId");

            try {
                var resultObject:Object = JSON.parse(result);
            }
            catch (e:Error)
            {
                logger.error("JSON Parse Error - parseAllAccountsResponseAndFindDefaultWalletId");
            }

            if (resultObject && resultObject is Array && resultObject.length > 0)
            {
                for each (var item:Object in resultObject)
                {
                    if (item && item.user_account)
                    {
                        var rawAccount:Object = item.user_account;

                        if (rawAccount.bank_plugin_name == ApplicationConstants.WALLET_ACCOUNT_NAME && rawAccount.is_default_wallet)
                        {
                            return rawAccount.id;
                        }
                    }
                }
            }

            return -1;
        }

        public function parseAllTransactionsResponse(result:String):DataProvider
        {
            logger.debug(": parseAllTransactionsResponse");

            var output:DataProvider = new DataProvider();

            try {
                var resultObject:Object = JSON.parse(result);
            }
            catch (e:Error)
            {
                logger.error("JSON Parse Error - parseAllTransactionsResponse");
            }

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

        public function parseAllCategoriesResponse(result:String):Array
        {
            logger.debug(": parseAllCategoriesResponse");

            var output:Array = [];

            try {
                var resultObject:Object = JSON.parse(result);
            }
            catch (e:Error)
            {
                logger.error("JSON Parse Error - parseAllCategoriesResponse");
            }

            if (resultObject && resultObject.category_groups && resultObject.category_groups is Array && resultObject.category_groups.length > 0)
            {
                for each (var item:Object in resultObject.category_groups)
                {
                    var category:CategoryVO = new CategoryVO();

                    category.id = item.id;
                    category.name = item.name;
                    category.position = item.position;
                    category.color = item.color;
                    category.header = true;

                    output.push(category);

                    if (item.categories && item.categories is Array && item.categories.length > 0)
                    {
                        for each (var subItem:Object in item.categories)
                        {
                            var subCategory:CategoryVO = new CategoryVO();

                            subCategory.id = subItem.id;
                            subCategory.name = subItem.name;
                            subCategory.position = subItem.position;
                            subCategory.color = subItem.color;

                            output.push(subCategory);
                        }
                    }
                }
            }

            return output;
        }

        public function parseAllCurrenciesResponse(result:String):Array
        {
            logger.debug(": parseAllCurrenciesResponse");

            var output:Array = [];

            try {
                var resultObject:Object = JSON.parse(result);
            }
            catch (e:Error)
            {
                logger.error("JSON Parse Error - parseAllCurrenciesResponse");
            }

            if (resultObject && resultObject.currencies && resultObject.currencies is Array && resultObject.currencies.length > 0)
            {
                for each (var item:Object in resultObject.currencies)
                {
                    var currency:CurrencyVO = new CurrencyVO();
                    currency.id = item.id;
                    currency.name = item.name;
                    currency.fullName = item.full_name;

                    if (item.name == ApplicationConstants.DEFAULT_CURRENCY_NAME)
                    {
                        currency.selected = true;
                    }

                    output.push(currency);
                }
            }

            return output;
        }
    }
}
