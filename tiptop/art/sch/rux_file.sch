/*
================================================================================
檔案代號:rux_file
檔案名稱:盘点单/盘差单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rux_file
(
rux00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别*/
                                     /*Document 1.Counting 2.Counting Diff.   */
rux01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
rux02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rux03       varchar2(40),            /*产品编号                               */
rux04       varchar2(4),             /*库存单位                               */
rux05       number(15,3),            /*账面数量                               */
rux06       number(15,3),            /*实盘数量                               */
rux07       number(15,3),            /*变更数量                               */
rux08       number(15,3),            /*差异数量                               */
rux09       varchar2(255),           /*備注                                   */
ruxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rux10s      varchar2(40),            /*款号料件编号                           */
rux11s      number(5)                /*款號項次                               */
);

alter table rux_file add  constraint rux_pk primary key  (rux00,rux01,rux02) enable validate;
grant select on rux_file to tiptopgp;
grant update on rux_file to tiptopgp;
grant delete on rux_file to tiptopgp;
grant insert on rux_file to tiptopgp;
grant index on rux_file to public;
grant select on rux_file to ods;
