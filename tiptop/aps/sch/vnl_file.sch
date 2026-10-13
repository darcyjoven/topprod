/*
================================================================================
檔案代號:vnl_file
檔案名稱:APS工模具群组明细维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vnl_file
(
vnl01       varchar2(60) NOT NULL,   /*工模具群组编号                         */
vnl02       varchar2(60) NOT NULL    /*工模具大类编号                         */
);

alter table vnl_file add  constraint vnl_pk primary key  (vnl01,vnl02) enable validate;
grant select on vnl_file to tiptopgp;
grant update on vnl_file to tiptopgp;
grant delete on vnl_file to tiptopgp;
grant insert on vnl_file to tiptopgp;
grant index on vnl_file to public;
grant select on vnl_file to ods;
