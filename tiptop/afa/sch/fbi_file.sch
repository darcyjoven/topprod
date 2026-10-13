/*
================================================================================
檔案代號:fbi_file
檔案名稱:部门折旧费用科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fbi_file
(
fbi01       varchar2(10) NOT NULL,   /*部门编号                               */
fbi02       varchar2(24),            /*折旧费用科目编号                       */
fbi03       varchar2(10) NOT NULL,   /*资产类型                               */
fbiacti     varchar2(1),             /*资料有效码                             */
fbiuser     varchar2(10),            /*资料所有者                             */
fbigrup     varchar2(10),            /*资料所有群                             */
fbimodu     varchar2(10),            /*资料更改者                             */
fbidate     date,                    /*最近更改日                             */
fbi021      varchar2(24),            /*折旧费用科目编号二                     */
fbiorig     varchar2(10),            /*资料建立部门                           */
fbioriu     varchar2(10)             /*资料建立者                             */
);

alter table fbi_file add  constraint fbi_pk primary key  (fbi01,fbi03) enable validate;
grant select on fbi_file to tiptopgp;
grant update on fbi_file to tiptopgp;
grant delete on fbi_file to tiptopgp;
grant insert on fbi_file to tiptopgp;
grant index on fbi_file to public;
grant select on fbi_file to ods;
