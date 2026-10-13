/*
================================================================================
檔案代號:tc_cca_file
檔案名稱:库存期初金额OPEN资料文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tc_cca_file
(
tc_cca01    varchar2(40) NOT NULL,   /*料号                                   */
tc_cca02    number(5) NOT NULL,      /*年度                                   */
tc_cca03    number(5) NOT NULL,      /*月份                                   */
tc_cca04    varchar2(255),           /*备注                                   */
tc_cca11    number(15,3),            /*当月期末数量                           */
tc_cca12    number(20,6),            /*当月期末金额                           */
tc_cca12a   number(20,6),            /*当月期末金额-材料                      */
tc_cca12b   number(20,6),            /*当月期末金额-人工                      */
tc_cca12c   number(20,6),            /*当月期末金额-制费                      */
tc_cca12d   number(20,6),            /*当月期末金额-加工                      */
tc_cca12e   number(20,6),            /*当月期末金额-其他                      */
tc_cca23    number(20,6),            /*当月平均单价(a+b+c+d+e)                */
tc_cca23a   number(20,6),            /*当月平均单价-材料   (a)                */
tc_cca23b   number(20,6),            /*当月平均单价-人工   (b)                */
tc_cca23c   number(20,6),            /*当月平均单价-制费   (c)                */
tc_cca23d   number(20,6),            /*当月平均单价-加工   (d)                */
tc_cca23e   number(20,6),            /*当月平均单价-其他   (e)                */
tc_ccaacti  varchar2(1),             /*数据有效码                             */
tc_ccauser  varchar2(10),            /*数据所有者                             */
tc_ccagrup  varchar2(10),            /*数据所有部门                           */
tc_ccamodu  varchar2(10),            /*数据修改者                             */
tc_ccadate  date,                    /*最近修改日                             */
tc_cca06    varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类别*/
tc_cca07    varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/项目号/利润 */
tc_cca12f   number(20,6) DEFAULT '0',/*当月期末金额-制费三                    */
tc_cca12g   number(20,6) DEFAULT '0',/*当月期末金额-制费四                    */
tc_cca12h   number(20,6) DEFAULT '0',/*当月期末金额-制费五                    */
tc_cca23f   number(20,6) DEFAULT '0',/*当月平均单价-制费三                    */
tc_cca23g   number(20,6) DEFAULT '0',/*当月平均单价-制费四                    */
tc_cca23h   number(20,6) DEFAULT '0',/*当月平均单价-制费五                    */
tc_ccaud01  varchar2(255),           /*自定义字段-Textedit                    */
tc_ccaud02  varchar2(40),            /*自定义字段-文字                        */
tc_ccaud03  varchar2(40),            /*自定义字段-文字                        */
tc_ccaud04  varchar2(40),            /*自定义字段-文字                        */
tc_ccaud05  varchar2(40),            /*自定义字段-文字                        */
tc_ccaud06  varchar2(40),            /*自定义字段-文字                        */
tc_ccaud07  number(15,3),            /*自定义字段-数值                        */
tc_ccaud08  number(15,3),            /*自定义字段-数值                        */
tc_ccaud09  number(15,3),            /*自定义字段-数值                        */
tc_ccaud10  number(10),              /*自定义字段-整数                        */
tc_ccaud11  number(10),              /*自定义字段-整数                        */
tc_ccaud12  number(10),              /*自定义字段-整数                        */
tc_ccaud13  date,                    /*自定义字段-日期                        */
tc_ccaud14  date,                    /*自定义字段-日期                        */
tc_ccaud15  date,                    /*自定义字段-日期                        */
tc_ccalegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_ccaoriu  varchar2(10),            /*数据建立者                             */
tc_ccaorig  varchar2(10)             /*数据建立部门                           */
);

alter table tc_cca_file add  constraint tpc_cca_pk primary key  (tc_cca01,tc_cca02,tc_cca03,tc_cca06,tc_cca07) enable validate;
grant select on tc_cca_file to tiptopgp;
grant update on tc_cca_file to tiptopgp;
grant delete on tc_cca_file to tiptopgp;
grant insert on tc_cca_file to tiptopgp;
grant index on tc_cca_file to public;
grant select on tc_cca_file to ods;
