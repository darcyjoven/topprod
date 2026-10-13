/*
================================================================================
檔案代號:tc_sgm_file
檔案名稱:委外异动资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sgm_file
(
tc_sgm01    varchar2(23) NOT NULL,   /*runcard单号                            */
tc_sgm02    number(5) NOT NULL,      /*工艺序号                               */
tc_sgm03    varchar2(20) NOT NULL,   /*委外单号                               */
tc_sgm04    number(5) NOT NULL,      /*委外项次                               */
tc_sgm05    varchar2(20),            /*工单单号                               */
tc_sgm06    varchar2(10)             /*作业编号                               */
);

alter table tc_sgm_file add  constraint tpc_sgm_pk primary key  (tc_sgm01,tc_sgm02,tc_sgm03,tc_sgm04) enable validate;
grant select on tc_sgm_file to tiptopgp;
grant update on tc_sgm_file to tiptopgp;
grant delete on tc_sgm_file to tiptopgp;
grant insert on tc_sgm_file to tiptopgp;
grant index on tc_sgm_file to public;
grant select on tc_sgm_file to ods;
