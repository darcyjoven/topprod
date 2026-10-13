/*
================================================================================
檔案代號:rzc_file
檔案名稱:POS参数编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzc_file
(
rzc01       varchar2(50) DEFAULT ' ' NOT NULL, /*参数编号*/
rzc02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
rzc03       number(5),               /*长度                                   */
rzc04       varchar2(1) DEFAULT ' ' NOT NULL, /*参数分类*/
rzc05       varchar2(60),            /*默认值                                 */
rzcacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rzcpos      varchar2(1) DEFAULT ' ' NOT NULL /*已传POS否*/
);

create unique index rzc_01 on rzc_file (rzc01);
alter table rzc_file add  constraint rzc_pk primary key  (rzc01) enable validate;
grant select on rzc_file to tiptopgp;
grant update on rzc_file to tiptopgp;
grant delete on rzc_file to tiptopgp;
grant insert on rzc_file to tiptopgp;
grant index on rzc_file to public;
grant select on rzc_file to ods;
