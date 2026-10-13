/*
================================================================================
檔案代號:oqe_file
檔案名稱:估价单资料备注说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqe_file
(
oqe01       varchar2(20) NOT NULL,   /*估价单编号                             */
                                     /*估價單代號                             */
oqe02       number(5) NOT NULL,      /*估价单编号项次                         */
                                     /*估價單代號項次                         */
                                     /*單頭的編號為:0                         */
oqe03       number(5) NOT NULL,      /*行序                                   */
oqe04       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
oqeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqe_file add  constraint oqe_pk primary key  (oqe01,oqe02,oqe03) enable validate;
grant select on oqe_file to tiptopgp;
grant update on oqe_file to tiptopgp;
grant delete on oqe_file to tiptopgp;
grant insert on oqe_file to tiptopgp;
grant index on oqe_file to public;
grant select on oqe_file to ods;
