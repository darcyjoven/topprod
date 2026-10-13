/*
================================================================================
檔案代號:hrcja_file
檔案名稱:考勤统计明细
檔案目的:
上游檔案:hrcj_file
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcja_file
(
hrcja01     number(10) NOT NULL,     /*考勤统计编号                           */
hrcja02     number(10) NOT NULL,     /*统计信息编号                           */
hrcja03     varchar2(60) NOT NULL,   /*员工ID                                 */
hrcja04     varchar2(20) NOT NULL,   /*假勤项目编号                           */
hrcja05     number(15,3),            /*累次                                   */
hrcja06     number(15,3),            /*累天                                   */
hrcja07     number(15,3),            /*累时                                   */
hrcja08     number(15,3),            /*累分                                   */
hrcja09     varchar2(255)            /*备注                                   */
);

alter table hrcja_file add  constraint tpc_hrcja_pk primary key  (hrcja01,hrcja02) enable validate;
grant select on hrcja_file to tiptopgp;
grant update on hrcja_file to tiptopgp;
grant delete on hrcja_file to tiptopgp;
grant insert on hrcja_file to tiptopgp;
grant index on hrcja_file to public;
grant select on hrcja_file to ods;
