/*
================================================================================
檔案代號:ocd_file
檔案名稱:客户其它地址档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocd_file
(
ocd01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
ocd02       varchar2(10) NOT NULL,   /*客户地址                               */
ocd03       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
ocd04       varchar2(10),            /*邮递区号                               */
                                     /*郵遞區號                               */
ocd221      varchar2(255),           /*地址-1                                 */
ocd222      varchar2(255),           /*地址-2                                 */
ocd223      varchar2(255),           /*地址-3                                 */
ocd224      varchar2(40),            /*电话-1                                 */
ocd225      varchar2(40),            /*电话-2                                 */
ocd226      varchar2(40),            /*传真-1                                 */
ocd227      varchar2(40),            /*传真-2                                 */
ocd228      varchar2(40),            /*联络人-1                               */
ocd229      varchar2(40),            /*联络人-2                               */
ocd230      varchar2(255),           /*地址-4                                 */
ocd231      varchar2(255)            /*地址-5                                 */
);

alter table ocd_file add  constraint ocd_pk primary key  (ocd01,ocd02) enable validate;
grant select on ocd_file to tiptopgp;
grant update on ocd_file to tiptopgp;
grant delete on ocd_file to tiptopgp;
grant insert on ocd_file to tiptopgp;
grant index on ocd_file to public;
grant select on ocd_file to ods;
