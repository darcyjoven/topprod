/*
================================================================================
檔案代號:wsj_file
檔案名稱:easyflow 集成站台设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsj_file
(
wsj01       varchar2(1) NOT NULL,    /*站台分类                               */
                                     /* s: standard,  Standard Workstation Setting             */
                                     /* e: exception, Exception Workstation Setting Ex. By  Plant No.*/
wsj02       varchar2(15) NOT NULL,   /*EasyFlow 站台 ip 位置                  */
wsj03       varchar2(255) NOT NULL,  /*EasyFlow SOAP services 连接网址        */
wsj04       varchar2(20) NOT NULL,   /*EasyFlow 站台名称(数据库名称)          */
wsj05       varchar2(20) NOT NULL,   /*对应程序编号                           */
wsj06       varchar2(10) NOT NULL,   /*对应营运中心编号                       */
wsj07       varchar2(5) NOT NULL,    /*对应单别编号                           */
wsj08       varchar2(10),            /*No Use                                 */
wsj09       varchar2(10),            /*No Use                                 */
wsj10       varchar2(10)             /*No Use                                 */
);

alter table wsj_file add  constraint wsj_pk primary key  (wsj01,wsj05,wsj06,wsj07) enable validate;
grant select on wsj_file to tiptopgp;
grant update on wsj_file to tiptopgp;
grant delete on wsj_file to tiptopgp;
grant insert on wsj_file to tiptopgp;
grant index on wsj_file to public;
grant select on wsj_file to ods;
