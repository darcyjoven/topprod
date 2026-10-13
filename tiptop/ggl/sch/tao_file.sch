/*
================================================================================
檔案代號:tao_file
檔案名稱:部门科目币种余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tao_file
(
tao00       varchar2(5) NOT NULL,    /*帐套                                   */
                                     /*帳別                                   */
tao01       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號  Course No                    */
tao02       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門  Cost Center                      */
tao03       number(5) NOT NULL,      /*会计年度                               */
                                     /*會計年度                               */
tao04       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
tao05       number(20,6),            /*借方余额                               */
                                     /*借方餘額                               */
tao06       number(20,6),            /*贷方余额                               */
                                     /*貸方餘額                               */
tao07       number(15,3),            /*借方笔数                               */
                                     /*借方筆數                               */
tao08       number(15,3),            /*贷方笔数                               */
                                     /*貸方筆數                               */
tao09       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                          02/02/26 */
tao10       number(20,6),            /*原币借方金额                           */
                                     /*原幣借方金額                  02/02/26 */
tao11       number(20,6),            /*原币贷方金额                           */
                                     /*原幣貸方金額                  02/02/26 */
taolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tao_file add  constraint tao_pk primary key  (tao01,tao02,tao03,tao04,tao09,tao00) enable validate;
grant select on tao_file to tiptopgp;
grant update on tao_file to tiptopgp;
grant delete on tao_file to tiptopgp;
grant insert on tao_file to tiptopgp;
grant index on tao_file to public;
grant select on tao_file to ods;
