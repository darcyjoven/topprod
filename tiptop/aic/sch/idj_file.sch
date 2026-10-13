/*
================================================================================
檔案代號:idj_file
檔案名稱:ICD发票资料转入作业单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idj_file
(
idj01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
idj02       varchar2(10) DEFAULT ' ' NOT NULL, /*厂别*/
idj03       number(5) DEFAULT '0' NOT NULL, /*顺序*/
idj04       varchar2(20),            /*档案编号                               */
idj05       varchar2(20),            /*字段编号                               */
idj06       varchar2(1),             /*no use                                 */
idj07       varchar2(1),             /*no use                                 */
idj08       varchar2(1),             /*no use                                 */
idj09       varchar2(1),             /*no use                                 */
idj10       varchar2(1),             /*no use                                 */
idjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table idj_file add  constraint idj_pk primary key  (idj01,idj02,idj03) enable validate;
grant select on idj_file to tiptopgp;
grant update on idj_file to tiptopgp;
grant delete on idj_file to tiptopgp;
grant insert on idj_file to tiptopgp;
grant index on idj_file to public;
grant select on idj_file to ods;
