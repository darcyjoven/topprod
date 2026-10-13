/*
================================================================================
檔案代號:fih_file
檔案名稱:设备仪表资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fih_file
(
fih01       varchar2(20) NOT NULL,   /*设备编号                               */
fih02       varchar2(10) NOT NULL,   /*仪表编号                               */
fih03       date NOT NULL,           /*日期                                   */
fih04       varchar2(6) NOT NULL,    /*时间                                   */
fih05       number(15,3)             /*数值                                   */
);

alter table fih_file add  constraint fih_pk primary key  (fih01,fih02,fih03,fih04) enable validate;
grant select on fih_file to tiptopgp;
grant update on fih_file to tiptopgp;
grant delete on fih_file to tiptopgp;
grant insert on fih_file to tiptopgp;
grant index on fih_file to public;
grant select on fih_file to ods;
