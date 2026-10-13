/*
================================================================================
檔案代號:ged_file
檔案名稱:交运方式维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ged_file
(
ged01       varchar2(10) NOT NULL,   /*交运方式                               */
                                     /*交運方式                               */
ged02       varchar2(80)             /*交运方式说明                           */
                                     /*交運方式說明                           */
);

alter table ged_file add  constraint ged_pk primary key  (ged01) enable validate;
grant select on ged_file to tiptopgp;
grant update on ged_file to tiptopgp;
grant delete on ged_file to tiptopgp;
grant insert on ged_file to tiptopgp;
grant index on ged_file to public;
grant select on ged_file to ods;
