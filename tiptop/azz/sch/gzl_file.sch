/*
================================================================================
檔案代號:gzl_file
檔案名稱:软件代工开发记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gzl_file
(
gzl00       varchar2(20) NOT NULL,   /*审核单号                               */
gzl01       number(5) NOT NULL,      /*项次                                   */
gzl02       varchar2(20),            /*委托单号                               */
gzl04       varchar2(15),            /*客户审核书                             */
gzl05       varchar2(20),            /*程序编号(zz_file)                      */
gzl06       date,                    /*发放日期                               */
gzl07       number(8,4),             /*预计时数                               */
gzl08       number(8,4),             /*计费时数                               */
gzl09       date,                    /*预计完成日                             */
gzl10       date,                    /*实际完成日                             */
gzl11       varchar2(10),            /*程序人员(zx_file)                      */
gzl12       number(8,4),             /*程序时数                               */
gzl13       varchar2(10),            /*测试人员(zx_file)                      */
gzl14       number(8,4),             /*测试时数                               */
gzl15       date,                    /*测试完成日                             */
gzl16       varchar2(1000),          /*备注                                   */
gzl17       number(5) NOT NULL,      /*版次                                   */
gzl18       varchar2(1),             /*状态码                                 */
gzl19       varchar2(10),            /*服务审核人员                           */
gzl20       date                     /*服务审核日期                           */
);

alter table gzl_file add  constraint gzl_pk primary key  (gzl00,gzl01,gzl17) enable validate;
grant select on gzl_file to tiptopgp;
grant update on gzl_file to tiptopgp;
grant delete on gzl_file to tiptopgp;
grant insert on gzl_file to tiptopgp;
grant index on gzl_file to public;
grant select on gzl_file to ods;
