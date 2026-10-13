/*
================================================================================
檔案代號:zmm_file
檔案名稱:用户我的最爱目录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zmm_file
(
zmm01       varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號                             */
zmm03       varchar2(20) NOT NULL    /*程序编号                               */
                                     /*程式代號(Program code)                 */
);

alter table zmm_file add  constraint zmm_pk primary key  (zmm01,zmm03) enable validate;
grant select on zmm_file to tiptopgp;
grant update on zmm_file to tiptopgp;
grant delete on zmm_file to tiptopgp;
grant insert on zmm_file to tiptopgp;
grant index on zmm_file to public;
grant select on zmm_file to ods;
