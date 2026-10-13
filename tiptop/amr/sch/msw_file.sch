/*
================================================================================
檔案代號:msw_file
檔案名稱:多营运中心mrp版本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msw_file
(
msw000      varchar2(10) NOT NULL,   /*汇总版本号                             */
msw02       number(5),               /*pr/po 允许交期提前 (reschedule)        */
msw03       date,                    /*运行日期                               */
msw04       varchar2(5),             /*起始时间                               */
msw05       varchar2(5),             /*结束时间                               */
msw06       number(10),              /*no use                                 */
msw07       varchar2(10),            /*生成人员                               */
msw08       varchar2(10) NOT NULL,   /*分营运中心编号                         */
msw09       varchar2(2),             /*no use                                 */
msw10       varchar2(20)             /*分营运中心mrp版本号                    */
);

alter table msw_file add  constraint msw_pk primary key  (msw000,msw08) enable validate;
grant select on msw_file to tiptopgp;
grant update on msw_file to tiptopgp;
grant delete on msw_file to tiptopgp;
grant insert on msw_file to tiptopgp;
grant index on msw_file to public;
grant select on msw_file to ods;
