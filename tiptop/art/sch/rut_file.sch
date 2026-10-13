/*
================================================================================
檔案代號:rut_file
檔案名稱:盘点库存备份表
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table rut_file
(
rut01       varchar2(20) DEFAULT ' ' NOT NULL, /*盘点计划单号*/
rut02       date,                    /*盘点日期                               */
rut03       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
rut04       varchar2(40) DEFAULT ' ' NOT NULL, /*商品代码*/
rut05       varchar2(4),             /*库存单位                               */
rut06       number(15,3) DEFAULT '0' NOT NULL, /*库存数量*/
rut07       number(15,3) DEFAULT '0' NOT NULL, /*No Use*/
rutlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rutplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rut_file add  constraint rut_pk primary key  (rut01,rut03,rut04) enable validate;
grant select on rut_file to tiptopgp;
grant update on rut_file to tiptopgp;
grant delete on rut_file to tiptopgp;
grant insert on rut_file to tiptopgp;
grant index on rut_file to public;
grant select on rut_file to ods;
