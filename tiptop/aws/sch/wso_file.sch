/*
================================================================================
檔案代號:wso_file
檔案名稱:ERP 服务与他系统间栏位对应关系单身档
檔案目的:提供录入呼叫 erp 服务录入资料时, 他系统与 erp 字段的对应关系
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wso_file
(
wso01       varchar2(80) NOT NULL,   /*服务代码                               */
wso02       varchar2(15) NOT NULL,   /*table 名称                             */
wso03       varchar2(15) NOT NULL,   /*他系统代码                             */
wso04       varchar2(20) NOT NULL,   /*erp 字段名称                           */
wso05       varchar2(30) NOT NULL    /*他系统字段名称                         */
);

create        index wso_03 on wso_file (wso01,wso02,wso04);
create        index wso_02 on wso_file (wso01,wso02,wso05);
alter table wso_file add  constraint wso_pk primary key  (wso01,wso02,wso03,wso04) enable validate;
grant select on wso_file to tiptopgp;
grant update on wso_file to tiptopgp;
grant delete on wso_file to tiptopgp;
grant insert on wso_file to tiptopgp;
grant index on wso_file to public;
grant select on wso_file to ods;
