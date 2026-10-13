/*
================================================================================
檔案代號:bma_file
檔案名稱:产品结构主件资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bma_file
(
bma01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
                                     /*儲存該產品結構組合的主件料件編號。     */
                                     /*主件料件編號需在料件基本資料主檔中。   */
bma02       varchar2(20),            /*最后工程变异单单号                     */
                                     /*最後工程變異單單號                     */
                                     /*儲存該產品結構組合的最近一次工程變異單 */
                                     /*（ECN）單號。                          */
                                     /*系統維護。                             */
bma03       date,                    /*最近工程变异日期                       */
                                     /*最近工程變異日期                       */
                                     /*儲存該產品結構組合的最近一次工程變異日 */
                                     /*期。                                   */
                                     /*系統維護。                             */
bma04       varchar2(10),            /*组合模式参考编号                       */
                                     /*組合模式參考編號                       */
                                     /*儲存該產品結構組合的分類模式代號。     */
                                     /*使用者可自行定義  如 1001-電焊車架。   */
bma05       date,                    /*发放日期                               */
                                     /*發放日期  010507 add No.B474           */
                                     /*有發放日期,工單及ECN才可使用           */
bmauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護。                             */
bmagrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護。                             */
bmamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護。                             */
bmadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護。                             */
bmaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護。                             */
bma06       varchar2(20) NOT NULL,   /*特性代码                               */
bma07       varchar2(1),             /*配方否                                 */
bmaicd01    varchar2(40),            /*来源单号                               */
bma08       varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
bma09       number(10),              /*抛转次数                               */
bma10       varchar2(1) DEFAULT ' ' NOT NULL, /*状态码*/
bmaud01     varchar2(255),           /*自订字段-Textedit                      */
bmaud02     varchar2(40),            /*工艺发料编号                           */
bmaud03     varchar2(40),            /*自订字段-文字                          */
bmaud04     varchar2(40),            /*自订字段-文字                          */
bmaud05     varchar2(40),            /*自订字段-文字                          */
bmaud06     varchar2(40),            /*自订字段-文字                          */
bmaud07     number(15,3),            /*自订字段-数值                          */
bmaud08     number(15,3),            /*自订字段-数值                          */
bmaud09     number(15,3),            /*自订字段-数值                          */
bmaud10     number(10),              /*自订字段-整数                          */
bmaud11     number(10),              /*自订字段-整数                          */
bmaud12     number(10),              /*自订字段-整数                          */
bmaud13     date,                    /*自订字段-日期                          */
bmaud14     date,                    /*自订字段-日期                          */
bmaud15     date,                    /*自订字段-日期                          */
bmaoriu     varchar2(10),            /*资料建立者                             */
bmaorig     varchar2(10)             /*资料建立部门                           */
);

alter table bma_file add  constraint bma_pk primary key  (bma01,bma06) enable validate;
grant select on bma_file to tiptopgp;
grant update on bma_file to tiptopgp;
grant delete on bma_file to tiptopgp;
grant insert on bma_file to tiptopgp;
grant index on bma_file to public;
grant select on bma_file to ods;
