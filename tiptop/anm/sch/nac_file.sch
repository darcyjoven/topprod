/*
================================================================================
檔案代號:nac_file
檔案名稱:内部银行账户档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nac_file
(
nac01       varchar2(20) DEFAULT ' ' NOT NULL, /*内部帐户编号*/
                                     /*For 內部帳戶                           */
nac02       varchar2(40),            /*内部帐户简称                           */
                                     /*For 內部帳戶                           */
nac03       varchar2(30),            /*内部帐户帐号                           */
                                     /*For 內部帳戶                           */
nac04       varchar2(4),             /*币种                                   */
                                     /*For 內部帳戶                           */
nac05       varchar2(10),            /*归属分公司编码                         */
                                     /*For 內部帳戶                           */
nac06       varchar2(1),             /*No Use                                 */
nac07       varchar2(1),             /*No Use                                 */
nacacti     varchar2(1),             /*资料有效码                             */
                                     /*For 內部帳戶                           */
nacuser     varchar2(10),            /*资料所有者                             */
                                     /*For 內部帳戶                           */
nacgrup     varchar2(10),            /*资料所有部门                           */
                                     /*For 內部帳戶                           */
nacmodu     varchar2(10),            /*资料更改者                             */
                                     /*For 內部帳戶                           */
nacdate     date,                    /*最后更改日期                           */
                                     /*For 內部帳戶                           */
nacorig     varchar2(10),            /*资料建立部门                           */
nacoriu     varchar2(10)             /*资料建立者                             */
);

alter table nac_file add  constraint nac_pk primary key  (nac01) enable validate;
grant select on nac_file to tiptopgp;
grant update on nac_file to tiptopgp;
grant delete on nac_file to tiptopgp;
grant insert on nac_file to tiptopgp;
grant index on nac_file to public;
grant select on nac_file to ods;
