/*
================================================================================
檔案代號:rzk_file
檔案名稱:POS触屏产品资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzk_file
(
rzk01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
rzk02       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
rzk03       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
rzk04       varchar2(10),            /*所属小类                               */
rzk05       blob,                    /*顺序号                                 */
rzk06       number(5),               /*顺序号                                 */
rzkacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table rzk_file add  constraint rzk_pk primary key  (rzk01,rzk02,rzk03) enable validate;
grant select on rzk_file to tiptopgp;
grant update on rzk_file to tiptopgp;
grant delete on rzk_file to tiptopgp;
grant insert on rzk_file to tiptopgp;
grant index on rzk_file to public;
grant select on rzk_file to ods;
