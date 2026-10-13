/*
================================================================================
檔案代號:oqd_file
檔案名稱:其他费用资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqd_file
(
oqd01       varchar2(20) NOT NULL,   /*估价单号                               */
                                     /*估價單號                               */
oqd02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oqd03       varchar2(255),           /*费用说明                               */
                                     /*費用說明                               */
oqd04       number(20,6),            /*估价金额                               */
                                     /*估價金額                               */
oqdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqd_file add  constraint oqd_pk primary key  (oqd01,oqd02) enable validate;
grant select on oqd_file to tiptopgp;
grant update on oqd_file to tiptopgp;
grant delete on oqd_file to tiptopgp;
grant insert on oqd_file to tiptopgp;
grant index on oqd_file to public;
grant select on oqd_file to ods;
