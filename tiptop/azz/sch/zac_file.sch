/*
================================================================================
檔案代號:zac_file
檔案名稱:报表相关格式设置备份档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zac_file
(
zac01       varchar2(20) NOT NULL,   /*程序编号                               */
zac02       varchar2(10) NOT NULL,   /*用户                                   */
zac03       varchar2(1) NOT NULL,    /*客制否                                 */
zac04       varchar2(20) NOT NULL,   /*报表打印的样板                         */
zac05       varchar2(10) NOT NULL    /*权限类型                               */
);

alter table zac_file add  constraint zac_pk primary key  (zac01,zac02,zac03,zac04,zac05) enable validate;
grant select on zac_file to tiptopgp;
grant update on zac_file to tiptopgp;
grant delete on zac_file to tiptopgp;
grant insert on zac_file to tiptopgp;
grant index on zac_file to public;
grant select on zac_file to ods;
