/*
================================================================================
檔案代號:sie_file
檔案名稱:工单备置统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sie_file
(
sie01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
sie02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
sie03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
sie04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
sie05       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
sie06       varchar2(10) DEFAULT ' ' NOT NULL, /*作业序号*/
sie07       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
sie08       varchar2(40) DEFAULT ' ' NOT NULL, /*BOM 料号*/
sie09       number(15,3) DEFAULT '0' NOT NULL, /*备置量*/
sie10       number(15,3) DEFAULT '0' NOT NULL,
sie11       number(15,3) DEFAULT '0' NOT NULL,
sie12       date,                    /*最近异动日期                           */
sie13       varchar2(20),            /*最近異動單號                           */
sie14       number(5) DEFAULT '0' NOT NULL, /*最近異動項次*/
sielegal    varchar2(10) NOT NULL,   /*所属法人                               */
sieplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sie012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sie013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sie15       number(5) DEFAULT '0' NOT NULL, /*单据项次*/
sie16       varchar2(1) DEFAULT ' ' NOT NULL /*单据类型*/
);

alter table sie_file add  constraint sie_pk primary key  (sie01,sie02,sie03,sie04,sie05,sie06,sie07,sie08,sie012,sie013,sie15) enable validate;
grant select on sie_file to tiptopgp;
grant update on sie_file to tiptopgp;
grant delete on sie_file to tiptopgp;
grant insert on sie_file to tiptopgp;
grant index on sie_file to public;
grant select on sie_file to ods;
