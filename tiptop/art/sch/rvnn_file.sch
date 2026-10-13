/*
================================================================================
檔案代號:rvnn_file
檔案名稱:配送分货套号单身挡
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvnn_file
(
rvnn01      varchar2(20) DEFAULT ' ' NOT NULL, /*配送分货单号*/
rvnn02      number(5) DEFAULT '0' NOT NULL, /*项次*/
rvnn03      varchar2(20),            /*要货/需求单号                          */
rvnn04      number(5),               /*要货/需求项次                          */
rvnn05      varchar2(10),            /*要货/需求营运中心                      */
rvnn06      varchar2(40),            /*套号                                   */
rvnn07      number(15,3),            /*本次分贷量                             */
rvnnlegal   varchar2(10) NOT NULL,   /*所属法人                               */
rvnnplant   varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rvnn_file add  constraint rvnn_pk primary key  (rvnn01,rvnn02) enable validate;
grant select on rvnn_file to tiptopgp;
grant update on rvnn_file to tiptopgp;
grant delete on rvnn_file to tiptopgp;
grant insert on rvnn_file to tiptopgp;
grant index on rvnn_file to public;
grant select on rvnn_file to ods;
