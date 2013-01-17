/*
 Copyright (c) 2013 pauluZ.pl, All Rights Reserved
 @author   Pawel Szczepanek
 @contact  pawel.szczepanek@gmail.com
 @project  Kontomierz
 @internal
 */
package com.pauluz.bbapps.kontomierz.model.vo
{
    /**
     *
     * Defines the <code>TransactionVO<code> Value Object implementation
     *
     */
    [Bindable]
    public class TransactionVO
    {
        public var id:int;
        public var userAccountId:int;
        public var currencyAmount:Number = 0;
        public var currencyName:String = "";
        public var amount:Number = 0;
        public var transactionOn:String = "";
        public var bookedOn:String = "";
        public var description:String = "";
        public var categoryName:String = "";
        public var categoryId:int;
        public var tagString:String = "";

        public var direction:String = "";
    }
}
