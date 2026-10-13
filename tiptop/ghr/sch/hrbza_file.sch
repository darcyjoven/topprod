/*
================================================================================
檔案代號:hrbza_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbza_file
(
hrbza01     number(2) NOT NULL,      /*序号                                   */
hrbza02     varchar2(20) NOT NULL,   /*班次编号                               */
hrbza03     varchar2(60) NOT NULL,   /*班次名称                               */
hrbza04     varchar2(255),           /*备注                                   */
hrbza05     varchar2(20) NOT NULL    /*班次群组编号                           */
);

alter table hrbza_file add  constraint tpc_hrbza_pk primary key  (hrbza01,hrbza05) enable validate;
grant select on hrbza_file to tiptopgp;
grant update on hrbza_file to tiptopgp;
grant delete on hrbza_file to tiptopgp;
grant insert on hrbza_file to tiptopgp;
grant index on hrbza_file to public;
grant select on hrbza_file to ods;
