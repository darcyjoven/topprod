/*
================================================================================
檔案代號:inj_file
檔案名稱:料件特性资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table inj_file
(
inj01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
inj02       varchar2(24) DEFAULT ' ' NOT NULL, /*制造批号*/
inj03       varchar2(10) DEFAULT ' ' NOT NULL, /*特性代码*/
inj04       varchar2(40),            /*特性值                                 */
inj05       varchar2(40),            /*特性主料编号                           */
inj06       varchar2(1) DEFAULT ' ' NOT NULL /*审核*/
);

alter table inj_file add  constraint inj_pk primary key  (inj01,inj02,inj03) enable validate;
grant select on inj_file to tiptopgp;
grant update on inj_file to tiptopgp;
grant delete on inj_file to tiptopgp;
grant insert on inj_file to tiptopgp;
grant index on inj_file to public;
grant select on inj_file to ods;
