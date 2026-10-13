/*
================================================================================
檔案代號:alg_file
檔案名稱:信贷银行档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table alg_file
(
alg01       varchar2(20) DEFAULT ' ' NOT NULL, /*信贷银行编号*/
                                     /*信貸銀行編號                           */
alg02       varchar2(40),            /*信贷银行简称                           */
                                     /*信貸銀行簡稱                           */
alg021      varchar2(80),            /*信贷银行全名                           */
                                     /*信貸銀行全名                           */
alg03       varchar2(1),             /*No Use                                 */
alg04       number(5),               /*No Use                                 */
alg05       number(5,3),             /*No Use                                 */
alg06       number(5,3),             /*No Use                                 */
alg07       varchar2(4),             /*No Use                                 */
alg08       number(15,3),            /*No Use                                 */
alg09       varchar2(1),             /*No Use                                 */
alg10       varchar2(1),             /*No Use                                 */
alg11       varchar2(1),             /*No Use                                 */
alg12       varchar2(1),             /*No Use                                 */
alg13       date,                    /*No Use                                 */
alg14       date,                    /*No Use                                 */
alg15       number(15,3),            /*No Use                                 */
alg16       number(15,3),            /*No Use                                 */
alg17       varchar2(1),             /*No Use                                 */
alg18       varchar2(1),             /*No Use                                 */
alg19       varchar2(1)              /*No Use                                 */
);

alter table alg_file add  constraint alg_pk primary key  (alg01) enable validate;
grant select on alg_file to tiptopgp;
grant update on alg_file to tiptopgp;
grant delete on alg_file to tiptopgp;
grant insert on alg_file to tiptopgp;
grant index on alg_file to public;
grant select on alg_file to ods;
