/*
================================================================================
檔案代號:imw_file
檔案名稱:细部品名明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imw_file
(
imw01       varchar2(10) NOT NULL,   /*细部品名码                             */
                                     /*細部品名碼                             */
imw02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
imw03       varchar2(120)            /*细部品名                               */
                                     /*細部品名                               */
);

alter table imw_file add  constraint imw_pk primary key  (imw01,imw02) enable validate;
grant select on imw_file to tiptopgp;
grant update on imw_file to tiptopgp;
grant delete on imw_file to tiptopgp;
grant insert on imw_file to tiptopgp;
grant index on imw_file to public;
grant select on imw_file to ods;
