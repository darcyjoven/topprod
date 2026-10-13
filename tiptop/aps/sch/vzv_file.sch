/*
================================================================================
檔案代號:vzv_file
檔案名稱:aps各類訊息檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vzv_file
(
vzv00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vzv01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vzv02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vzv03       date DEFAULT sysdate NOT NULL, /*信息接收时间*/
vzv04       varchar2(30) NOT NULL,   /*信息编号                               */
vzv05       varchar2(80),            /*信息说明                               */
vzv06       varchar2(1) NOT NULL,    /*信息状态                               */
vzv07       varchar2(1),             /*tiptop执行结果                         */
vzv08       varchar2(10),            /*操作人员编号                           */
vzvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vzvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table vzv_file add  constraint vzv_pk primary key  (vzv00,vzv01,vzv02,vzv03,vzv04,vzv06) enable validate;
grant select on vzv_file to tiptopgp;
grant update on vzv_file to tiptopgp;
grant delete on vzv_file to tiptopgp;
grant insert on vzv_file to tiptopgp;
grant index on vzv_file to public;
grant select on vzv_file to ods;
