/*
================================================================================
檔案代號:idn_file
檔案名稱:ICD厂商WIP资料设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idn_file
(
idn01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
idn02       varchar2(10) DEFAULT ' ' NOT NULL, /*厂别*/
idn03       number(5) DEFAULT '0' NOT NULL, /*顺序*/
idn04       varchar2(20),            /*档案编号                               */
idn05       varchar2(20),            /*字段编号                               */
idn06       varchar2(1),             /*no use                                 */
idn07       varchar2(1),             /*no use                                 */
idn08       varchar2(1),             /*no use                                 */
idn09       varchar2(1),             /*no use                                 */
idn10       varchar2(1),             /*no use                                 */
idnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table idn_file add  constraint idn_pk primary key  (idn01,idn02,idn03) enable validate;
grant select on idn_file to tiptopgp;
grant update on idn_file to tiptopgp;
grant delete on idn_file to tiptopgp;
grant insert on idn_file to tiptopgp;
grant index on idn_file to public;
grant select on idn_file to ods;
