/*
================================================================================
檔案代號:nmf_file
檔案名稱:票据状况异动记录档(应付票据)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmf_file
(
nmf01       varchar2(20) NOT NULL,   /*开票单号                               */
                                     /*開票單號                               */
nmf02       date,                    /*异动日期                               */
                                     /*異動日期                               */
nmf03       varchar2(5) NOT NULL,    /*异动序号                               */
                                     /*異動序號                               */
nmf04       varchar2(30),            /*承办人                                 */
                                     /*承辦人                                 */
nmf05       varchar2(1),             /*原票况                                 */
                                     /*原票況 ('X':其它系統轉入)              */
nmf06       varchar2(1),             /*新票况                                 */
                                     /*新票況                                 */
nmf07       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號                               */
nmf08       number(20,10),           /*上次异动汇率                           */
                                     /*上次異動匯率                           */
nmf09       number(20,10),           /*本次异动汇率                           */
                                     /*本次異動匯率                           */
nmf11       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
nmf12       varchar2(20),            /*异动单号                               */
                                     /*異動單號                               */
nmf13       date,                    /*凭证日期                               */
                                     /*傳票日期                               */
nmflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index nmf_02 on nmf_file (nmf11);
alter table nmf_file add  constraint nmf_pk primary key  (nmf01,nmf03) enable validate;
grant select on nmf_file to tiptopgp;
grant update on nmf_file to tiptopgp;
grant delete on nmf_file to tiptopgp;
grant insert on nmf_file to tiptopgp;
grant index on nmf_file to public;
grant select on nmf_file to ods;
