/*
================================================================================
檔案代號:hrbla_file
檔案名稱:考勤区间单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbla_file
(
hrbla01     number(5) NOT NULL,      /*项次                                   */
hrbla02     number(10) NOT NULL,     /*考勤区间编号                           */
hrbla03     varchar2(1),             /*区间校验重复                           */
hrbla04     date,                    /*开始日期                               */
hrbla05     date,                    /*结束日期                               */
hrbla06     varchar2(255)            /*备注                                   */
);

alter table hrbla_file add  constraint tpc_hrbla_pk primary key  (hrbla01,hrbla02) enable validate;
grant select on hrbla_file to tiptopgp;
grant update on hrbla_file to tiptopgp;
grant delete on hrbla_file to tiptopgp;
grant insert on hrbla_file to tiptopgp;
grant index on hrbla_file to public;
grant select on hrbla_file to ods;
