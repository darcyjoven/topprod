/*
================================================================================
檔案代號:tpg_file
檔案名稱:页次档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tpg_file
(
tpg01       varchar2(4) NOT NULL,    /*年度                                   */
tpg02       number(5) NOT NULL,      /*期别                                   */
tpg03       varchar2(24) NOT NULL,   /*科目编号                               */
tpg04       number(5),               /*页次                                   */
tpg05       varchar2(20) NOT NULL,   /*程序编号                               */
tpg06       varchar2(1),             /*No Use                                 */
tpg07       varchar2(1)              /*No Use                                 */
);

alter table tpg_file add  constraint tpg_pk primary key  (tpg01,tpg02,tpg03,tpg05) enable validate;
grant select on tpg_file to tiptopgp;
grant update on tpg_file to tiptopgp;
grant delete on tpg_file to tiptopgp;
grant insert on tpg_file to tiptopgp;
grant index on tpg_file to public;
grant select on tpg_file to ods;
