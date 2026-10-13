/*
================================================================================
檔案代號:sid_file
檔案名稱:纪录Connection ID/工厂/登入人员的相关资料表
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table sid_file
(
sid01       number(20) NOT NULL,     /*数据库联机标识符                       */
sid02       varchar2(10),            /*登入营运中心                           */
sid03       varchar2(20),            /*数据库                                 */
sid04       varchar2(10),            /*人员编号                               */
sid05       number(10),              /*处理标识符                             */
sid06       varchar2(20),            /*运行程序代码                           */
sid07       varchar2(8),             /*cpu时间                                */
siddate     date                     /*日期                                   */
);

create unique index sid_01 on sid_file (sid01);
grant select on sid_file to tiptopgp;
grant update on sid_file to tiptopgp;
grant delete on sid_file to tiptopgp;
grant insert on sid_file to tiptopgp;
grant index on sid_file to public;
grant select on sid_file to ods;
