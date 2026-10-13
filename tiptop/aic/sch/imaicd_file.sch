/*
================================================================================
檔案代號:imaicd_file
檔案名稱:ICD料件资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imaicd_file
(
imaicd00    varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
imaicd01    varchar2(40),            /*母体料号                               */
imaicd02    varchar2(40),            /*外编母体                               */
imaicd03    varchar2(40),            /*外编子体                               */
imaicd04    varchar2(1),             /*料件状态                               */
imaicd05    varchar2(1),             /*料件特性                               */
imaicd06    varchar2(40),            /*内编子体                               */
imaicd07    varchar2(40),            /*RoHs                                   */
imaicd08    varchar2(1),             /*刻号/BIN管理                           */
imaicd09    varchar2(1),             /*Date Code 否                           */
imaicd10    varchar2(10),            /*作业群组                               */
imaicd11    varchar2(40),            /*来源单号                               */
imaicd12    number(9,4),             /*备品比率                               */
imaicd13    varchar2(1),             /*批号管控否                             */
imaicd14    number(15,3) DEFAULT '0' NOT NULL, /*GROSS DIE*/
imaicd15    number(9,4) DEFAULT '0' NOT NULL, /*良率%*/
imaicd16    varchar2(40),            /*WAFER型号                              */
imaicd17    varchar2(1) DEFAULT '3' NOT NULL,
imaicd18    varchar2(6),             /*Pkg Type                               */
imaicd19    varchar2(10),            /*Pin Count                              */
imaicd20    varchar2(20),            /*B/d No                                 */
imaicd21    varchar2(10)             /*B/d Ver                                */
);

alter table imaicd_file add  constraint imaicd_pk primary key  (imaicd00) enable validate;
grant select on imaicd_file to tiptopgp;
grant update on imaicd_file to tiptopgp;
grant delete on imaicd_file to tiptopgp;
grant insert on imaicd_file to tiptopgp;
grant index on imaicd_file to public;
grant select on imaicd_file to ods;
