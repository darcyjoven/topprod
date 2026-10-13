/*
================================================================================
檔案代號:tc_image_file
檔案名稱:料件图片信息
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_image_file
(
tc_image01  varchar2(40) NOT NULL,   /*料件编号                               */
tc_image02  varchar2(40) NOT NULL    /*图片名称                               */
);

create unique index tic_image_01 on tc_image_file (tc_image01,tc_image02);
alter table tc_image_file add  constraint tpc_image_pk primary key  (tc_image01,tc_image02) enable validate;
grant select on tc_image_file to tiptopgp;
grant update on tc_image_file to tiptopgp;
grant delete on tc_image_file to tiptopgp;
grant insert on tc_image_file to tiptopgp;
grant index on tc_image_file to public;
grant select on tc_image_file to ods;
