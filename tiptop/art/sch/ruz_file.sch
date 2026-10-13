/*
================================================================================
檔案代號:ruz_file
檔案名稱:盘点单变更单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruz_file
(
ruz01       varchar2(20) DEFAULT ' ' NOT NULL, /*盘点变更单号*/
ruz02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ruz03       varchar2(40),            /*产品编号                               */
ruz04       varchar2(4),             /*库存单位                               */
ruz05       number(15,3),            /*账面数量                               */
ruz06       number(15,3),            /*实盘数量                               */
ruz07       number(15,3),            /*变更数量                               */
ruz08       number(15,3),            /*差异数量                               */
ruz09       number(15,3),            /*本次变更数量                           */
ruz10       varchar2(255),           /*備注                                   */
ruzlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruzplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table ruz_file add  constraint ruz_pk primary key  (ruz01,ruz02) enable validate;
grant select on ruz_file to tiptopgp;
grant update on ruz_file to tiptopgp;
grant delete on ruz_file to tiptopgp;
grant insert on ruz_file to tiptopgp;
grant index on ruz_file to public;
grant select on ruz_file to ods;
