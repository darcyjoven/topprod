/*
================================================================================
檔案代號:acb_file
檔案名稱:常用凭证类型单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table acb_file
(
acb01       varchar2(6) NOT NULL,    /*类型编号                               */
acb02       number(5) NOT NULL,      /*行序                                   */
acb03       varchar2(80)             /*额外说明                               */
);

alter table acb_file add  constraint acb_pk primary key  (acb01,acb02) enable validate;
grant select on acb_file to tiptopgp;
grant update on acb_file to tiptopgp;
grant delete on acb_file to tiptopgp;
grant insert on acb_file to tiptopgp;
grant index on acb_file to public;
grant select on acb_file to ods;
