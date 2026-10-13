/*
================================================================================
檔案代號:rze_file
檔案名稱:POS门店参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rze_file
(
rze01       varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
rze02       varchar2(10) DEFAULT ' ' NOT NULL, /*机号*/
rze03       varchar2(50) DEFAULT ' ' NOT NULL, /*参数编号*/
rze04       varchar2(60) DEFAULT ' ',/*参数值                                 */
rzeacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rzepos      varchar2(1) DEFAULT ' ' NOT NULL /*已传POS否*/
);

create unique index rze_01 on rze_file (rze01,rze02,rze03);
alter table rze_file add  constraint rze_pk primary key  (rze01,rze02,rze03) enable validate;
grant select on rze_file to tiptopgp;
grant update on rze_file to tiptopgp;
grant delete on rze_file to tiptopgp;
grant insert on rze_file to tiptopgp;
grant index on rze_file to public;
grant select on rze_file to ods;
