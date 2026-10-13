/*
================================================================================
檔案代號:hrbh_file
檔案名稱:人员离退信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbh_file
(
hrbh01      varchar2(50) NOT NULL,
hrbh02      varchar2(1),
hrbh03      date,
hrbh04      date,
hrbh05      varchar2(10),
hrbh06      varchar2(10),
hrbh07      varchar2(255),
hrbh08      varchar2(255),
hrbh09      varchar2(1),
hrbhconf    varchar2(1),
hrbhud01    varchar2(255),
hrbhud02    varchar2(40),
hrbhud03    varchar2(40),
hrbhud04    varchar2(40),
hrbhud05    varchar2(40),
hrbhud06    varchar2(40),
hrbhud07    number(15,3),
hrbhud08    number(15,3),
hrbhud09    number(15,3),
hrbhud10    number(10),
hrbhud11    number(10),
hrbhud12    number(10),
hrbhud13    date,
hrbhud14    date,
hrbhud15    date,
hrbhuser    varchar2(10),
hrbhgrup    varchar2(10),
hrbhmodu    varchar2(10),
hrbhdate    date,
hrbhorig    varchar2(10),
hrbhoriu    varchar2(10),
hrbh10      varchar2(10),
hrbh11      date,                    /*最后工作日                             */
hrbh12      varchar2(10)             /*原员工状态                             */
);

alter table hrbh_file add  constraint tpc_hrbh_pk primary key  (hrbh01) enable validate;
grant select on hrbh_file to tiptopgp;
grant update on hrbh_file to tiptopgp;
grant delete on hrbh_file to tiptopgp;
grant insert on hrbh_file to tiptopgp;
grant index on hrbh_file to public;
grant select on hrbh_file to ods;
