/*
================================================================================
檔案代號:tc_shc_file
檔案名稱:接收/转出明细表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_shc_file
(
tc_shc01    varchar2(1) NOT NULL,    /*资料性质                               */
tc_shc02    varchar2(20) NOT NULL,   /*单据编号                               */
tc_shc03    varchar2(20),            /*LOT单号                                */
tc_shc04    varchar2(20),            /*工单单号                               */
tc_shc05    varchar2(40),            /*生产料号                               */
tc_shc06    number(5),               /*工艺序号                               */
tc_shc07    varchar2(6),             /*工艺编号                               */
tc_shc08    varchar2(80),            /*作业编号                               */
tc_shc09    varchar2(10),            /*工作站编号                             */
tc_shc10    varchar2(1),             /*委外否                                 */
tc_shc11    varchar2(10),            /*人员编号                               */
tc_shc12    number(15,3),            /*数量                                   */
tc_shc13    varchar2(8),             /*线班别                                 */
tc_shc14    date,                    /*单据日期                               */
tc_shc15    varchar2(8),             /*单据时间                               */
tc_shc16    varchar2(4),             /*生产单位                               */
tc_shc17    varchar2(20),            /*备用                                   */
tc_shc18    varchar2(20),            /*备用                                   */
tc_shcud01  varchar2(255),           /*自定义字段                             */
tc_shcud02  varchar2(40),            /*自定义字段                             */
tc_shcud03  varchar2(40),            /*自定义字段                             */
tc_shcud04  varchar2(40),            /*自定义字段                             */
tc_shcud05  date,                    /*自定义字段                             */
tc_shcud06  date,                    /*自定义字段                             */
tc_shcud07  number(10),              /*自定义字段                             */
tc_shcud08  number(10),              /*自定义字段                             */
tc_shcud09  number(15,3),            /*自定义字段                             */
tc_shcud10  number(15,3)             /*自定义字段                             */
);

alter table tc_shc_file add  constraint tpc_shc_pk primary key  (tc_shc02) enable validate;
grant select on tc_shc_file to tiptopgp;
grant update on tc_shc_file to tiptopgp;
grant delete on tc_shc_file to tiptopgp;
grant insert on tc_shc_file to tiptopgp;
grant index on tc_shc_file to public;
grant select on tc_shc_file to ods;
