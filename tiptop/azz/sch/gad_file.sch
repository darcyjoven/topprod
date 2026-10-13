/*
================================================================================
檔案代號:gad_file
檔案名稱:目录暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gad_file
(
gad01       varchar2(10) NOT NULL,   /*用戶名稱                               */
gad02       varchar2(10) NOT NULL,   /*目錄編號                               */
gad03       number(5) NOT NULL,      /*序號                                   */
gad04       varchar2(20)             /*程序編號                               */
);

alter table gad_file add  constraint gad_pk primary key  (gad01,gad02,gad03) enable validate;
grant select on gad_file to tiptopgp;
grant update on gad_file to tiptopgp;
grant delete on gad_file to tiptopgp;
grant insert on gad_file to tiptopgp;
grant index on gad_file to public;
grant select on gad_file to ods;
