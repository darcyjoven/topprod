/*
================================================================================
檔案代號:oap_file
檔案名稱:单据出货地址档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oap_file
(
oap01       varchar2(20) NOT NULL,   /*单据单号                               */
                                     /*單據單號                               */
oap02       varchar2(1),             /*No Use                                 */
oap03       varchar2(80),            /*全名                                   */
                                     /*全名 (no use)                          */
oap041      varchar2(255),           /*地址                                   */
oap042      varchar2(255),           /*地址                                   */
oap043      varchar2(255),           /*地址                                   */
oap044      varchar2(255),           /*地址-4                                 */
oap045      varchar2(255)            /*地址-5                                 */
);

alter table oap_file add  constraint oap_pk primary key  (oap01) enable validate;
grant select on oap_file to tiptopgp;
grant update on oap_file to tiptopgp;
grant delete on oap_file to tiptopgp;
grant insert on oap_file to tiptopgp;
grant index on oap_file to public;
grant select on oap_file to ods;
