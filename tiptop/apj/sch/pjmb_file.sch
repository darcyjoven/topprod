/*
================================================================================
檔案代號:pjmb_file
檔案名稱:项目活动设备需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjmb_file
(
pjmb01      varchar2(10) NOT NULL,   /*网络代号                               */
pjmb02      varchar2(4) NOT NULL,    /*活动编号                               */
pjmb03      number(5) NOT NULL,      /*项次                                   */
pjmb04      varchar2(10),            /*设备类型                               */
pjmb05      number(10),              /*台数                                   */
pjmb06      number(15,3),            /*需求量(使用时间)                       */
pjmbacti    varchar2(1),             /*资料有效码                             */
pjmbdate    date,                    /*最近更改日                             */
pjmbgrup    varchar2(10),            /*资料所有部门                           */
pjmbmodu    varchar2(10),            /*资料更改者                             */
pjmbuser    varchar2(10),            /*资料所有者                             */
pjmborig    varchar2(10),            /*资料建立部门                           */
pjmboriu    varchar2(10)             /*资料建立者                             */
);

alter table pjmb_file add  constraint pjmb_pk primary key  (pjmb01,pjmb02,pjmb03) enable validate;
grant select on pjmb_file to tiptopgp;
grant update on pjmb_file to tiptopgp;
grant delete on pjmb_file to tiptopgp;
grant insert on pjmb_file to tiptopgp;
grant index on pjmb_file to public;
grant select on pjmb_file to ods;
