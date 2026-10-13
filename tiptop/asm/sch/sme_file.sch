/*
================================================================================
檔案代號:sme_file
檔案名稱:工作行事历资料档    MANUFACTURE DATE
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sme_file
(
sme01       date NOT NULL,           /*工作日                                 */
                                     /*manufacture date                       */
sme02       varchar2(1)              /*工作日否                               */
                                     /*只能輸入 Y / N                         */
);

alter table sme_file add  constraint sme_pk primary key  (sme01) enable validate;
grant select on sme_file to tiptopgp;
grant update on sme_file to tiptopgp;
grant delete on sme_file to tiptopgp;
grant insert on sme_file to tiptopgp;
grant index on sme_file to public;
grant select on sme_file to ods;
