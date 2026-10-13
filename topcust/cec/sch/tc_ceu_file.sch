/*
================================================================================
檔案代號:tc_ceu_file
檔案名稱:製程資料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ceu_file
(
tc_ceu01    varchar2(40) NOT NULL,   /*料件編號                               */
tc_ceu02    varchar2(10) NOT NULL,   /*製程編號                               */
tc_ceu03    varchar2(255),           /*備註                                   */
tc_ceu04    number(5),               /*起始製程序號                           */
tc_ceu05    number(5),               /*截止製程序號                           */
tc_ceu06    varchar2(1),             /*No Use                                 */
tc_ceu07    varchar2(1),             /*No Use                                 */
tc_ceu08    varchar2(1),             /*No Use                                 */
tc_ceu09    varchar2(1),             /*No Use                                 */
tc_ceuacti  varchar2(1),             /*資料有效碼                             */
tc_ceuuser  varchar2(10),            /*資料所有者                             */
tc_ceugrup  varchar2(10),            /*資料所有群                             */
tc_ceumodu  varchar2(10),            /*資料更改者                             */
tc_ceudate  date,                    /*最近修改日                             */
tc_ceu10    varchar2(1) DEFAULT ' ' NOT NULL, /*審核碼*/
tc_ceu11    number(5),               /*變更序號                               */
tc_ceuud01  varchar2(255),           /*自訂欄位-Textedit                      */
tc_ceuud02  varchar2(40),            /*自訂欄位-文字                          */
tc_ceuud03  varchar2(40),            /*自訂欄位-文字                          */
tc_ceuud04  varchar2(40),            /*自訂欄位-文字                          */
tc_ceuud05  varchar2(40),            /*自訂欄位-文字                          */
tc_ceuud06  varchar2(40),            /*自訂欄位-文字                          */
tc_ceuud07  number(15,3),            /*自訂欄位-數值                          */
tc_ceuud08  number(15,3),            /*自訂欄位-數值                          */
tc_ceuud09  number(15,3),            /*自訂欄位-數值                          */
tc_ceuud10  number(10),              /*自訂欄位-整數                          */
tc_ceuud11  number(10) NOT NULL,     /*变更版次序号                           */
tc_ceuud12  number(10),              /*自訂欄位-整數                          */
tc_ceuud13  date,                    /*自訂欄位-日期                          */
tc_ceuud14  date,                    /*自訂欄位-日期                          */
tc_ceuud15  date,                    /*自訂欄位-日期                          */
tc_ceuoriu  varchar2(10),            /*資料建立者                             */
tc_ceuorig  varchar2(10),            /*資料建立部門                           */
tc_ceu012   varchar2(10) DEFAULT ' ' NOT NULL, /*製程段號*/
tc_ceu014   varchar2(80),            /*製程段說明                             */
tc_ceu015   varchar2(10)             /*下製程段號                             */
);

alter table tc_ceu_file add  constraint tpc_ceu_pk primary key  (tc_ceu01,tc_ceu02,tc_ceu012,tc_ceuud11) enable validate;
grant select on tc_ceu_file to tiptopgp;
grant update on tc_ceu_file to tiptopgp;
grant delete on tc_ceu_file to tiptopgp;
grant insert on tc_ceu_file to tiptopgp;
grant index on tc_ceu_file to public;
grant select on tc_ceu_file to ods;
