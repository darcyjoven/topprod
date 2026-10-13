/*
================================================================================
檔案代號:vzt_file
檔案名稱:资料库参数设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vzt_file
(
vzt01       varchar2(20) DEFAULT ' ' NOT NULL, /*数据库名称/sid*/
vzt02       varchar2(60),            /*数据库IP地址                           */
vzt03       varchar2(20),            /*数据库登入帐号                         */
vzt04       varchar2(60),            /*数据库口令                             */
vzt05       varchar2(1),             /*是否为主要数据库                       */
vzt06       varchar2(1),             /*数据库来源                             */
vzt07       varchar2(255),           /*TIPTOP SOAP网址                        */
vzt08       varchar2(60),            /*APS保留字段文字                        */
vzt09       varchar2(60),            /*APS保留字段文字                        */
vzt10       varchar2(60),            /*APS保留字段文字                        */
vzt11       number(9),               /*APS保留字段数值                        */
vzt12       number(18,8),            /*APS保留字段浮点数                      */
vzt13       number(18,8),            /*APS保留字段浮点数                      */
vzt14       date,                    /*APS保留字段日期                        */
vzt15       date                     /*APS保留字段日期                        */
);

alter table vzt_file add  constraint vzt_pk primary key  (vzt01) enable validate;
grant select on vzt_file to tiptopgp;
grant update on vzt_file to tiptopgp;
grant delete on vzt_file to tiptopgp;
grant insert on vzt_file to tiptopgp;
grant index on vzt_file to public;
grant select on vzt_file to ods;
