/*
================================================================================
檔案代號:fac_file
檔案名稱:固定资产次类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fac_file
(
fac01       varchar2(10) NOT NULL,   /*次类型码                               */
fac02       varchar2(80),            /*类型名称                               */
facacti     varchar2(1),             /*资料有效码                             */
facuser     varchar2(10),            /*资料所有者                             */
facgrup     varchar2(10),            /*资料所有群                             */
facmodu     varchar2(10),            /*资料更改者                             */
facdate     date,                    /*最近更改日                             */
facorig     varchar2(10),            /*资料建立部门                           */
facoriu     varchar2(10)             /*资料建立者                             */
);

alter table fac_file add  constraint fac_pk primary key  (fac01) enable validate;
grant select on fac_file to tiptopgp;
grant update on fac_file to tiptopgp;
grant delete on fac_file to tiptopgp;
grant insert on fac_file to tiptopgp;
grant index on fac_file to public;
grant select on fac_file to ods;
