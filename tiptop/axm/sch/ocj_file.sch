/*
================================================================================
檔案代號:ocj_file
檔案名稱:客户往来银行资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocj_file
(
ocj01       varchar2(10) NOT NULL,   /*客户编号                               */
ocj02       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行代號                               */
ocj03       varchar2(30) NOT NULL,   /*银行帐号                               */
                                     /*銀行帳號                               */
ocjacti     varchar2(1),             /*资料有效码                             */
ocj04       varchar2(80),            /*帐号名称                               */
ocj05       varchar2(1),             /*是否主要帐号                           */
ocj06       varchar2(80),            /*帐户Email                              */
ocj07       varchar2(80),            /*附加Email                              */
ocj08       varchar2(80),            /*户名                                   */
ocj09       varchar2(40)             /*FAX                                    */
);

alter table ocj_file add  constraint ocj_pk primary key  (ocj01,ocj02,ocj03) enable validate;
grant select on ocj_file to tiptopgp;
grant update on ocj_file to tiptopgp;
grant delete on ocj_file to tiptopgp;
grant insert on ocj_file to tiptopgp;
grant index on ocj_file to public;
grant select on ocj_file to ods;
