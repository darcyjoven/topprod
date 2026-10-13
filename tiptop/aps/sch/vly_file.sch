/*
================================================================================
檔案代號:vly_file
檔案名稱:aps 多厂区设定维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table vly_file
(
vly01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vly02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vly03       varchar2(80),            /*APS版本描述                            */
vly04       varchar2(20),            /*APS数据库编号                          */
vly05       varchar2(20),            /*APS数据库名称/SID                      */
vly06       varchar2(20),            /*TIPTOP数据库编号                       */
vly07       varchar2(20),            /*TIOTOP数据库名称/SID                   */
vly08       varchar2(20),            /*APS服务器编号                          */
vly09       number(5),               /*APS SERVER PORT                        */
vly10       varchar2(1)              /*数据库状态                             */
);

alter table vly_file add  constraint vly_pk primary key  (vly01,vly02) enable validate;
grant select on vly_file to tiptopgp;
grant update on vly_file to tiptopgp;
grant delete on vly_file to tiptopgp;
grant insert on vly_file to tiptopgp;
grant index on vly_file to public;
grant select on vly_file to ods;
