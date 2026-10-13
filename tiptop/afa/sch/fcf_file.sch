/*
================================================================================
檔案代號:fcf_file
檔案名稱:资产解除设置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcf_file
(
fcf01       varchar2(30) NOT NULL,   /*解除文号                               */
fcf02       date,                    /*解除日期                               */
fcf03       varchar2(20),            /*申请编号                               */
fcf04       number(20,6),            /*解除金额                               */
fcfconf     varchar2(1),             /*确认码                                 */
fcfprsw     number(5),               /*打印次数                               */
fcfuser     varchar2(10),            /*资料所有者                             */
fcfgrup     varchar2(10),            /*资料所有群                             */
fcfmodu     varchar2(10),            /*资料更改者                             */
fcfdate     date,                    /*最近更改日                             */
fcflegal    varchar2(10) NOT NULL,   /*所属法人                               */
fcforig     varchar2(10),            /*资料建立部门                           */
fcforiu     varchar2(10)             /*资料建立者                             */
);

alter table fcf_file add  constraint fcf_pk primary key  (fcf01) enable validate;
grant select on fcf_file to tiptopgp;
grant update on fcf_file to tiptopgp;
grant delete on fcf_file to tiptopgp;
grant insert on fcf_file to tiptopgp;
grant index on fcf_file to public;
grant select on fcf_file to ods;
