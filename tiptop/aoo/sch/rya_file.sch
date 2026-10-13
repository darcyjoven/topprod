/*
================================================================================
檔案代號:rya_file
檔案名稱:省别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rya_file
(
rya01       varchar2(10) DEFAULT ' ' NOT NULL, /*省别编号*/
rya02       varchar2(80),            /*省别名称                               */
rya03       varchar2(10),            /*隶属地区                               */
ryaacti     varchar2(1),             /*资料有效码                             */
ryacrat     date,                    /*资料创建日                             */
ryadate     date,                    /*最近更改日                             */
ryagrup     varchar2(10),            /*资料所有部门                           */
ryamodu     varchar2(10),            /*资料更改者                             */
ryauser     varchar2(10),            /*资料所有者                             */
ryaorig     varchar2(10),            /*资料建立部门                           */
ryaoriu     varchar2(10)             /*资料建立者                             */
);

alter table rya_file add  constraint rya_pk primary key  (rya01) enable validate;
grant select on rya_file to tiptopgp;
grant update on rya_file to tiptopgp;
grant delete on rya_file to tiptopgp;
grant insert on rya_file to tiptopgp;
grant index on rya_file to public;
grant select on rya_file to ods;
