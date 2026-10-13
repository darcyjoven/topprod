/*
================================================================================
檔案代號:oag_file
檔案名稱:收款条件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oag_file
(
oag01       varchar2(6) NOT NULL,    /*收款条件编号                           */
                                     /*收款條件編號                           */
oag02       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
oag03       varchar2(1),             /*应收款日                               */
                                     /*應收款日(客戶付款)起算基準 (1/4)       */
                                     /*  1.出貨日       (Net N Days)          */
                                     /*  4.出貨日次月初 (月結 N Days)         */
oag041      number(5),               /*应收款日为起算日起加几月               */
                                     /*A/R Date Is Months Plus from Initial Date 010504 add*/
oag04       number(5),               /*应收款日为起算日起加几天               */
                                     /*應收款日為起算日起加幾天               */
oag05       number(9,4),             /*折扣率                                 */
                                     /*折扣率(%)                              */
oag06       varchar2(1),             /*票到期日                               */
                                     /*票到期日(現金入帳)起算基準(1/3/4)      */
                                     /*  1.出貨日       (Net N Days)          */
                                     /*  4.出貨日次月初 (月結 N Days)         */
                                     /*  3.應收款日                           */
oag071      number(5),               /*票据到期日为起算日起加几月             */
                                     /*票據到期日為起算日起加幾月  010504 add */
oag07       number(5),               /*票据到期日为起算日起加几天             */
                                     /*票據到期日為起算日起加幾天             */
oag08       varchar2(1),             /*No Use                                 */
oag09       varchar2(1)              /*No Use                                 */
);

alter table oag_file add  constraint oag_pk primary key  (oag01) enable validate;
grant select on oag_file to tiptopgp;
grant update on oag_file to tiptopgp;
grant delete on oag_file to tiptopgp;
grant insert on oag_file to tiptopgp;
grant index on oag_file to public;
grant select on oag_file to ods;
