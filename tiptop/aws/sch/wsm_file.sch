/*
================================================================================
檔案代號:wsm_file
檔案名稱:ERP 服务与他系统间栏位对应关系单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsm_file
(
wsm01       varchar2(80) NOT NULL,   /*服务代码                               */
wsm02       varchar2(15) NOT NULL,   /*table 名称                             */
wsmacti     varchar2(1),             /*资料有效码                             */
wsmdate     date,                    /*最后异动日期                           */
wsmgrup     varchar2(10),            /*资料建立人员群组                       */
wsmmodu     varchar2(10),            /*最后异动人员                           */
wsmuser     varchar2(10),            /*资料建立人员                           */
wsmoriu     varchar2(10),            /*资料建立者                             */
wsmorig     varchar2(10)             /*资料建立部门                           */
);

alter table wsm_file add  constraint wsm_pk primary key  (wsm01,wsm02) enable validate;
grant select on wsm_file to tiptopgp;
grant update on wsm_file to tiptopgp;
grant delete on wsm_file to tiptopgp;
grant insert on wsm_file to tiptopgp;
grant index on wsm_file to public;
grant select on wsm_file to ods;
