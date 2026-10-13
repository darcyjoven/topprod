/*
================================================================================
檔案代號:bmq_file
檔案名稱:测试料件资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmq_file
(
bmq01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
bmq011      varchar2(40),            /*正式料号                               */
                                     /*正式料號                               */
bmq02       varchar2(120),           /*品名                                   */
bmq021      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
bmq05       varchar2(10),            /*当前使用版本                           */
                                     /*目前使用版本                           */
bmq06       varchar2(10),            /*分群码                                 */
                                     /*分群碼                                 */
bmq08       varchar2(1),             /*来源码                                 */
                                     /*來源碼                                 */
bmq09       varchar2(10),            /*其他分群码 一                          */
                                     /*其他分群碼 一                          */
bmq10       varchar2(10),            /*其他分群码 二                          */
                                     /*其他分群碼 二                          */
bmq11       varchar2(10),            /*其他分群码 三                          */
                                     /*其他分群碼 三                          */
bmq12       varchar2(10),            /*其他分群码 四                          */
                                     /*其他分群碼 四                          */
bmq15       varchar2(1),             /*保税与否                               */
                                     /*保稅與否                               */
bmq25       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
bmq31       varchar2(4),             /*销售单位                               */
                                     /*銷售單位                               */
bmq31_fac   number(20,8),            /*销售单位/库存单位换算率                */
                                     /*銷售單位/庫存單位換算率                */
bmq37       varchar2(1),             /*补货策略码                             */
                                     /*補貨策略碼                             */
bmq44       varchar2(4),             /*采购单位                               */
                                     /*採購單位                               */
bmq44_fac   number(20,8),            /*采购单位/库存单位换算率                */
                                     /*採購單位/庫存單位換算率                */
bmq53       number(20,6),            /*最近采购单价                           */
                                     /*最近採購單價                           */
bmq531      number(20,6),            /*市价                                   */
                                     /*市價                                   */
bmq55       varchar2(4),             /*生产单位                               */
                                     /*生產單位                               */
bmq55_fac   number(20,8),            /*生产单位/库存单位换算率                */
                                     /*生產單位/庫存單位換算率                */
bmq63       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
bmq63_fac   number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率                */
bmq91       number(20,6),            /*平均采购单价                           */
                                     /*平均採購單價 (本幣)                    */
bmq103      varchar2(1),             /*采购特性                               */
                                     /*採購特性                               */
                                     /*分類此採購料件特性                     */
                                     /*'0':內購 '1':外購 '2':其它             */
bmq105      varchar2(1),             /*是否为软体对象                         */
                                     /*是否為軟體物件                         */
bmq107      varchar2(1),             /*插件位置                               */
                                     /*插件位置   #No:6542                    */
                                     /*Y:  自動開窗輸入插件位置               */
                                     /*N:不自動開窗輸入插件位置               */
bmq147      varchar2(1),             /*插件位置与QPA是否要勾稽                */
                                     /*插件位置與QPA是否要勾稽 #NO:6542       */
bmq901      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq902      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq903      varchar2(1),             /*可否做联产品入库                       */
                                     /*可否做聯產品入庫#NO:7120               */
bmq904      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq905      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq906      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq907      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq908      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq909      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
bmq910      varchar2(20),            /*主特性代码                             */
                                     /*使用者自行定義                         */
bmqacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
bmquser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
bmqgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
bmqmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
bmqdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
bmqud01     varchar2(255),           /*自订字段-Textedit                      */
bmqud02     varchar2(40),            /*自订字段-文字                          */
bmqud03     varchar2(40),            /*自订字段-文字                          */
bmqud04     varchar2(40),            /*自订字段-文字                          */
bmqud05     varchar2(40),            /*自订字段-文字                          */
bmqud06     varchar2(40),            /*自订字段-文字                          */
bmqud07     number(15,3),            /*自订字段-数值                          */
bmqud08     number(15,3),            /*自订字段-数值                          */
bmqud09     number(15,3),            /*自订字段-数值                          */
bmqud10     number(10),              /*自订字段-整数                          */
bmqud11     number(10),              /*自订字段-整数                          */
bmqud12     number(10),              /*自订字段-整数                          */
bmqud13     date,                    /*自订字段-日期                          */
bmqud14     date,                    /*自订字段-日期                          */
bmqud15     date,                    /*自订字段-日期                          */
bmqoriu     varchar2(10),            /*资料建立者                             */
bmqorig     varchar2(10)             /*资料建立部门                           */
);

alter table bmq_file add  constraint bmq_pk primary key  (bmq01) enable validate;
grant select on bmq_file to tiptopgp;
grant update on bmq_file to tiptopgp;
grant delete on bmq_file to tiptopgp;
grant insert on bmq_file to tiptopgp;
grant index on bmq_file to public;
grant select on bmq_file to ods;
