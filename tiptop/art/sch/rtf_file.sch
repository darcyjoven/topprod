/*
================================================================================
檔案代號:rtf_file
檔案名稱:价格策略单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rtf_file
(
rtf01       varchar2(10) DEFAULT ' ' NOT NULL, /*价格策略代码*/
rtf02       varchar2(40),            /*价格策略名称                           */
rtf03       varchar2(10),            /*制定營運中心                           */
rtf04       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
rtf05       varchar2(255),           /*備注                                   */
rtfacti     varchar2(1),             /*资料有效码                             */
rtfcond     date,                    /*审核日期                               */
rtfconf     varchar2(1),             /*审核码                                 */
rtfconu     varchar2(10),            /*审核人员                               */
rtfcrat     date,                    /*资料创建日                             */
rtfdate     date,                    /*最近更改日                             */
rtfgrup     varchar2(10),            /*资料所有部门                           */
rtfmodu     varchar2(10),            /*资料更改者                             */
rtfuser     varchar2(10),            /*资料所有者                             */
rtforiu     varchar2(10),            /*资料建立者                             */
rtforig     varchar2(10)             /*资料建立部门                           */
);

alter table rtf_file add  constraint rtf_pk primary key  (rtf01) enable validate;
grant select on rtf_file to tiptopgp;
grant update on rtf_file to tiptopgp;
grant delete on rtf_file to tiptopgp;
grant insert on rtf_file to tiptopgp;
grant index on rtf_file to public;
grant select on rtf_file to ods;
