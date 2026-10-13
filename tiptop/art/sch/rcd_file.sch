/*
================================================================================
檔案代號:rcd_file
檔案名稱:百货公司核算资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rcd_file
(
rcd01       varchar2(20) DEFAULT ' ' NOT NULL, /*百货公司核算单号*/
rcd02       date,                    /*销售日期                               */
rcd03       varchar2(255),           /*备注                                   */
rcd04       varchar2(1) DEFAULT ' ' NOT NULL, /*核算金额含税否*/
rcdacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rcdcond     date,                    /*审核日期                               */
rcdconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
rcdcont     varchar2(8),             /*审核时间                               */
rcdconu     varchar2(10),            /*审核人员                               */
rcdcrat     date,                    /*资料创建日                             */
rcddate     date,                    /*最近更改日                             */
rcdgrup     varchar2(10),            /*资料所有群                             */
rcdlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rcdmodu     varchar2(10),            /*资料更改者                             */
rcdorig     varchar2(10),            /*资料建立部门                           */
rcdoriu     varchar2(10),            /*资料建立者                             */
rcdplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
rcduser     varchar2(10)             /*资料所有者                             */
);

alter table rcd_file add  constraint rcd_pk primary key  (rcd01) enable validate;
grant select on rcd_file to tiptopgp;
grant update on rcd_file to tiptopgp;
grant delete on rcd_file to tiptopgp;
grant insert on rcd_file to tiptopgp;
grant index on rcd_file to public;
grant select on rcd_file to ods;
