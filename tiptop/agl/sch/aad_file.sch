/*
================================================================================
檔案代號:aad_file
檔案名稱:常用摘要名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aad_file
(
aad01       varchar2(4) NOT NULL,    /*常用摘要编号                           */
aad02       varchar2(80),            /*常用摘要                               */
aadacti     varchar2(1),             /*资料有效码                             */
aaduser     varchar2(10),            /*资料所有者                             */
aadgrup     varchar2(10),            /*资料所有群                             */
aadmodu     varchar2(10),            /*资料更改者                             */
aaddate     date,                    /*最近更改日                             */
aadorig     varchar2(10),            /*资料建立部门                           */
aadoriu     varchar2(10)             /*资料建立者                             */
);

alter table aad_file add  constraint aad_pk primary key  (aad01) enable validate;
grant select on aad_file to tiptopgp;
grant update on aad_file to tiptopgp;
grant delete on aad_file to tiptopgp;
grant insert on aad_file to tiptopgp;
grant index on aad_file to public;
grant select on aad_file to ods;
