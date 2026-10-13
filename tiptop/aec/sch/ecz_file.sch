/*
================================================================================
檔案代號:ecz_file
檔案名稱:作业资料说明说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecz_file
(
ecz01       varchar2(6) NOT NULL,    /*作业编号                               */
ecz02       date NOT NULL,           /*No Use                                 */
ecz04       number(5) NOT NULL,      /*行序号                                 */
ecz05       varchar2(80)             /*说明                                   */
);

alter table ecz_file add  constraint ecz_pk primary key  (ecz01,ecz02,ecz04) enable validate;
grant select on ecz_file to tiptopgp;
grant update on ecz_file to tiptopgp;
grant delete on ecz_file to tiptopgp;
grant insert on ecz_file to tiptopgp;
grant index on ecz_file to public;
grant select on ecz_file to ods;
