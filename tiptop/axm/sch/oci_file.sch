/*
================================================================================
檔案代號:oci_file
檔案名稱:客户主档--for多角贸易相关资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oci_file
(
oci01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
oci02       varchar2(2) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
                                     /* 10: Remark                            */
                                     /* 50: Shipping Mark                     */
                                     /* 90: Notify                            */
                                     /* 99: Consignee                         */
oci03       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
oci11       varchar2(80),            /*说明一                                 */
                                     /*說明一                                 */
                                     /* 10: Remark  char(60)                  */
                                     /* 50: Shipping Mark  char(20)           */
                                     /* 90: Notify  char(36)                  */
                                     /* 99: Consignee char(36)                */
oci12       varchar2(80),            /*说明二                                 */
                                     /*說明二                                 */
oci13       varchar2(80),            /*说明三                                 */
                                     /*說明三                                 */
oci14       varchar2(80),            /*说明四                                 */
                                     /*說明四                                 */
oci15       varchar2(80),            /*说明五                                 */
                                     /*說明五                                 */
oci16       varchar2(80),            /*说明六                                 */
                                     /*說明六                                 */
oci17       varchar2(80),            /*说明七                                 */
                                     /*說明七                                 */
oci18       varchar2(80),            /*说明八                                 */
                                     /*說明八                                 */
oci19       varchar2(60),            /*No Use                                 */
oci20       varchar2(60)             /*No Use                                 */
);

alter table oci_file add  constraint oci_pk primary key  (oci01,oci02,oci03) enable validate;
grant select on oci_file to tiptopgp;
grant update on oci_file to tiptopgp;
grant delete on oci_file to tiptopgp;
grant insert on oci_file to tiptopgp;
grant index on oci_file to public;
grant select on oci_file to ods;
