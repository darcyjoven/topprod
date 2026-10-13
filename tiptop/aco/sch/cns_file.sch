/*
================================================================================
檔案代號:cns_file
檔案名稱:新贸加工合同核销单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cns_file
(
cns00       varchar2(20) NOT NULL,   /*核销单号                               */
cns01       varchar2(20),            /*核销手册编号                           */
cns02       varchar2(20),            /*转入手册编号                           */
cns03       date,                    /*核销日期                               */
cns04       varchar2(1),             /*No Use                                 */
cnsconf     varchar2(1),             /*确认码                                 */
cnsacti     varchar2(1),             /*资料有效码                             */
cnsuser     varchar2(10),            /*资料所有者                             */
cnsgrup     varchar2(10),            /*资料所有部门                           */
cnsmodu     varchar2(10),            /*资料更改者                             */
cnsdate     date,                    /*最近更改日                             */
cnsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnslegal    varchar2(10) NOT NULL,   /*所属法人                               */
cnsoriu     varchar2(10),            /*资料建立者                             */
cnsorig     varchar2(10)             /*资料建立部门                           */
);

create unique index cns_02 on cns_file (cns01);
alter table cns_file add  constraint cns_pk primary key  (cns00) enable validate;
grant select on cns_file to tiptopgp;
grant update on cns_file to tiptopgp;
grant delete on cns_file to tiptopgp;
grant insert on cns_file to tiptopgp;
grant index on cns_file to public;
grant select on cns_file to ods;
