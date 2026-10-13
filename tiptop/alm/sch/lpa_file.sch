/*
================================================================================
檔案代號:lpa_file
檔案名稱:会员纪念日档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lpa_file
(
lpa01       varchar2(20) DEFAULT ' ' NOT NULL, /*会员编号*/
lpa02       varchar2(10) DEFAULT ' ' NOT NULL,
lpa03       date,
lpa04       number(5),
lpa05       number(5),
lpa06       number(5),
lpaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lpadate     date,                    /*最近更改日                             */
lpagrup     varchar2(10),            /*资料所有群                             */
lpamodu     varchar2(10),            /*资料更改者                             */
lpaorig     varchar2(10),            /*资料建立部门                           */
lpaoriu     varchar2(10),            /*资料建立者                             */
lpauser     varchar2(10)             /*资料所有者                             */
);

alter table lpa_file add  constraint lpa_pk primary key  (lpa01,lpa02) enable validate;
grant select on lpa_file to tiptopgp;
grant update on lpa_file to tiptopgp;
grant delete on lpa_file to tiptopgp;
grant insert on lpa_file to tiptopgp;
grant index on lpa_file to public;
grant select on lpa_file to ods;
