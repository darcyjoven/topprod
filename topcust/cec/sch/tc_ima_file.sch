/*
================================================================================
檔案代號:tc_ima_file
檔案名稱:在制LOT清单交接单头表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ima_file
(
tc_ima01    varchar2(40) NOT NULL,   /*交接单号                               */
tc_ima02    varchar2(40),            /*交接人                                 */
tc_ima03    varchar2(20),            /*工作站编号                             */
tc_ima04    date,                    /*交接日期                               */
tc_ima05    varchar2(20),            /*交接班别                               */
tc_ima06    varchar2(40),            /*交接确认人                             */
tc_imaconf  varchar2(1),             /*资料状态码                             */
tc_imauser  varchar2(20),            /*资料所有者                             */
tc_imagrup  varchar2(20),            /*资料所有部门                           */
tc_imamodu  varchar2(20),            /*资料更改者                             */
tc_imadate  date,                    /*最近修改日                             */
tc_imaacti  varchar2(1),             /*资料有效码                             */
tc_imaoriu  varchar2(20),            /*资料建立者                             */
tc_imaorig  varchar2(20),            /*资料建立部门                           */
tc_imaud01  varchar2(255),           /*自定字段                               */
tc_imaud02  varchar2(255),           /*盘点清册                               */
tc_imaud03  varchar2(255),           /*选择类型                               */
tc_imaud04  varchar2(255),           /*自定字段                               */
tc_imaud05  varchar2(255),           /*自定字段                               */
tc_imaud06  varchar2(255),           /*自定字段                               */
tc_imaud07  number(15,3),            /*自定字段                               */
tc_imaud08  number(15,3),            /*自定字段                               */
tc_imaud09  number(15,3),            /*自定字段                               */
tc_imaud10  number(10),              /*自定字段                               */
tc_imaud11  number(10),              /*自定字段                               */
tc_imaud12  number(10),              /*自定字段                               */
tc_imaud13  date,                    /*自定字段                               */
tc_imaud14  date,                    /*自定字段                               */
tc_imaud15  date                     /*自定字段                               */
);

alter table tc_ima_file add  constraint tpc_ima_pk primary key  (tc_ima01) enable validate;
grant select on tc_ima_file to tiptopgp;
grant update on tc_ima_file to tiptopgp;
grant delete on tc_ima_file to tiptopgp;
grant insert on tc_ima_file to tiptopgp;
grant index on tc_ima_file to public;
grant select on tc_ima_file to ods;
