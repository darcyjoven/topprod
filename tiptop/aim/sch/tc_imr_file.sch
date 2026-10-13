/*
================================================================================
檔案代號:tc_imr_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_imr_file
(
tc_imr01    number(10) NOT NULL,     /*项次                                   */
tc_imr02    varchar2(100),           /*工单单号                               */
tc_imr03    number(10),              /*工艺序号                               */
tc_imr04    varchar2(100),           /*作业编码                               */
tc_imr05    varchar2(100),           /*工作中心编码                           */
tc_imr06    number(15,3)             /*数量                                   */
);

alter table tc_imr_file add  constraint tpc_imr_pk primary key  (tc_imr01) enable validate;
grant select on tc_imr_file to tiptopgp;
grant update on tc_imr_file to tiptopgp;
grant delete on tc_imr_file to tiptopgp;
grant insert on tc_imr_file to tiptopgp;
grant index on tc_imr_file to public;
grant select on tc_imr_file to ods;
