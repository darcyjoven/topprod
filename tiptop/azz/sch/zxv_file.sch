/*
================================================================================
檔案代號:zxv_file
檔案名稱:员工运行动作资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table zxv_file
(
zxv01       varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號,(Login user name)           */
zxv02       varchar2(32) NOT NULL,   /*用户tty                                */
                                     /*使用者tty                              */
zxv03       date,                    /*日期                                   */
zxv04       date,                    /*时间                                   */
                                     /*時間                                   */
                                     /*ORA版須手工將型態改為char(8)           */
zxv05       varchar2(10)             /*运行动作                               */
                                     /*執行動作                               */
);

alter table zxv_file add  constraint zxv_pk primary key  (zxv01,zxv02) enable validate;
grant select on zxv_file to tiptopgp;
grant update on zxv_file to tiptopgp;
grant delete on zxv_file to tiptopgp;
grant insert on zxv_file to tiptopgp;
grant index on zxv_file to public;
grant select on zxv_file to ods;
