/*
================================================================================
檔案代號:tur_file
檔案名稱:客户库存月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tur_file
(
tur01       varchar2(10) NOT NULL,   /*客户编号                               */
tur02       varchar2(40) NOT NULL,   /*产品编号                               */
tur03       varchar2(24) NOT NULL,   /*批号                                   */
tur04       number(5) NOT NULL,      /*年度                                   */
tur05       number(5) NOT NULL,      /*期别                                   */
tur06       number(15,3),            /*本期销售                               */
tur07       number(15,3),            /*本期销退                               */
tur08       number(15,3),            /*客户销售                               */
tur09       number(15,3),            /*期末数量                               */
tur11       varchar2(1) NOT NULL,    /*库存类型                               */
tur12       varchar2(10) NOT NULL,   /*送货客户                               */
turplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
turlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tur_file add  constraint tur_pk primary key  (tur01,tur02,tur03,tur04,tur05,tur11,tur12) enable validate;
grant select on tur_file to tiptopgp;
grant update on tur_file to tiptopgp;
grant delete on tur_file to tiptopgp;
grant insert on tur_file to tiptopgp;
grant index on tur_file to public;
grant select on tur_file to ods;
