/*
================================================================================
檔案代號:csg_file
檔案名稱:附加成本--料件分群码成本项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table csg_file
(
csg01       varchar2(10) NOT NULL,   /*料件分群码                             */
csg02       varchar2(10) NOT NULL,   /*成本项目                               */
csg03       varchar2(10) NOT NULL    /*比率成本项目                           */
);

alter table csg_file add  constraint csg_pk primary key  (csg01,csg02,csg03) enable validate;
grant select on csg_file to tiptopgp;
grant update on csg_file to tiptopgp;
grant delete on csg_file to tiptopgp;
grant insert on csg_file to tiptopgp;
grant index on csg_file to public;
grant select on csg_file to ods;
