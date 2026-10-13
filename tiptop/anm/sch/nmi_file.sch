/*
================================================================================
檔案代號:nmi_file
檔案名稱:应收票据状况异动记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmi_file
(
nmi01       varchar2(20) NOT NULL,   /*票号                                   */
                                     /*票號(應收票據)                         */
nmi02       date,                    /*异动日期                               */
                                     /*異動日期                               */
nmi03       varchar2(5) NOT NULL,    /*异动序号                               */
                                     /*異動序號                               */
nmi04       varchar2(30),            /*承办人                                 */
                                     /*承辦人                                 */
nmi05       varchar2(1),             /*原票况                                 */
                                     /*原票況 'X':其它系統轉入                */
nmi06       varchar2(1),             /*新票况                                 */
                                     /*新票況                                 */
nmi07       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
nmi08       number(20,10),           /*上次异动汇率                           */
                                     /*上次異動匯率                           */
nmi09       number(20,10),           /*本次异动汇率                           */
                                     /*本次異動匯率                           */
nmi10       varchar2(20),            /*异动单号                               */
                                     /*異動單號 98/08/24                      */
nmi11       date,                    /*凭证日期                               */
                                     /*no use                                 */
nmilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index nmi_02 on nmi_file (nmi10);
alter table nmi_file add  constraint nmi_pk primary key  (nmi01,nmi03) enable validate;
grant select on nmi_file to tiptopgp;
grant update on nmi_file to tiptopgp;
grant delete on nmi_file to tiptopgp;
grant insert on nmi_file to tiptopgp;
grant index on nmi_file to public;
grant select on nmi_file to ods;
