/*
================================================================================
檔案代號:pjo_file
檔案名稱:项目多阶段收付款主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjo_file
(
pjo01       varchar2(10) NOT NULL,   /*项目编号                               */
pjo02       varchar2(1) NOT NULL,    /*收/付款                                */
pjoacti     varchar2(1),             /*资料有效码                             */
pjoconf     varchar2(1),             /*确认码                                 */
pjodate     date,                    /*最近更改日                             */
pjogrup     varchar2(10),            /*资料所有部门                           */
pjomodu     varchar2(10),            /*资料更改者                             */
pjouser     varchar2(10),            /*资料所有者                             */
pjooriu     varchar2(10),            /*资料建立者                             */
pjoorig     varchar2(10)             /*资料建立部门                           */
);

alter table pjo_file add  constraint pjo_pk primary key  (pjo01,pjo02) enable validate;
grant select on pjo_file to tiptopgp;
grant update on pjo_file to tiptopgp;
grant delete on pjo_file to tiptopgp;
grant insert on pjo_file to tiptopgp;
grant index on pjo_file to public;
grant select on pjo_file to ods;
