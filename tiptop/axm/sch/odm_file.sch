/*
================================================================================
檔案代號:odm_file
檔案名稱:订货会手册单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odm_file
(
odm01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂購會編號*/
odm02       varchar2(10) DEFAULT ' ' NOT NULL, /*手册编号*/
odm03       varchar2(100) DEFAULT ' ' NOT NULL, /*手册名称*/
odm04       number(5),               /*起始年度                               */
odm05       number(5),               /*起始月份                               */
odm06       number(5),               /*截止年度                               */
odm07       number(5),               /*截止月份                               */
odm08       varchar2(1) DEFAULT '1' NOT NULL, /*时距*/
odmacti     varchar2(1) DEFAULT 'N' NOT NULL, /*资料有效码*/
odmdate     date,                    /*最近更改日                             */
odmgrup     varchar2(10),            /*资料所有部门                           */
odmorig     varchar2(10),            /*资料建立部门                           */
odmoriu     varchar2(10),            /*资料建立者                             */
odmuser     varchar2(10),            /*资料所有者                             */
odmmodu     varchar2(10),            /*资料更改者                             */
odmconf     varchar2(1) DEFAULT 'N' NOT NULL /*审核否*/
);

alter table odm_file add  constraint odm_pk primary key  (odm01,odm02,odm03) enable validate;
grant select on odm_file to tiptopgp;
grant update on odm_file to tiptopgp;
grant delete on odm_file to tiptopgp;
grant insert on odm_file to tiptopgp;
grant index on odm_file to public;
grant select on odm_file to ods;
