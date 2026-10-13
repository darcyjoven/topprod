/*
================================================================================
檔案代號:hrbhc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbhc_file
(
hrbhc01     number(5) NOT NULL,      /*项次                                   */
hrbhc02     varchar2(50) NOT NULL,   /*员工ID                                 */
hrbhc03     varchar2(50),            /*面谈人员                               */
hrbhc04     date,                    /*面谈日期                               */
hrbhc05     varchar2(1),             /*回聘否                                 */
hrbhc06     varchar2(1),             /*是否需要系统自动补考勤离职             */
hrbhc07     varchar2(10),            /*公司原因                               */
hrbhc08     varchar2(10),            /*外部原因                               */
hrbhc09     varchar2(1000),          /*离职原因总结                           */
hrbhc10     varchar2(255),           /*员工建议                               */
hrbhc11     varchar2(255),           /*简短理由                               */
hrbhc12     varchar2(255)            /*备注                                   */
);

alter table hrbhc_file add  constraint tpc_hrbhc_pk primary key  (hrbhc01) enable validate;
grant select on hrbhc_file to tiptopgp;
grant update on hrbhc_file to tiptopgp;
grant delete on hrbhc_file to tiptopgp;
grant insert on hrbhc_file to tiptopgp;
grant index on hrbhc_file to public;
grant select on hrbhc_file to ods;
