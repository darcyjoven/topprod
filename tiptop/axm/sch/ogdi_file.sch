/*
================================================================================
檔案代號:ogdi_file
檔案名稱:包装资料档
檔案目的:包装资料档(行业别架构)
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogdi_file
(
ogdi01      varchar2(20) DEFAULT ' ' NOT NULL, /*出货通知单号*/
ogdi03      number(10) DEFAULT '0' NOT NULL, /*项次*/
ogdi04      number(5) DEFAULT '0' NOT NULL, /*序号(1.整箱 234.. 并箱)*/
ogdislk01   varchar2(1),             /*包装类型                               */
ogdiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
ogdilegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ogdi_file add  constraint ogdi_pk primary key  (ogdi01,ogdi03,ogdi04) enable validate;
grant select on ogdi_file to tiptopgp;
grant update on ogdi_file to tiptopgp;
grant delete on ogdi_file to tiptopgp;
grant insert on ogdi_file to tiptopgp;
grant index on ogdi_file to public;
grant select on ogdi_file to ods;
