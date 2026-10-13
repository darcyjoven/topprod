/*
================================================================================
檔案代號:apg_file
檔案名稱:付款单借方单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apg_file
(
apg01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號 apf01                         */
apg02       number(5) NOT NULL,      /*借方项次                               */
                                     /*借方項次                               */
apg03       varchar2(10),            /*帐款营运中心                           */
                                     /*Account Plant azp01                    */
apg04       varchar2(20),            /*帐款编号                               */
                                     /*帳款編號 apa01                         */
apg05f      number(20,6) NOT NULL,   /*原币冲帐金额                           */
                                     /*原幣沖帳金額                           */
apg05       number(20,6) NOT NULL,   /*本币冲帐金额                           */
                                     /*本幣沖帳金額                           */
apg06       number(5),               /*子帐期项次                             */
apgud01     varchar2(255),           /*自订字段-Textedit                      */
apgud02     varchar2(40),            /*自订字段-文字                          */
apgud03     varchar2(40),            /*自订字段-文字                          */
apgud04     varchar2(40),            /*自订字段-文字                          */
apgud05     varchar2(40),            /*自订字段-文字                          */
apgud06     varchar2(40),            /*自订字段-文字                          */
apgud07     number(15,3),            /*自订字段-数值                          */
apgud08     number(15,3),            /*自订字段-数值                          */
apgud09     number(15,3),            /*自订字段-数值                          */
apgud10     number(10),              /*自订字段-整数                          */
apgud11     number(10),              /*自订字段-整数                          */
apgud12     number(10),              /*自订字段-整数                          */
apgud13     date,                    /*自订字段-日期                          */
apgud14     date,                    /*自订字段-日期                          */
apgud15     date,                    /*自订字段-日期                          */
apglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index apg_02 on apg_file (apg04);
alter table apg_file add  constraint apg_pk primary key  (apg01,apg02) enable validate;
grant select on apg_file to tiptopgp;
grant update on apg_file to tiptopgp;
grant delete on apg_file to tiptopgp;
grant insert on apg_file to tiptopgp;
grant index on apg_file to public;
grant select on apg_file to ods;
