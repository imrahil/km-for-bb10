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

        private var _categoriesList:SectionDataProvider;
        private var _selectedCategory:CategoryVO;

        private var _currenciesList:DataProvider;

        public function get apiKey():String
        {
            return _apiKey;

            // DEMO USER
//            return "e7cOI9zZTbprBddSHHnlniLsAvzBpfhqTIjeUid2be0fjb2REaWnudZqGSgxz1Lz";;
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

        public function get categoriesList():SectionDataProvider
        {
            return _categoriesList;
        }

        public function set categoriesList(value:SectionDataProvider):void
        {
            _categoriesList = value;
        }

        public function get selectedCategory():CategoryVO
        {
            return _selectedCategory;
        }

        public function set selectedCategory(value:CategoryVO):void
        {
            _selectedCategory = value;
        }

        public function get currenciesList():DataProvider
        {
            return _currenciesList;
        }

        public function set currenciesList(value:DataProvider):void
        {
            _currenciesList = value;
        }
    }
}
