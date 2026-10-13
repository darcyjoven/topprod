/*
================================================================================
檔案代號:ted_file
檔案名稱:科目币种核算项冲账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ted_file
(
ted00       varchar2(5) NOT NULL,    /*帐套                                   */
                                     /*帳別                                   */
ted01       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號 (明細或獨立科目)              */
ted011      varchar2(2) NOT NULL,    /*核算项顺序                             */
                                     /*異動碼順序                             */
ted02       varchar2(30) NOT NULL,   /*核算项值                               */
                                     /*異動碼值                               */
ted03       number(5) NOT NULL,      /*会计年度                               */
                                     /*會計年度                               */
ted04       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
ted05       number(20,6),            /*借方总金额                             */
                                     /*借方總金額                             */
ted06       number(20,6),            /*贷方总金额                             */
                                     /*貸方總金額                             */
ted07       number(5),               /*借方总笔数                             */
                                     /*借方總筆數                             */
ted08       number(5),               /*贷方总笔数                             */
                                     /*貸方總筆數                             */
ted09       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
ted10       number(20,6),            /*原币借方金额                           */
                                     /*原幣借方金額                           */
ted11       number(20,6),            /*原币贷方金额                           */
                                     /*原幣貸方金額                           */
ted012      varchar2(10),            /*核算项类型编号                         */
                                     /*#FUN-5C0015                            */
tedlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ted_file add  constraint ted_pk primary key  (ted01,ted02,ted03,ted04,ted09,ted00,ted011) enable validate;
grant select on ted_file to tiptopgp;
grant update on ted_file to tiptopgp;
grant delete on ted_file to tiptopgp;
grant insert on ted_file to tiptopgp;
grant index on ted_file to public;
grant select on ted_file to ods;
