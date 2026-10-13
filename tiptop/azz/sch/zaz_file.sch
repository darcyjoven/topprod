/*
================================================================================
檔案代號:zaz_file
檔案名稱:Vprint 参数设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zaz_file
(
zaz01       varchar2(10) NOT NULL,   /*用户                                   */
zaz02       varchar2(10) NOT NULL,   /*权限类型                               */
zaz03       varchar2(20) NOT NULL,   /*程序代码                               */
zaz04       varchar2(20) NOT NULL,   /*报表打印的样板                         */
zaz05       varchar2(80),            /*印表机名称                             */
zaz06       varchar2(1),             /*缩小打印选项                           */
zaz07       varchar2(1)              /*立即打印否                             */
);

alter table zaz_file add  constraint zaz_pk primary key  (zaz01,zaz02,zaz03,zaz04) enable validate;
grant select on zaz_file to tiptopgp;
grant update on zaz_file to tiptopgp;
grant delete on zaz_file to tiptopgp;
grant insert on zaz_file to tiptopgp;
grant index on zaz_file to public;
grant select on zaz_file to ods;
