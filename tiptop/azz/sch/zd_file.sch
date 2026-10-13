/*
================================================================================
檔案代號:zd_file
檔案名稱:日报表资料(daily report)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zd_file
(
zd01        date NOT NULL,           /*日期                                   */
zd02        varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號                             */
zd03        number(5) NOT NULL,      /*异动序号                               */
                                     /*異動序號                               */
zd10        varchar2(3),             /*异动编号                               */
                                     /*異動代號                               */
zd11        number(15,3),            /*异动时间                               */
                                     /*異動時間                               */
zd12        varchar2(255),           /*备注                                   */
                                     /*備註                                   */
zdgrup      varchar2(10)             /*Group                                  */
);

alter table zd_file add  constraint zd_pk primary key  (zd01,zd02,zd03) enable validate;
grant select on zd_file to tiptopgp;
grant update on zd_file to tiptopgp;
grant delete on zd_file to tiptopgp;
grant insert on zd_file to tiptopgp;
grant index on zd_file to public;
grant select on zd_file to ods;
