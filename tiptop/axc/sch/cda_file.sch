/*
================================================================================
檔案代號:cda_file
檔案名稱:成本中心成本项目分摊方式资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cda_file
(
cda01       varchar2(10) DEFAULT ' ' NOT NULL, /*成本中心*/
cda02       varchar2(10) DEFAULT ' ' NOT NULL, /*成本项目*/
cda04       varchar2(1) NOT NULL,    /*类型                                   */
cda05       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
cda06       varchar2(1),             /*分摊方式                               */
cda07       number(9,4),             /*分摊权数                               */
cda08       varchar2(1),             /*制费类别                               */
cda09       number(15,3),            /*标准产能                               */
cda10       varchar2(10) NOT NULL    /*部门编号                               */
);

alter table cda_file add  constraint cda_pk primary key  (cda01,cda02,cda04,cda05,cda10) enable validate;
grant select on cda_file to tiptopgp;
grant update on cda_file to tiptopgp;
grant delete on cda_file to tiptopgp;
grant insert on cda_file to tiptopgp;
grant index on cda_file to public;
grant select on cda_file to ods;
