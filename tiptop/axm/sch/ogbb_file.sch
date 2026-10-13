/*
================================================================================
檔案代號:ogbb_file
檔案名稱:出货单序号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogbb_file
(
ogbb01      varchar2(20) NOT NULL,   /*出货单号                               */
ogbb012     number(5) NOT NULL,      /*项次                                   */
ogbb02      varchar2(15) NOT NULL,   /*序号                                   */
ogbbplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
ogbblegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ogbb_file add  constraint ogbb_pk primary key  (ogbb01,ogbb012,ogbb02) enable validate;
grant select on ogbb_file to tiptopgp;
grant update on ogbb_file to tiptopgp;
grant delete on ogbb_file to tiptopgp;
grant insert on ogbb_file to tiptopgp;
grant index on ogbb_file to public;
grant select on ogbb_file to ods;
