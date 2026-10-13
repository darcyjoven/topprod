/*
================================================================================
檔案代號:npm_file
檔案名稱:应付票据异动记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npm_file
(
npm01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
npm02       number(5) NOT NULL,      /*单据项次                               */
                                     /*單據項次                               */
npm03       varchar2(20),            /*开票单号                               */
                                     /*開票單號                               */
npm04       number(20,6),            /*票面金额                               */
                                     /*票面金額                               */
npm05       number(20,6),            /*本币开{票金额                          */
npm06       number(20,6),            /*本币异动金额                           */
                                     /*本幣異動金額                           */
npm07       varchar2(1),             /*原票况                                 */
                                     /*原票況                                 */
npm08       date,                    /*原异动日期                             */
                                     /*原異動日期                             */
npmud01     varchar2(255),           /*自订字段-Textedit                      */
npmud02     varchar2(40),            /*自订字段-文字                          */
npmud03     varchar2(40),            /*自订字段-文字                          */
npmud04     varchar2(40),            /*自订字段-文字                          */
npmud05     varchar2(40),            /*自订字段-文字                          */
npmud06     varchar2(40),            /*自订字段-文字                          */
npmud07     number(15,3),            /*自订字段-数值                          */
npmud08     number(15,3),            /*自订字段-数值                          */
npmud09     number(15,3),            /*自订字段-数值                          */
npmud10     number(10),              /*自订字段-整数                          */
npmud11     number(10),              /*自订字段-整数                          */
npmud12     number(10),              /*自订字段-整数                          */
npmud13     date,                    /*自订字段-日期                          */
npmud14     date,                    /*自订字段-日期                          */
npmud15     date,                    /*自订字段-日期                          */
npmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
npm09       varchar2(20)             /*实际付款银行                           */
);

create        index npm_04 on npm_file (npm03);
alter table npm_file add  constraint npm_pk primary key  (npm01,npm02) enable validate;
grant select on npm_file to tiptopgp;
grant update on npm_file to tiptopgp;
grant delete on npm_file to tiptopgp;
grant insert on npm_file to tiptopgp;
grant index on npm_file to public;
grant select on npm_file to ods;
