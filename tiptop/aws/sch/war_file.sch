/*
================================================================================
檔案代號:war_file
檔案名稱:CROSS平台注册的产品主机
檔案目的:维护 TIPTOP 串接 CROSS 整合平台的产品主机设定
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table war_file
(
war01       varchar2(1) DEFAULT ' ' NOT NULL, /*站台分类*/
war02       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
war03       varchar2(30) DEFAULT ' ' NOT NULL, /*产品名称*/
war04       varchar2(20),            /*版本                                   */
war05       varchar2(20),            /*IP位置                                 */
war06       varchar2(20),            /*产品标识符                             */
war07       varchar2(255)            /*WSDL 位置                              */
);

alter table war_file add  constraint war_pk primary key  (war01,war02,war03) enable validate;
grant select on war_file to tiptopgp;
grant update on war_file to tiptopgp;
grant delete on war_file to tiptopgp;
grant insert on war_file to tiptopgp;
grant index on war_file to public;
grant select on war_file to ods;
