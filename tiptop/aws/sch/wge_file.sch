/*
================================================================================
檔案代號:wge_file
檔案名稱:集成站台设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wge_file
(
wge01       varchar2(1) NOT NULL,    /*站台分类                               */
wge02       varchar2(15) NOT NULL,   /*站台ip位置                             */
wge03       varchar2(255) NOT NULL,  /*SOAP网址                               */
wge04       varchar2(20) NOT NULL,   /*站台名称(数据库名称)                   */
wge05       varchar2(20) NOT NULL,   /*对应程序编号, 标准站台以'*'            */
wge06       varchar2(10) NOT NULL,   /*对应营运中心编号                       */
wge07       varchar2(5) NOT NULL,    /*对应单别编号                           */
wge08       varchar2(255) NOT NULL,  /*www网址                                */
wge09       varchar2(10),            /*站台port                               */
wge10       varchar2(10)             /*no use                                 */
);

alter table wge_file add  constraint wge_pk primary key  (wge01,wge05,wge06,wge07) enable validate;
grant select on wge_file to tiptopgp;
grant update on wge_file to tiptopgp;
grant delete on wge_file to tiptopgp;
grant insert on wge_file to tiptopgp;
grant index on wge_file to public;
grant select on wge_file to ods;
