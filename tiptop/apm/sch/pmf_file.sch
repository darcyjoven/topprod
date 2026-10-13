/*
================================================================================
檔案代號:pmf_file
檔案名稱:供应厂商往来银行资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmf_file
(
pmf01       varchar2(10) NOT NULL,   /*供应厂商编号                           */
                                     /*供應廠商編號                           */
pmf02       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行代號                               */
pmf03       varchar2(30) NOT NULL,   /*银行帐号                               */
                                     /*銀行帳號                               */
pmfacti     varchar2(1),             /*资料有效码                             */
pmf04       varchar2(80),            /*帐号名称                               */
pmf05       varchar2(1),             /*是否主要帐号                           */
pmf06       varchar2(80),            /*帐户Email                              */
pmf07       varchar2(80),            /*附加Email                              */
pmf08       varchar2(4),             /*币种                                   */
pmf09       varchar2(80),            /*户名                                   */
pmf10       varchar2(40),            /*FAX                                    */
pmf11       varchar2(1),             /*全额到否                               */
pmf12       varchar2(10),            /*FAX                                    */
pmf13       varchar2(20),            /*SWIFT CODE                             */
pmf14       varchar2(10),            /*汇款性质编号                           */
pmf15       varchar2(1) DEFAULT ' ' NOT NULL /*收费别*/
);

alter table pmf_file add  constraint pmf_pk primary key  (pmf01,pmf02,pmf03) enable validate;
grant select on pmf_file to tiptopgp;
grant update on pmf_file to tiptopgp;
grant delete on pmf_file to tiptopgp;
grant insert on pmf_file to tiptopgp;
grant index on pmf_file to public;
grant select on pmf_file to ods;
