/*
================================================================================
檔案代號:wce_file
檔案名稱:spc 集成站台设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wce_file
(
wce01       varchar2(1) NOT NULL,    /*站台分类                               */
wce02       varchar2(15) NOT NULL,   /*SPC 站台 ip位置                        */
wce03       varchar2(255) NOT NULL,  /*spc soap services 连接网址             */
wce04       varchar2(20) NOT NULL,   /*spc 站台名称(数据库名称                */
wce05       varchar2(20) NOT NULL,   /*对应程序编号                           */
wce06       varchar2(10) NOT NULL,   /*对应营运中心编号                       */
wce07       varchar2(5) NOT NULL,    /*对应单别编号                           */
wce08       varchar2(10),            /*No Use                                 */
wce09       varchar2(10),            /*No Use                                 */
wce10       varchar2(10)             /*No Use                                 */
);

alter table wce_file add  constraint wce_pk primary key  (wce01,wce05,wce06,wce07) enable validate;
grant select on wce_file to tiptopgp;
grant update on wce_file to tiptopgp;
grant delete on wce_file to tiptopgp;
grant insert on wce_file to tiptopgp;
grant index on wce_file to public;
grant select on wce_file to ods;
