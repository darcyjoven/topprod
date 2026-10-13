/*
================================================================================
檔案代號:nna_file
檔案名稱:银行账户支票簿号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nna_file
(
nna01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
nna021      date NOT NULL,           /*取票日期                               */
nna02       number(5) NOT NULL,      /*簿号                                   */
                                     /*簿號                                   */
nna03       varchar2(20),            /*下次打印支票号                         */
                                     /*下次列印支票號                         */
nna04       number(5),               /*支票号码位数                           */
                                     /*支票號碼位數                           */
nna05       number(5),               /*后几位连续编号                         */
                                     /*後幾位連續編號                         */
nna06       varchar2(1),             /*是否套印支票                           */
nna07       varchar2(1),             /*No Use                                 */
nna08       varchar2(1)              /*No Use                                 */
);

alter table nna_file add  constraint nna_pk primary key  (nna01,nna021,nna02) enable validate;
grant select on nna_file to tiptopgp;
grant update on nna_file to tiptopgp;
grant delete on nna_file to tiptopgp;
grant insert on nna_file to tiptopgp;
grant index on nna_file to public;
grant select on nna_file to ods;
