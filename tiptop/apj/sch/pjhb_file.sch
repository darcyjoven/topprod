/*
================================================================================
檔案代號:pjhb_file
檔案名稱:项目活动人力需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjhb_file
(
pjhb01      varchar2(10) NOT NULL,   /*网络代号                               */
pjhb02      varchar2(4) NOT NULL,    /*活动编号                               */
pjhb03      number(5) NOT NULL,      /*项次                                   */
pjhb04      varchar2(10),            /*技能编号                               */
pjhb05      number(15,3),            /*需求数量                               */
pjhbacti    varchar2(1),             /*资料有效码                             */
pjhbdate    date,                    /*最近更改日                             */
pjhbgrup    varchar2(10),            /*资料所有部门                           */
pjhbmodu    varchar2(10),            /*资料更改者                             */
pjhbuser    varchar2(10),            /*资料所有者                             */
pjhborig    varchar2(10),            /*资料建立部门                           */
pjhboriu    varchar2(10)             /*资料建立者                             */
);

alter table pjhb_file add  constraint pjhb_pk primary key  (pjhb01,pjhb02,pjhb03) enable validate;
grant select on pjhb_file to tiptopgp;
grant update on pjhb_file to tiptopgp;
grant delete on pjhb_file to tiptopgp;
grant insert on pjhb_file to tiptopgp;
grant index on pjhb_file to public;
grant select on pjhb_file to ods;
