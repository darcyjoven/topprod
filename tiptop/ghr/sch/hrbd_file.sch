/*
================================================================================
檔案代號:hrbd_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbd_file
(
hrbd01      varchar2(20) NOT NULL,   /*争议单号                               */
hrbd02      date,                    /*争议事发日期                           */
hrbd03      varchar2(20),            /*争议员工ID                             */
hrbd04      varchar2(1000),          /*争议缘由                               */
hrbd05      varchar2(1000),          /*员工要求                               */
hrbd06      number(15,2),            /*公司花费                               */
hrbd07      number(15,2),            /*员工花费                               */
hrbd12      varchar2(100),           /*备注                                   */
hrbdacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbduser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbdgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbdmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbddate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbdoriu    varchar2(10),            /*资料建立者                             */
hrbdorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrbd_file add  constraint tpc_hrbd_pk primary key  (hrbd01) enable validate;
grant select on hrbd_file to tiptopgp;
grant update on hrbd_file to tiptopgp;
grant delete on hrbd_file to tiptopgp;
grant insert on hrbd_file to tiptopgp;
grant index on hrbd_file to public;
grant select on hrbd_file to ods;
