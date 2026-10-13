/*
================================================================================
檔案代號:wsp_file
檔案名稱:ERP 参考栏位设定档
檔案目的:提供呼叫erp服务取得参考字段资料
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsp_file
(
wsp01       varchar2(80) NOT NULL,   /*服务代码                               */
wsp02       varchar2(15) NOT NULL,   /*table名称                              */
wsp03       varchar2(15) NOT NULL,   /*他系统代码                             */
wsp04       varchar2(20) NOT NULL,   /*erp字段名称                            */
wsp05       varchar2(255) NOT NULL   /*参考字段sql指令                        */
);

alter table wsp_file add  constraint wsp_pk primary key  (wsp01,wsp02,wsp03,wsp04) enable validate;
grant select on wsp_file to tiptopgp;
grant update on wsp_file to tiptopgp;
grant delete on wsp_file to tiptopgp;
grant insert on wsp_file to tiptopgp;
grant index on wsp_file to public;
grant select on wsp_file to ods;
