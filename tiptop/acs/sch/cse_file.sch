/*
================================================================================
檔案代號:cse_file
檔案名稱:附加成本--料件成本项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cse_file
(
cse01       varchar2(40) NOT NULL,   /*料件编号                               */
cse02       varchar2(10) NOT NULL,   /*成本项目                               */
cse03       varchar2(10) NOT NULL    /*比率成本项目                           */
);

alter table cse_file add  constraint cse_pk primary key  (cse01,cse02,cse03) enable validate;
grant select on cse_file to tiptopgp;
grant update on cse_file to tiptopgp;
grant delete on cse_file to tiptopgp;
grant insert on cse_file to tiptopgp;
grant index on cse_file to public;
grant select on cse_file to ods;
