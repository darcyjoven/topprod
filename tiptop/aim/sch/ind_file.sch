/*
================================================================================
檔案代號:ind_file
檔案名稱:料件/单据相关之档案路径档案资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ind_file
(
ind01       varchar2(40) NOT NULL,   /*料件编号/单据编号                      */
                                     /*料件編號/單據編號 Key Value - 1        */
ind02       number(5) NOT NULL,      /*项次                                   */
                                     /*                  Key Value - 2        */
ind03       varchar2(80),            /*档名                                   */
                                     /*                  Key Value - 3        */
ind04       varchar2(255)            /*备注                                   */
                                     /*                  Key Value - 4        */
);

alter table ind_file add  constraint ind_pk primary key  (ind01,ind02) enable validate;
grant select on ind_file to tiptopgp;
grant update on ind_file to tiptopgp;
grant delete on ind_file to tiptopgp;
grant insert on ind_file to tiptopgp;
grant index on ind_file to public;
grant select on ind_file to ods;
