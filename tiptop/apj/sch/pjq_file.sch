/*
================================================================================
檔案代號:pjq_file
檔案名稱:项目分类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjq_file
(
pjq01       varchar2(4) NOT NULL,    /*分类编号                               */
pjq02       varchar2(80),            /*分类名称                               */
pjqacti     varchar2(1),             /*资料有效码                             */
pjqdate     date,                    /*最近更改日                             */
pjqgrup     varchar2(10),            /*资料所有部门                           */
pjqmodu     varchar2(10),            /*资料更改者                             */
pjquser     varchar2(10),            /*资料所有者                             */
pjqorig     varchar2(10),            /*资料建立部门                           */
pjqoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjq_file add  constraint pjq_pk primary key  (pjq01) enable validate;
grant select on pjq_file to tiptopgp;
grant update on pjq_file to tiptopgp;
grant delete on pjq_file to tiptopgp;
grant insert on pjq_file to tiptopgp;
grant index on pjq_file to public;
grant select on pjq_file to ods;
