/*
================================================================================
檔案代號:pmt_file
檔案名稱:常用特殊说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmt_file
(
pmt01       varchar2(4) NOT NULL,    /*特殊常用说明编号                       */
                                     /*特殊常用說明編號                       */
pmt03       number(5) NOT NULL,      /*行序                                   */
pmt04       varchar2(255)            /*说明                                   */
                                     /*說明                                   */
);

alter table pmt_file add  constraint pmt_pk primary key  (pmt01,pmt03) enable validate;
grant select on pmt_file to tiptopgp;
grant update on pmt_file to tiptopgp;
grant delete on pmt_file to tiptopgp;
grant insert on pmt_file to tiptopgp;
grant index on pmt_file to public;
grant select on pmt_file to ods;
