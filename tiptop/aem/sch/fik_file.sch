/*
================================================================================
檔案代號:fik_file
檔案名稱:设备停机记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table fik_file
(
fik01       varchar2(20) NOT NULL,   /*设备编号                               */
fik02       date NOT NULL,           /*停机日期                               */
fik03       varchar2(5) NOT NULL,    /*停机时间                               */
fik04       date,                    /*开机日期                               */
fik05       varchar2(5),             /*开机时间                               */
fik06       varchar2(255),           /*备注                                   */
fikuser     varchar2(10),            /*资料所有者                             */
fikgrup     varchar2(10),            /*资料所有部门                           */
fikmodu     varchar2(10),            /*资料更改者                             */
fikdate     date,                    /*最近更改日                             */
fikplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
fiklegal    varchar2(10) NOT NULL,   /*所属法人                               */
fikorig     varchar2(10),            /*资料建立部门                           */
fikoriu     varchar2(10)             /*资料建立者                             */
);

alter table fik_file add  constraint fik_pk primary key  (fik01,fik02,fik03) enable validate;
grant select on fik_file to tiptopgp;
grant update on fik_file to tiptopgp;
grant delete on fik_file to tiptopgp;
grant insert on fik_file to tiptopgp;
grant index on fik_file to public;
grant select on fik_file to ods;
