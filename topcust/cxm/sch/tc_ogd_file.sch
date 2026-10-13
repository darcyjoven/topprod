/*
================================================================================
檔案代號:tc_ogd_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ogd_file
(
tc_ogd01    varchar2(20) NOT NULL,   /*出货单号                               */
tc_ogd02    number(5) NOT NULL,      /*项次                                   */
tc_ogd03    number(5) NOT NULL,      /*包装明细项次                           */
tc_ogd04    varchar2(40),            /*出货料件编号                           */
tc_ogd05    varchar2(40),            /*客户料件编号                           */
tc_ogd06    varchar2(40),            /*代工厂料件编号                         */
tc_ogd07    number(5),               /*总箱数                                 */
tc_ogd08    number(10),              /*本箱数                                 */
tc_ogd09    number(15,3),            /*本箱包装量                             */
tc_ogd10    varchar2(24),            /*生产批次号                             */
tc_ogd11    date,                    /*出货日期                               */
tc_ogdud01  varchar2(255),           /*自订字段-Textedit                      */
tc_ogdud02  varchar2(40),            /*自订字段-文字                          */
tc_ogdud03  varchar2(40),            /*自订字段-文字                          */
tc_ogdud04  varchar2(40),            /*自订字段-文字                          */
tc_ogdud05  varchar2(40),            /*自订字段-文字                          */
tc_ogdud06  varchar2(40),            /*自订字段-文字                          */
tc_ogdud07  number(15,3),            /*自订字段-数值                          */
tc_ogdud08  number(15,3),            /*自订字段-数值                          */
tc_ogdud09  number(15,3),            /*自订字段-数值                          */
tc_ogdud10  number(10),              /*自订字段-整数                          */
tc_ogdud11  number(10),              /*自订字段-整数                          */
tc_ogdud12  number(10),              /*自订字段-整数                          */
tc_ogdud13  date,                    /*自订字段-日期                          */
tc_ogdud14  date,                    /*自订字段-日期                          */
tc_ogdud15  date,                    /*自订字段-日期                          */
tc_ogdplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_ogdlegal varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tc_ogd_file add  constraint tpc_ogd_pk primary key  (tc_ogd01,tc_ogd02,tc_ogd03) enable validate;
grant select on tc_ogd_file to tiptopgp;
grant update on tc_ogd_file to tiptopgp;
grant delete on tc_ogd_file to tiptopgp;
grant insert on tc_ogd_file to tiptopgp;
grant index on tc_ogd_file to public;
grant select on tc_ogd_file to ods;
