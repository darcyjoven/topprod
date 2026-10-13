/*
================================================================================
檔案代號:vnj_file
檔案名稱:APS工模具主档维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vnj_file
(
vnj01       varchar2(60) NOT NULL,   /*工模具编号                             */
vnj02       date,                    /*生效日                                 */
vnj03       date                     /*失效日                                 */
);

alter table vnj_file add  constraint vnj_pk primary key  (vnj01) enable validate;
grant select on vnj_file to tiptopgp;
grant update on vnj_file to tiptopgp;
grant delete on vnj_file to tiptopgp;
grant insert on vnj_file to tiptopgp;
grant index on vnj_file to public;
grant select on vnj_file to ods;
