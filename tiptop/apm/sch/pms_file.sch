/*
================================================================================
檔案代號:pms_file
檔案名稱:常用特殊说明单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pms_file
(
pms01       varchar2(4) NOT NULL,    /*特殊常用说明编号                       */
                                     /*特殊常用說明編號                       */
pms02       varchar2(255)            /*备注                                   */
                                     /*Memo                                   */
                                     /*The Field Can Input Some Brief Explanation,So Can Differentiate The Purpose Of Sepecial Used Desc. Code Quickly Inquiry,May Speed Up Use Of Sepecial Used Desc.*/
);

alter table pms_file add  constraint pms_pk primary key  (pms01) enable validate;
grant select on pms_file to tiptopgp;
grant update on pms_file to tiptopgp;
grant delete on pms_file to tiptopgp;
grant insert on pms_file to tiptopgp;
grant index on pms_file to public;
grant select on pms_file to ods;
