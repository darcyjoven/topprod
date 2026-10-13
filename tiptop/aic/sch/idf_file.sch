/*
================================================================================
檔案代號:idf_file
檔案名稱:ICD回货资料厂商设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idf_file
(
idf01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
idf02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
idf03       number(5) DEFAULT '0' NOT NULL, /*顺序*/
idf04       varchar2(20),            /*档案编号                               */
idf05       varchar2(20),            /*字段编号                               */
idf06       varchar2(1),             /*no use                                 */
idf07       varchar2(1),             /*no use                                 */
idf08       varchar2(1),             /*no use                                 */
idf09       varchar2(1),             /*no use                                 */
idf10       varchar2(1),             /*no use                                 */
idfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table idf_file add  constraint idf_pk primary key  (idf01,idf02,idf03) enable validate;
grant select on idf_file to tiptopgp;
grant update on idf_file to tiptopgp;
grant delete on idf_file to tiptopgp;
grant insert on idf_file to tiptopgp;
grant index on idf_file to public;
grant select on idf_file to ods;
