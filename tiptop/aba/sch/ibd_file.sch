/*
================================================================================
檔案代號:ibd_file
檔案名稱:条码管理系统参数档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table ibd_file
(
ibd01       varchar2(1) DEFAULT '0' NOT NULL, /*KEY VALUE (0)*/
ibd02       varchar2(1) DEFAULT 'N' NOT NULL, /*扫描是否允许修改*/
ibd03       varchar2(10),            /*中转仓库                               */
ibd04       varchar2(10),            /*中转储位                               */
ibd05       varchar2(1) DEFAULT 'N' NOT NULL, /*超入率检查*/
ibd06       varchar2(5),             /*交接单别                               */
ibd07       varchar2(1) DEFAULT '3' NOT NULL, /*预设报表类型*/
ibd08       varchar2(1) DEFAULT '1' NOT NULL, /*回馈(冲)原则*/
ibd09       varchar2(1) DEFAULT 'N' NOT NULL, /*自动产生出货单*/
ibd10       varchar2(1) DEFAULT 'N' NOT NULL /*自动产生入库单*/
);

alter table ibd_file add  constraint ibd_pk primary key  (ibd01) enable validate;
grant select on ibd_file to tiptopgp;
grant update on ibd_file to tiptopgp;
grant delete on ibd_file to tiptopgp;
grant insert on ibd_file to tiptopgp;
grant index on ibd_file to public;
grant select on ibd_file to ods;
