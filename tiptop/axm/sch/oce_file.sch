/*
================================================================================
檔案代號:oce_file
檔案名稱:Customer Contact stalls
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oce_file
(
oce01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
oce02       varchar2(40),            /*职务                                   */
                                     /*職務                                   */
oce03       varchar2(40) NOT NULL,   /*联络人                                 */
                                     /*聯絡人                                 */
oce04       varchar2(40),            /*联络电话                               */
                                     /*聯絡電話                               */
oce05       varchar2(80),            /*E-mail address                         */
oce06       date,                    /*No Use                                 */
oce07       varchar2(40),            /*住宅号码                               */
oce08       varchar2(40),            /*传真号码                               */
oce09       varchar2(255),           /*身份证地址                             */
oce10       varchar2(20)             /*身份证号码                             */
);

alter table oce_file add  constraint oce_pk primary key  (oce01,oce03) enable validate;
grant select on oce_file to tiptopgp;
grant update on oce_file to tiptopgp;
grant delete on oce_file to tiptopgp;
grant insert on oce_file to tiptopgp;
grant index on oce_file to public;
grant select on oce_file to ods;
