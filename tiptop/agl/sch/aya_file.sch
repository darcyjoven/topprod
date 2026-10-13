/*
================================================================================
檔案代號:aya_file
檔案名稱:股东权益分类设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aya_file
(
aya01       varchar2(10) NOT NULL,   /*分类代码                               */
aya02       varchar2(80),            /*代码说明                               */
aya03       varchar2(1),             /*no use                                 */
aya04       varchar2(1),             /*no use                                 */
aya05       varchar2(1),             /*no use                                 */
aya06       number(5) DEFAULT '0' NOT NULL, /*打印顺序*/
aya07       varchar2(1) DEFAULT 'N' NOT NULL /*合并*/
);

alter table aya_file add  constraint aya_pk primary key  (aya01,aya06,aya07) enable validate;
grant select on aya_file to tiptopgp;
grant update on aya_file to tiptopgp;
grant delete on aya_file to tiptopgp;
grant insert on aya_file to tiptopgp;
grant index on aya_file to public;
grant select on aya_file to ods;
