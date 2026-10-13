/*
================================================================================
檔案代號:oeba_file
檔案名稱:订单料件特性条件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oeba_file
(
oeba01      varchar2(20) DEFAULT ' ' NOT NULL, /*订单编号*/
oeba02      number(5) DEFAULT '0' NOT NULL, /*订单项次*/
oeba03      number(5) DEFAULT '0' NOT NULL, /*项次*/
oeba04      varchar2(10),            /*特性代码                               */
oeba05      varchar2(40),            /*特性值起                               */
oeba06      varchar2(40),            /*特性值起                               */
oebadate    date,                    /*最近更改日                             */
oebagrup    varchar2(10),            /*资料所有群                             */
oebalegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
oebamodu    varchar2(10),            /*资料更改者                             */
oebaorig    varchar2(10),            /*资料建立部门                           */
oebaoriu    varchar2(10),            /*资料建立者                             */
oebaplant   varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
oebauser    varchar2(10),            /*资料所有者                             */
oeba07      varchar2(1) DEFAULT '3' NOT NULL /*条件*/
);

alter table oeba_file add  constraint oeba_pk primary key  (oeba01,oeba02,oeba03) enable validate;
grant select on oeba_file to tiptopgp;
grant update on oeba_file to tiptopgp;
grant delete on oeba_file to tiptopgp;
grant insert on oeba_file to tiptopgp;
grant index on oeba_file to public;
grant select on oeba_file to ods;
