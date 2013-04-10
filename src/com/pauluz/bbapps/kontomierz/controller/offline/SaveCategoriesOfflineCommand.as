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
    import com.pauluz.bbapps.kontomierz.model.vo.CategoryVO;
    import com.probertson.data.QueuedStatement;
    import com.probertson.data.SQLRunner;

    import qnx.ui.data.IDataProvider;
    import qnx.ui.data.SectionDataProvider;

    public final class SaveCategoriesOfflineCommand extends BaseOfflineCommand
    {
        /** PARAMETERS **/
        [Inject]
        public var categoriesList:SectionDataProvider;

        [Inject]
        public var direction:String;

        /** INJECTIONS **/
        [Inject]
        public var sqlRunner:SQLRunner;

        /**
         * Method handle the logic for <code>SaveCategoriesCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": saveCategories");

            var stmts:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
            var params:Object;

            for each (var category:CategoryVO in categoriesList.data)
            {
                params = {};
                params["categoryId"] = category.categoryId;
                params["name"] = category.name;
                params["header"] = category.header;
                params["direction"] = direction;
                params["parentId"] = 0;
                stmts[stmts.length] = new QueuedStatement(SQLStatements.INSERT_CATEGORY_SQL, params);

                var subTempDP:IDataProvider = categoriesList.getChildrenForItem(category);
                for each (var subCategory:CategoryVO in subTempDP.data)
                {
                    params = {};
                    params["categoryId"] = subCategory.categoryId;
                    params["name"] = subCategory.name;
                    params["header"] = subCategory.header;
                    params["direction"] = direction;
                    params["parentId"] = subCategory.parentId;
                    stmts[stmts.length] = new QueuedStatement(SQLStatements.INSERT_CATEGORY_SQL, params);
                }
            }

            sqlRunner.executeModify(stmts, null, databaseErrorHandler);
        }
    }
}
