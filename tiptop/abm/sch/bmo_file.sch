/*
================================================================================
檔案代號:bmo_file
檔案名稱:产品结构主件资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmo_file
(
bmo01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bmo011      varchar2(10) NOT NULL,   /*版本                                   */
                                     /*版本   add in 99/12/30                 */
bmo02       varchar2(20),            /*最后工程变异单单号                     */
                                     /*最後工程變異單單號                     */
                                     /*儲存該產品結構組合的最近一次工程變異單 */
                                     /*（ECN）單號。                          */
                                     /*系統維護。                             */
bmo03       date,                    /*最近工程变异日期                       */
                                     /*最近工程變異日期                       */
                                     /*儲存該產品結構組合的最近一次工程變異日 */
                                     /*期。                                   */
                                     /*系統維護。                             */
bmo04       varchar2(10),            /*组合模式参考编号                       */
                                     /*組合模式參考編號                       */
                                     /*儲存該產品結構組合的分類模式代號。     */
                                     /*使用者可自行定義  如 1001-電焊車架。   */
bmo05       date,                    /*生效日期                               */
bmouser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護。                             */
bmogrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護。                             */
bmomodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護。                             */
bmodate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護。                             */
bmoacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護。                             */
bmo06       varchar2(20) NOT NULL,   /*特性代码                               */
bmoud01     varchar2(255),           /*自订字段-Textedit                      */
bmoud02     varchar2(40),            /*项目编号                               */
bmoud03     varchar2(40),            /*自订字段-文字                          */
bmoud04     varchar2(40),            /*自订字段-文字                          */
bmoud05     varchar2(40),            /*自订字段-文字                          */
bmoud06     varchar2(40),            /*自订字段-文字                          */
bmoud07     number(15,3),            /*自订字段-数值                          */
bmoud08     number(15,3),            /*自订字段-数值                          */
bmoud09     number(15,3),            /*自订字段-数值                          */
bmoud10     number(10),              /*自订字段-整数                          */
bmoud11     number(10),              /*自订字段-整数                          */
bmoud12     number(10),              /*自订字段-整数                          */
bmoud13     date,                    /*自订字段-日期                          */
bmoud14     date,                    /*自订字段-日期                          */
bmoud15     date,                    /*自订字段-日期                          */
bmooriu     varchar2(10),            /*资料建立者                             */
bmoorig     varchar2(10)             /*资料建立部门                           */
);

alter table bmo_file add  constraint bmo_pk primary key  (bmo01,bmo011,bmo06) enable validate;
grant select on bmo_file to tiptopgp;
grant update on bmo_file to tiptopgp;
grant delete on bmo_file to tiptopgp;
grant insert on bmo_file to tiptopgp;
grant index on bmo_file to public;
grant select on bmo_file to ods;
