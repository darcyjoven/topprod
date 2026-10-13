/*
================================================================================
檔案代號:fai_file
檔案名稱:常用摘要名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fai_file
(
fai01       varchar2(4) NOT NULL,    /*常用摘要编号                           */
fai02       varchar2(80),            /*常用摘要                               */
faiacti     varchar2(1),             /*资料有效码                             */
faiuser     varchar2(10),            /*资料所有者                             */
faigrup     varchar2(10),            /*资料所有群                             */
faimodu     varchar2(10),            /*资料更改者                             */
faidate     date,                    /*最近更改日                             */
faiorig     varchar2(10),            /*资料建立部门                           */
faioriu     varchar2(10)             /*资料建立者                             */
);

alter table fai_file add  constraint fai_pk primary key  (fai01) enable validate;
grant select on fai_file to tiptopgp;
grant update on fai_file to tiptopgp;
grant delete on fai_file to tiptopgp;
grant insert on fai_file to tiptopgp;
grant index on fai_file to public;
grant select on fai_file to ods;
