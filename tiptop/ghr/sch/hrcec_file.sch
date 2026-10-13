/*
================================================================================
檔案代號:hrcec_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcec_file
(
hrcec01     number(15) NOT NULL,     /*出差编号                               */
hrcec02     number(5) NOT NULL,      /*编号                                   */
hrcec03     varchar2(20) NOT NULL,   /*假勤项目编号                           */
hrcec04     varchar2(60) NOT NULL,   /*员工ID                                 */
hrcec05     date,                    /*开始日期                               */
hrcec06     varchar2(5),             /*开始时间                               */
hrcec07     date,                    /*结束日期                               */
hrcec08     varchar2(5),             /*结束时间                               */
hrcec09     number(5,2),             /*出差时长                               */
hrcec10     varchar2(20) NOT NULL,   /*单位                                   */
hrcec11     number(5,2),             /*出差分钟数                             */
hrcec12     number(5,2),             /*出差小时数                             */
hrcec13     number(5,2),             /*出差天数                               */
hrcec14     number(5,2),             /*班段时长/小时                          */
hrcec15     varchar2(255),           /*备注                                   */
hrcec16     varchar2(1) NOT NULL     /*已撤销出差                             */
);

alter table hrcec_file add  constraint tpc_hrcec_pk primary key  (hrcec01,hrcec02) enable validate;
grant select on hrcec_file to tiptopgp;
grant update on hrcec_file to tiptopgp;
grant delete on hrcec_file to tiptopgp;
grant insert on hrcec_file to tiptopgp;
grant index on hrcec_file to public;
grant select on hrcec_file to ods;
