/*
================================================================================
檔案代號:ahh_file
檔案名稱:分录底稿摘要弹性设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahh_file
(
ahh00       varchar2(5) NOT NULL,    /*帐套                                   */
ahh01       varchar2(24) NOT NULL,   /*科目编号                               */
ahh02       varchar2(20) NOT NULL,   /*交易作业编号                           */
ahh03       varchar2(80),            /*摘要设置值                             */
ahh04       varchar2(60)             /*No Use                                 */
);

alter table ahh_file add  constraint ahh_pk primary key  (ahh00,ahh01,ahh02) enable validate;
grant select on ahh_file to tiptopgp;
grant update on ahh_file to tiptopgp;
grant delete on ahh_file to tiptopgp;
grant insert on ahh_file to tiptopgp;
grant index on ahh_file to public;
grant select on ahh_file to ods;
