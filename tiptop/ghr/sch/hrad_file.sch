/*
================================================================================
檔案代號:hrad_file
檔案名稱:员工状态档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrad_file
(
hrad01      varchar2(10) NOT NULL,   /*员工状态类型                           */
hrad02      varchar2(10) NOT NULL,   /*员工状态编码                           */
hrad03      varchar2(50),            /*员工状态名称                           */
hrad04      varchar2(1),             /*是否为系统数据                         */
hrad05      varchar2(255),           /*备注                                   */
hradacti    varchar2(1),             /*有效码                                 */
hraduser    varchar2(10),            /*资料所有者                             */
hradgrup    varchar2(10),            /*资料所有群                             */
hradmodu    varchar2(10),            /*资料修改者                             */
hraddate    date,                    /*最近修改日                             */
hradorig    varchar2(10),            /*资料建立者                             */
hradoriu    varchar2(10)             /*资料建立部门                           */
);

alter table hrad_file add  constraint tpc_hrad_pk primary key  (hrad01,hrad02) enable validate;
grant select on hrad_file to tiptopgp;
grant update on hrad_file to tiptopgp;
grant delete on hrad_file to tiptopgp;
grant insert on hrad_file to tiptopgp;
grant index on hrad_file to public;
grant select on hrad_file to ods;
