/*
================================================================================
檔案代號:tc_ecg_file
檔案名稱:工艺工时维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ecg_file
(
tc_ecg01    varchar2(40) NOT NULL,   /*料号                                   */
tc_ecg02    varchar2(4) NOT NULL,    /*工艺编号                               */
tc_ecg03    number(4) NOT NULL,      /*序号                                   */
tc_ecg04    varchar2(10) NOT NULL,   /*作业编号                               */
tc_ecg05    varchar2(8) NOT NULL,    /*工作站                                 */
tc_ecg06    number(16,3) DEFAULT '0' NOT NULL, /*标准人工*/
tc_ecg07    number(16,3) DEFAULT '0' NOT NULL, /*标准机器时间*/
tc_ecg08    date,                    /*资料建立日期                           */
tc_ecg09    varchar2(10),            /*资料建立人员                           */
tc_ecg10    varchar2(10)             /*资料建立部门                           */
);

create unique index tic_ecg_01 on tc_ecg_file (tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05);
alter table tc_ecg_file add  constraint tpc_ecg_pk primary key  (tc_ecg01,tc_ecg02,tc_ecg03,tc_ecg04,tc_ecg05) enable validate;
grant select on tc_ecg_file to tiptopgp;
grant update on tc_ecg_file to tiptopgp;
grant delete on tc_ecg_file to tiptopgp;
grant insert on tc_ecg_file to tiptopgp;
grant index on tc_ecg_file to public;
grant select on tc_ecg_file to ods;
