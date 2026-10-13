/*
================================================================================
檔案代號:ict_file
檔案名稱:ICD料件光罩统计资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ict_file
(
ict01       varchar2(40) NOT NULL,   /*光罩料号                               */
ict02       number(5) NOT NULL,      /*年度                                   */
ict03       number(5) NOT NULL,      /*期别                                   */
ict04       number(15,3),            /*前期异动数                             */
ict05       number(15,3),            /*本期异动数                             */
ict06       number(20,6)             /*本期累计余额                           */
);

alter table ict_file add  constraint ict_pk primary key  (ict01,ict02,ict03) enable validate;
grant select on ict_file to tiptopgp;
grant update on ict_file to tiptopgp;
grant delete on ict_file to tiptopgp;
grant insert on ict_file to tiptopgp;
grant index on ict_file to public;
grant select on ict_file to ods;
