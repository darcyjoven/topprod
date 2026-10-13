/*
================================================================================
檔案代號:wsn_file
檔案名稱:ERP 服务 TABLE 栏位预设值单身档
檔案目的:提供录入 erp 服务选定 table 字段缺省值
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsn_file
(
wsn01       varchar2(80) NOT NULL,   /*服务代码                               */
wsn02       varchar2(15) NOT NULL,   /*table 名称                             */
wsn03       varchar2(20) NOT NULL,   /*table 字段名称                         */
wsn04       varchar2(30)             /*字段缺省值                             */
);

alter table wsn_file add  constraint wsn_pk primary key  (wsn01,wsn02,wsn03) enable validate;
grant select on wsn_file to tiptopgp;
grant update on wsn_file to tiptopgp;
grant delete on wsn_file to tiptopgp;
grant insert on wsn_file to tiptopgp;
grant index on wsn_file to public;
grant select on wsn_file to ods;
