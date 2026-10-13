/*
================================================================================
檔案代號:hisb_file
檔案名稱:历史资料备份计划单身档-依时间
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hisb_file
(
hisb01      varchar2(30) DEFAULT ' ' NOT NULL, /*备份方案*/
hisb02      varchar2(80) DEFAULT ' ' NOT NULL, /*待备份的TABLE*/
hisb03      varchar2(1),             /*基本资料TABLE否                        */
hisb04      varchar2(80),            /*条件字段                               */
hisb05      varchar2(255)            /*附加条件                               */
);

grant select on hisb_file to tiptopgp;
grant update on hisb_file to tiptopgp;
grant delete on hisb_file to tiptopgp;
grant insert on hisb_file to tiptopgp;
grant index on hisb_file to public;
grant select on hisb_file to ods;
