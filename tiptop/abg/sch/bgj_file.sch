/*
================================================================================
檔案代號:bgj_file
檔案名稱:收款方式档 (Payment Term Code File)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgj_file
(
bgj01       varchar2(10) NOT NULL,   /*版本                                   */
bgj02       varchar2(10) NOT NULL,   /*收款条件                               */
                                     /*收款條件                               */
bgj03       varchar2(80),            /*收款说明                               */
                                     /*收款說明                               */
bgj04       number(9,4),             /*占百分比                               */
bgj05       varchar2(1)              /*No Use                                 */
);

alter table bgj_file add  constraint bgj_pk primary key  (bgj01,bgj02) enable validate;
grant select on bgj_file to tiptopgp;
grant update on bgj_file to tiptopgp;
grant delete on bgj_file to tiptopgp;
grant insert on bgj_file to tiptopgp;
grant index on bgj_file to public;
grant select on bgj_file to ods;
