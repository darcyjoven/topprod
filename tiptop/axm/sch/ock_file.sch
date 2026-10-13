/*
================================================================================
檔案代號:ock_file
檔案名稱:客诉原因代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ock_file
(
ock01       varchar2(10) NOT NULL,   /*客诉原因代码                           */
                                     /*客訴原因代碼                           */
ock02       varchar2(80),            /*原因说明                               */
                                     /*原因說明                               */
ockacti     varchar2(1),             /*资料有效码                             */
ockuser     varchar2(10),            /*资料所有者                             */
ockgrup     varchar2(10),            /*资料所有群                             */
ockmodu     varchar2(10),            /*资料更改者                             */
ockdate     date,                    /*最近更改日                             */
ockorig     varchar2(10),            /*资料建立部门                           */
ockoriu     varchar2(10)             /*资料建立者                             */
);

alter table ock_file add  constraint ock_pk primary key  (ock01) enable validate;
grant select on ock_file to tiptopgp;
grant update on ock_file to tiptopgp;
grant delete on ock_file to tiptopgp;
grant insert on ock_file to tiptopgp;
grant index on ock_file to public;
grant select on ock_file to ods;
