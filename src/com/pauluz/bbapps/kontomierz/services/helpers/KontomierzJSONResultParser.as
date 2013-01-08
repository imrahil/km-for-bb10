/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.services.helpers
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
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
                    if (item && item.user_account)
                    {
                        var account:AccountVO = new AccountVO();
                        account.id = item.user_account.id;
                        account.balance = item.user_account.balance;
                        account.bank_name = item.user_account.bank_name;
                        account.bank_plugin_name = item.user_account.bank_plugin_name;
                        account.currency_balance = item.user_account.currency_balance;
                        account.currency_name = item.user_account.currency_name;
                        account.display_name = item.user_account.display_name;
                        account.iban = item.user_account.iban;
                        account.iban_checksum = item.user_account.iban_checksum;
                        account.is_default_wallet = item.user_account.is_default_wallet;

                        output.addItem(account);
                    }
                }
            }

            return output;
        }
    }
}
