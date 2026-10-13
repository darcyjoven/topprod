/*
================================================================================
檔案代號:hrbob_file
檔案名稱:班段加班信息表
檔案目的:记录班段加班信息
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbob_file
(
hrbob01     number(5) NOT NULL,      /*流水号                                 */
hrbob02     varchar2(1),             /*早到加班                               */
hrbob03     varchar2(1),             /*延长加班                               */
hrbob04     varchar2(1),             /*就餐时间依实际扣除                     */
hrbob05     number(5) NOT NULL,      /*最少加班/分钟                          */
hrbob06     number(5) NOT NULL,      /*超出核算/分钟                          */
hrbob07     number(5) NOT NULL,      /*最多加班/分钟                          */
hrbob08     varchar2(255),           /*备注                                   */
hrbob09     varchar2(20) NOT NULL,   /*班次编号                               */
hrbob10     number(5) NOT NULL       /*班段编号                               */
);

alter table hrbob_file add  constraint tpc_hrbob_pk primary key  (hrbob01,hrbob09,hrbob10) enable validate;
grant select on hrbob_file to tiptopgp;
grant update on hrbob_file to tiptopgp;
grant delete on hrbob_file to tiptopgp;
grant insert on hrbob_file to tiptopgp;
grant index on hrbob_file to public;
grant select on hrbob_file to ods;
