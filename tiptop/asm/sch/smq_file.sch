/*
================================================================================
檔案代號:smq_file
檔案名稱:总账日关账设置资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table smq_file
(
smq01       varchar2(5) NOT NULL,    /*帐套                                   */
smq02       varchar2(80),            /*帐套名称                               */
smq03       number(5)                /*现行日期前几天关帐                     */
);

alter table smq_file add  constraint smq_pk primary key  (smq01) enable validate;
grant select on smq_file to tiptopgp;
grant update on smq_file to tiptopgp;
grant delete on smq_file to tiptopgp;
grant insert on smq_file to tiptopgp;
grant index on smq_file to public;
grant select on smq_file to ods;
