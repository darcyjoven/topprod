/*
================================================================================
檔案代號:wpf_file
檔案名稱:采购单预交日异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wpf_file
(
wpf01       varchar2(15) DEFAULT ' ' NOT NULL, /*電子變更序號*/
wpf02       number(5) DEFAULT '0' NOT NULL, /*变更项次*/
wpf03       varchar2(20),            /*采购单号                               */
wpf04       number(5),               /*采购项次                               */
wpf05       date,                    /*變更後預交日                           */
wpf06       number(15,3) DEFAULT '0' NOT NULL, /*變更後預交數量*/
wpf07       varchar2(1) DEFAULT '1' NOT NULL, /*回覆狀態*/
wpf08       date,                    /*許可預交日                             */
wpf09       varchar2(10)             /*来源工厂                               */
);

alter table wpf_file add  constraint wpf_pk primary key  (wpf01,wpf02) enable validate;
grant select on wpf_file to tiptopgp;
grant update on wpf_file to tiptopgp;
grant delete on wpf_file to tiptopgp;
grant insert on wpf_file to tiptopgp;
grant index on wpf_file to public;
grant select on wpf_file to ods;
