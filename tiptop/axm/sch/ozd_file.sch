/*
================================================================================
檔案代號:ozd_file
檔案名稱:航/海运状态说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ozd_file
(
ozd01       varchar2(1) NOT NULL,    /*类型                                   */
ozd02       varchar2(2) NOT NULL,    /*检核点                                 */
ozd03       varchar2(80)             /*检核点说明                             */
);

alter table ozd_file add  constraint ozd_pk primary key  (ozd01,ozd02) enable validate;
grant select on ozd_file to tiptopgp;
grant update on ozd_file to tiptopgp;
grant delete on ozd_file to tiptopgp;
grant insert on ozd_file to tiptopgp;
grant index on ozd_file to public;
grant select on ozd_file to ods;
