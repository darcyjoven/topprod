/*
================================================================================
檔案代號:apw_file
檔案名稱:付款单贷方常用会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apw_file
(
apw01       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
apw02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
apw03       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
apw031      varchar2(24)             /*会计科目二                             */
);

alter table apw_file add  constraint apw_pk primary key  (apw01) enable validate;
grant select on apw_file to tiptopgp;
grant update on apw_file to tiptopgp;
grant delete on apw_file to tiptopgp;
grant insert on apw_file to tiptopgp;
grant index on apw_file to public;
grant select on apw_file to ods;
