/*
================================================================================
檔案代號:zv_file
檔案名稱:程序用户固定打印方式资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zv_file
(
zv01        varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號, (program code)               */
zv02        varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號                             */
zv03        varchar2(1),             /*固定打印方式                           */
                                     /*固定列印方式                           */
zv04        varchar2(1),             /*Local Print Control Code               */
zvacti      varchar2(1),             /*有效否                                 */
zv05        varchar2(10) DEFAULT ' ' NOT NULL, /*权限类型*/
zv06        varchar2(20) DEFAULT ' ' NOT NULL, /*报表打印的样板*/
zv07        varchar2(80),            /*印表机名称                             */
zv08        varchar2(1),             /*立即打印否                             */
zv09        number(3)
);

alter table zv_file add  constraint zv_pk primary key  (zv01,zv02,zv05,zv06) enable validate;
grant select on zv_file to tiptopgp;
grant update on zv_file to tiptopgp;
grant delete on zv_file to tiptopgp;
grant insert on zv_file to tiptopgp;
grant index on zv_file to public;
grant select on zv_file to ods;
