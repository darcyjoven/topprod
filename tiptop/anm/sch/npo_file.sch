/*
================================================================================
檔案代號:npo_file
檔案名稱:应收票据异动记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npo_file
(
npo01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
npo02       number(5) NOT NULL,      /*单据项次                               */
                                     /*單據項次                               */
npo03       varchar2(20),            /*开票单号                               */
                                     /*開票單號                               */
npo04       number(20,6),            /*票面金额                               */
                                     /*票面金額                               */
npo05       number(20,6),            /*本币开票金额                           */
                                     /*本幣開票金額                           */
npo06       number(20,6),            /*本币异动金额                           */
                                     /*本幣異動金額                           */
npo07       varchar2(1),             /*原票况                                 */
                                     /*原票況                                 */
npo08       date,                    /*原异动日期                             */
                                     /*原異動日期                             */
npoud01     varchar2(255),           /*自订字段-Textedit                      */
npoud02     varchar2(40),            /*自订字段-文字                          */
npoud03     varchar2(40),            /*自订字段-文字                          */
npoud04     varchar2(40),            /*自订字段-文字                          */
npoud05     varchar2(40),            /*自订字段-文字                          */
npoud06     varchar2(40),            /*自订字段-文字                          */
npoud07     number(15,3),            /*自订字段-数值                          */
npoud08     number(15,3),            /*自订字段-数值                          */
npoud09     number(15,3),            /*自订字段-数值                          */
npoud10     number(10),              /*自订字段-整数                          */
npoud11     number(10),              /*自订字段-整数                          */
npoud12     number(10),              /*自订字段-整数                          */
npoud13     date,                    /*自订字段-日期                          */
npoud14     date,                    /*自订字段-日期                          */
npoud15     date,                    /*自订字段-日期                          */
npolegal    varchar2(10) NOT NULL,   /*所属法人                               */
npo09       number(20,6) DEFAULT '0' NOT NULL, /*本币手续费*/
npo10       number(20,6) DEFAULT '0' NOT NULL /*原币手续费*/
);

create        index npo_04 on npo_file (npo03);
alter table npo_file add  constraint npo_pk primary key  (npo01,npo02) enable validate;
grant select on npo_file to tiptopgp;
grant update on npo_file to tiptopgp;
grant delete on npo_file to tiptopgp;
grant insert on npo_file to tiptopgp;
grant index on npo_file to public;
grant select on npo_file to ods;
