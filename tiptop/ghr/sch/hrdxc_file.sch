/*
================================================================================
檔案代號:hrdxc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdxc_file
(
hrdxc01     varchar2(50) NOT NULL,   /*所属薪资月                             */
hrdxc02     varchar2(20) NOT NULL,   /*员工ID                                 */
hrdxc03     varchar2(20) NOT NULL,   /*参数编号                               */
hrdxc04     varchar2(100),           /*参数名称                               */
hrdxc05     varchar2(50),            /*参数值                                 */
hrdxc06     varchar2(1),             /*分段标志                               */
hrdxc07     varchar2(100),           /*分段区间                               */
hrdxc08     varchar2(100) NOT NULL,  /*参数标志                               */
hrdxc09     varchar2(100)            /*计算组名称                             */
);

alter table hrdxc_file add  constraint tpc_hrdxc_pk primary key  (hrdxc01,hrdxc02,hrdxc03,hrdxc08) enable validate;
grant select on hrdxc_file to tiptopgp;
grant update on hrdxc_file to tiptopgp;
grant delete on hrdxc_file to tiptopgp;
grant insert on hrdxc_file to tiptopgp;
grant index on hrdxc_file to public;
grant select on hrdxc_file to ods;
