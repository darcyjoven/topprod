/*
================================================================================
檔案代號:ahf_file
檔案名稱:科目异动码弹性设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahf_file
(
ahf00       varchar2(5) NOT NULL,    /*帐套                                   */
ahf01       varchar2(24) NOT NULL,   /*科目编号                               */
ahf02       varchar2(20) NOT NULL,   /*交易作业编号                           */
ahf03       varchar2(2) NOT NULL,    /*核算项顺序                             */
ahf04       varchar2(20)             /*缺省值字段                             */
);

alter table ahf_file add  constraint ahf_pk primary key  (ahf00,ahf01,ahf02,ahf03) enable validate;
grant select on ahf_file to tiptopgp;
grant update on ahf_file to tiptopgp;
grant delete on ahf_file to tiptopgp;
grant insert on ahf_file to tiptopgp;
grant index on ahf_file to public;
grant select on ahf_file to ods;
