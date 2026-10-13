/*
================================================================================
檔案代號:sif_file
檔案名稱:备置异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sif_file
(
sif01       varchar2(40) DEFAULT 'null' NOT NULL, /*料件编号*/
sif02       varchar2(10) DEFAULT 'null' NOT NULL, /*仓库*/
sif03       varchar2(10) DEFAULT 'null' NOT NULL, /*库位*/
sif04       varchar2(24) DEFAULT 'null' NOT NULL, /*批号*/
sif05       varchar2(20) DEFAULT 'null' NOT NULL, /*单据编号*/
sif06       varchar2(10) DEFAULT 'null' NOT NULL, /*作业序号*/
sif07       varchar2(4) DEFAULT 'null' NOT NULL, /*单位*/
sif08       varchar2(40) DEFAULT 'null' NOT NULL, /*料号*/
sif09       number(5) DEFAULT '0' NOT NULL, /*异动方式*/
sif10       date,                    /*异动日期                               */
sif11       varchar2(20) DEFAULT ' ' NOT NULL, /*异动单号*/
sif12       number(5) DEFAULT '0' NOT NULL, /*项次*/
siflegal    varchar2(10) NOT NULL,   /*所属法人                               */
sifplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sif13       number(15,3) DEFAULT '0' NOT NULL, /*异动数量*/
sif012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sif013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sif15       number(5) DEFAULT '0' NOT NULL /*单据项次*/
);

alter table sif_file add  constraint sif_pk primary key  (sif01,sif02,sif03,sif04,sif05,sif06,sif07,sif08,sif012,sif013,sif15,sif11,sif12) enable validate;
grant select on sif_file to tiptopgp;
grant update on sif_file to tiptopgp;
grant delete on sif_file to tiptopgp;
grant insert on sif_file to tiptopgp;
grant index on sif_file to public;
grant select on sif_file to ods;
