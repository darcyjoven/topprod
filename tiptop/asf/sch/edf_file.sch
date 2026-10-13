/*
================================================================================
檔案代號:edf_file
檔案名稱:报工时单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table edf_file
(
edf01       varchar2(20) DEFAULT ' ' NOT NULL, /*报工时单号*/
edf02       number(5) DEFAULT '0' NOT NULL, /*项次*/
edf03       varchar2(20),            /*工单编号                               */
edf04       varchar2(40),            /*料号                                   */
edf05       number(15,3) DEFAULT '0' NOT NULL, /*完工入库量*/
edf06       varchar2(6),             /*作业编号                               */
edf07       number(5),               /*工艺序                                 */
edf08       number(15,3) DEFAULT '0' NOT NULL, /*报工数量*/
edf09       varchar2(10),            /*员工                                   */
edf10       number(15,3),            /*标准单件工时                           */
edf11       number(15,3),            /*实际单件工时                           */
edf12       number(15,3),            /*工时合计                               */
edflegal    varchar2(10),            /*所属法人                               */
edfplant    varchar2(10),            /*所属工厂                               */
edf012      varchar2(10),            /*制程段号                               */
edf13       number(15,3),            /*标准单件工时                           */
edf14       number(15,3),            /*实际单件机时                           */
edf15       number(15,3)             /*机时合计                               */
);

alter table edf_file add  constraint edf_pk primary key  (edf01,edf02) enable validate;
grant select on edf_file to tiptopgp;
grant update on edf_file to tiptopgp;
grant delete on edf_file to tiptopgp;
grant insert on edf_file to tiptopgp;
grant index on edf_file to public;
grant select on edf_file to ods;
