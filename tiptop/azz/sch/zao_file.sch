/*
================================================================================
檔案代號:zao_file
檔案名稱:定义查询输出格式(Layout)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zao_file
(
zao01       varchar2(80) NOT NULL,   /*查询单id                               */
zao02       varchar2(1) NOT NULL,    /*layout 项目                            */
zao03       varchar2(1) NOT NULL,    /*录入格式                               */
zao04       varchar2(1),             /*运行否                                 */
zao05       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zao_file add  constraint zao_pk primary key  (zao01,zao02,zao03,zao05) enable validate;
grant select on zao_file to tiptopgp;
grant update on zao_file to tiptopgp;
grant delete on zao_file to tiptopgp;
grant insert on zao_file to tiptopgp;
grant index on zao_file to public;
grant select on zao_file to ods;
