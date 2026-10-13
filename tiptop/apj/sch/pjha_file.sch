/*
================================================================================
檔案代號:pjha_file
檔案名稱:wbs本阶人力需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjha_file
(
pjha01      varchar2(30) NOT NULL,   /*本阶wbs编码                            */
pjha02      number(5) NOT NULL,      /*项次                                   */
pjha03      varchar2(10),            /*技能编号                               */
pjha04      number(15,3),            /*需求数量                               */
pjhaacti    varchar2(1),             /*资料有效码                             */
pjhadate    date,                    /*最近更改日                             */
pjhagrup    varchar2(10),            /*资料所有部门                           */
pjhamodu    varchar2(10),            /*资料更改者                             */
pjhauser    varchar2(10),            /*资料所有者                             */
pjhaorig    varchar2(10),            /*资料建立部门                           */
pjhaoriu    varchar2(10)             /*资料建立者                             */
);

alter table pjha_file add  constraint pjha_pk primary key  (pjha01,pjha02) enable validate;
grant select on pjha_file to tiptopgp;
grant update on pjha_file to tiptopgp;
grant delete on pjha_file to tiptopgp;
grant insert on pjha_file to tiptopgp;
grant index on pjha_file to public;
grant select on pjha_file to ods;
