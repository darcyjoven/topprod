/*
================================================================================
檔案代號:pjfb_file
檔案名稱:项目活动材料需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjfb_file
(
pjfb01      varchar2(10) NOT NULL,   /*网络代号                               */
pjfb02      varchar2(4) NOT NULL,    /*活动编号                               */
pjfb03      number(5) NOT NULL,      /*项次                                   */
pjfb04      varchar2(40),            /*料件编号                               */
pjfb05      varchar2(120),           /*品名                                   */
pjfb06      number(15,3),            /*需求量                                 */
pjfb07      date,                    /*需求日期                               */
pjfb08      number(15,3),            /*转请购量                               */
pjfbacti    varchar2(1),             /*资料有效码                             */
pjfbdate    date,                    /*最近更改日                             */
pjfbgrup    varchar2(10),            /*资料所有部门                           */
pjfbmodu    varchar2(10),            /*资料更改者                             */
pjfbuser    varchar2(10),            /*资料所有者                             */
pjfborig    varchar2(10),            /*资料建立部门                           */
pjfboriu    varchar2(10)             /*资料建立者                             */
);

alter table pjfb_file add  constraint pjfb_pk primary key  (pjfb01,pjfb02,pjfb03) enable validate;
grant select on pjfb_file to tiptopgp;
grant update on pjfb_file to tiptopgp;
grant delete on pjfb_file to tiptopgp;
grant insert on pjfb_file to tiptopgp;
grant index on pjfb_file to public;
grant select on pjfb_file to ods;
