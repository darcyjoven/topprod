/*
================================================================================
檔案代號:zn_file
檔案名稱:公布栏
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zn_file
(
zn01        varchar2(18),            /*公布日期时间                           */
                                     /*公佈日期時間                           */
zn02        varchar2(255)            /*公布内容                               */
                                     /*公佈內容                               */
);

create        index zn_01 on zn_file (zn01);
grant select on zn_file to tiptopgp;
grant update on zn_file to tiptopgp;
grant delete on zn_file to tiptopgp;
grant insert on zn_file to tiptopgp;
grant index on zn_file to public;
grant select on zn_file to ods;
