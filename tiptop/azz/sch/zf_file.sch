/*
================================================================================
檔案代號:zf_file
檔案名稱:程序结构关连档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zf_file
(
zf01        varchar2(20) NOT NULL,   /*主程序编号                             */
                                     /*主程式編號                             */
zf02        number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
zf03        varchar2(20)             /*副程序编号                             */
                                     /*副程式編號                             */
);

create unique index zf_02 on zf_file (zf01,zf03);
alter table zf_file add  constraint zf_pk primary key  (zf01,zf02) enable validate;
grant select on zf_file to tiptopgp;
grant update on zf_file to tiptopgp;
grant delete on zf_file to tiptopgp;
grant insert on zf_file to tiptopgp;
grant index on zf_file to public;
grant select on zf_file to ods;
