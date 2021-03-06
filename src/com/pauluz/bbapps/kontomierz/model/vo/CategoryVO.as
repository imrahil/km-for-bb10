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
     * Defines the <code>CategoryVO<code> Value Object implementation
     *
     */
    [Bindable]
    public class CategoryVO extends ListDialogBaseVO
    {
        public var id:int;
        public var categoryId:int;
        public var name:String;
        public var position:int;
        public var color:String;

        public var direction:String;
        public var parentId:int;

        public function get label():String
        {
            return this.name;
        }
    }
}
