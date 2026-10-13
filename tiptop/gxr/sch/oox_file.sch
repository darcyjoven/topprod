/*
================================================================================
檔案代號:oox_file
檔案名稱:月底重评价异动记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oox_file
(
oox00       varchar2(2) NOT NULL,    /*类型                                   */
                                     /*類型  AR.應收帳款  AP.應付帳款         */
                                     /*      NM.銀行存款                      */
                                     /*      NR.應收票據  NP.應付票據  NO.A058*/
oox01       number(5) NOT NULL,      /*年度                                   */
oox02       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
oox03v      varchar2(2),             /*类型                                   */
                                     /*類別                            NO.A048*/
                                     /*AR/AP 時, 1*.立帳  2*.待抵             */
                                     /*NM    時, 1 .銀行存款  2.匯款入帳      */
                                     /*NR    時, 1 .收票  2.質押       NO.A058*/
                                     /*NP    時, 1 .開票               NO.A058*/
oox03       varchar2(20) NOT NULL,   /*异动单号                               */
                                     /*異動單號                               */
oox04       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oox05       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
oox06       number(20,10),           /*上月重估汇率                           */
                                     /*上月重估匯率                           */
oox07       number(20,10),           /*本月重估汇率                           */
                                     /*本月重估匯率                           */
oox08       number(20,6),            /*本币未冲金额                           */
                                     /*本幣未沖金額                           */
oox09       number(20,6),            /*本币重估金额                           */
                                     /*本幣重估金額                           */
oox10       number(20,6),            /*汇兑损益                               */
                                     /*匯兌損益                               */
oox041      number(5) DEFAULT '0' NOT NULL, /*项次*/
ooxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ooxcrat     date,                    /*资料创建日                             */
ooxgrup     varchar2(10),            /*资料所有群                             */
ooxmodu     varchar2(10),            /*资料更改者                             */
ooxorig     varchar2(10),            /*资料建立部门                           */
ooxoriu     varchar2(10),            /*资料建立者                             */
ooxuser     varchar2(10),            /*资料所有者                             */
ooxacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ooxdate     date,                    /*最近更改日                             */
oox11       number(20,6)             /*原币未冲金额                           */
);

create        index oox_01 on oox_file (oox03,oox04,oox02,oox01,oox00);
alter table oox_file add  constraint oox_pk primary key  (oox00,oox01,oox02,oox03,oox04,oox041) enable validate;
grant select on oox_file to tiptopgp;
grant update on oox_file to tiptopgp;
grant delete on oox_file to tiptopgp;
grant insert on oox_file to tiptopgp;
grant index on oox_file to public;
grant select on oox_file to ods;
