/*
================================================================================
檔案代號:tah_file
檔案名稱:会计科目币种各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tah_file
(
tah00       varchar2(5) NOT NULL,    /*帐套编号                               */
                                     /*帳別編號                               */
tah01       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
tah02       number(5) NOT NULL,      /*会计年度                               */
                                     /*會計年度                               */
tah03       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
tah04       number(20,6) NOT NULL,   /*借方金额                               */
                                     /*借方金額                               */
tah05       number(20,6) NOT NULL,   /*贷方金额                               */
                                     /*貸方金額                               */
tah06       number(10),              /*借方笔数                               */
                                     /*借方筆數                               */
tah07       number(10),              /*贷方笔数                               */
                                     /*貸方筆數                               */
tah08       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
tah09       number(20,6),            /*原币借方金额                           */
                                     /*原幣借方金額                           */
tah10       number(20,6),            /*原币贷方金额                           */
                                     /*原幣貸方金額                           */
tahlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tah_file add  constraint tah_pk primary key  (tah01,tah02,tah03,tah08,tah00) enable validate;
grant select on tah_file to tiptopgp;
grant update on tah_file to tiptopgp;
grant delete on tah_file to tiptopgp;
grant insert on tah_file to tiptopgp;
grant index on tah_file to public;
grant select on tah_file to ods;
