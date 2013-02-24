/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.model
{
    import com.pauluz.bbapps.kontomierz.model.vo.AccountVO;
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.pauluz.bbapps.kontomierz.model.vo.TransactionVO;

    import org.robotlegs.mvcs.*;

    import qnx.ui.data.DataProvider;

    import qnx.ui.data.SectionDataProvider;

    public class KontomierzModel extends Actor implements IKontomierzModel
    {
        private var _apiKey:String = "";
        private var _selectedAccount:AccountVO;
        private var _accountsList:DataProvider;

        private var _selectedTransaction:TransactionVO;

        private var _defaultWalletId:int;
        private var _walletTransactionsList:DataProvider;
        private var _isWalletListExpired:Boolean;

        private var _withdrawalCategoriesList:Array;
        private var _depositCategoriesList:Array;
        private var _selectedCategory:CategoryVO;

        private var _currenciesList:Array;

        public function get apiKey():String
        {
            return _apiKey;
        }

        public function set apiKey(value:String):void
        {
            _apiKey = value;
        }

        public function get selectedAccount():AccountVO
        {
            return _selectedAccount;
        }

        public function set selectedAccount(value:AccountVO):void
        {
            _selectedAccount = value;
        }

        public function get accountsList():DataProvider
        {
            return _accountsList;
        }

        public function set accountsList(value:DataProvider):void
        {
            _accountsList = value;
        }

        public function get selectedTransaction():TransactionVO
        {
            return _selectedTransaction;
        }

        public function set selectedTransaction(value:TransactionVO):void
        {
            _selectedTransaction = value;
        }

        public function get defaultWalletId():int
        {
            return _defaultWalletId;
        }

        public function set defaultWalletId(value:int):void
        {
            _defaultWalletId = value;
        }

        public function get walletTransactionsList():DataProvider
        {
            return _walletTransactionsList;
        }

        public function set walletTransactionsList(value:DataProvider):void
        {
            _walletTransactionsList = value;
        }

        public function get isWalletListExpired():Boolean
        {
            return _isWalletListExpired;
        }

        public function set isWalletListExpired(value:Boolean):void
        {
            _isWalletListExpired = value;
        }

        public function get withdrawalCategoriesList():Array
        {
            return _withdrawalCategoriesList;
        }

        public function set withdrawalCategoriesList(value:Array):void
        {
            _withdrawalCategoriesList = value;
        }

        public function get depositCategoriesList():Array
        {
            return _depositCategoriesList;
        }

        public function set depositCategoriesList(value:Array):void
        {
            _depositCategoriesList = value;
        }

        public function get selectedCategory():CategoryVO
        {
            return _selectedCategory;
        }

        public function set selectedCategory(value:CategoryVO):void
        {
            _selectedCategory = value;
        }

        public function get currenciesList():Array
        {
            return _currenciesList;
        }

        public function set currenciesList(value:Array):void
        {
            _currenciesList = value;
        }
    }
}
