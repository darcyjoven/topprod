/*
================================================================================
檔案代號:hrdxb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdxb_file
(
hrdxb01     varchar2(50) NOT NULL,   /*所属薪资月                             */
hrdxb02     varchar2(20) NOT NULL,   /*员工ID                                 */
hrdxb03     varchar2(20) NOT NULL,   /*计算项编码                             */
hrdxb04     varchar2(100),           /*计算项名称                             */
hrdxb05     number(15,2),            /*计算项值                               */
hrdxb06     varchar2(1),             /*是否计入薪资                           */
hrdxb07     varchar2(1),             /*是否扣减项                             */
hrdxb08     varchar2(1),             /*是否福利项                             */
hrdxb09     varchar2(20),            /*计税方式                               */
hrdxb10     varchar2(4000),          /*备注                                   */
hrdxb11     varchar2(100)            /*计算组名称                             */
);

alter table hrdxb_file add  constraint tpc_hrdxb_pk primary key  (hrdxb01,hrdxb02,hrdxb03) enable validate;
grant select on hrdxb_file to tiptopgp;
grant update on hrdxb_file to tiptopgp;
grant delete on hrdxb_file to tiptopgp;
grant insert on hrdxb_file to tiptopgp;
grant index on hrdxb_file to public;
grant select on hrdxb_file to ods;
