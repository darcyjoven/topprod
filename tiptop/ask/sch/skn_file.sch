/*
================================================================================
檔案代號:skn_file
檔案名稱:报工群组工单资料档
檔案目的:报工群组工单资料单头档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skn_file
(
skn01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
skn02       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sknacti     varchar2(1),             /*资料有效码                             */
skndate     date,                    /*资料更改日期                           */
skngrup     varchar2(10),            /*资料所属群组                           */
sknmodu     varchar2(10),            /*资料更改者                             */
sknuser     varchar2(10),            /*资料用户                               */
sknplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sknlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sknoriu     varchar2(10),            /*资料建立者                             */
sknorig     varchar2(10)             /*资料建立部门                           */
);

alter table skn_file add  constraint skn_pk primary key  (skn01) enable validate;
grant select on skn_file to tiptopgp;
grant update on skn_file to tiptopgp;
grant delete on skn_file to tiptopgp;
grant insert on skn_file to tiptopgp;
grant index on skn_file to public;
grant select on skn_file to ods;
