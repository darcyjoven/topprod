/*
================================================================================
檔案代號:oov_file
檔案名稱:应收账款待抵冲账记录档
檔案目的: 储存应收帐款待抵冲帐(预付或借支)记录档
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oov_file
(
oov01       varchar2(20) NOT NULL,   /*帐款单号                               */
oov02       number(5) NOT NULL,      /*项次                                   */
oov03       varchar2(20),            /*应收帐款编号                           */
oov04f      number(20,6),            /*原币冲帐金额                           */
oov04       number(20,6),            /*本币冲帐金额                           */
oov05       number(5),               /*子帐期项次                             */
oovlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oov_02 on oov_file (oov03);
alter table oov_file add  constraint oov_pk primary key  (oov01,oov02) enable validate;
grant select on oov_file to tiptopgp;
grant update on oov_file to tiptopgp;
grant delete on oov_file to tiptopgp;
grant insert on oov_file to tiptopgp;
grant index on oov_file to public;
grant select on oov_file to ods;
