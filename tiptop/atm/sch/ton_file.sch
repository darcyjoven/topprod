/*
================================================================================
檔案代號:ton_file
檔案名稱:广告素材明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ton_file
(
ton01       varchar2(10) NOT NULL,   /*合约编号                               */
ton02       number(5) NOT NULL,      /*合约项次                               */
ton03       number(5) NOT NULL,      /*素材项次                               */
ton04       varchar2(7),             /*素材编号                               */
ton05       varchar2(4),             /*节目编号                               */
ton06       varchar2(8),             /*节目段                                 */
ton07       number(9),               /*次数                                   */
ton08       date,                    /*播出日期                               */
ton09       varchar2(5),             /*播出时间                               */
ton10       varchar2(255),           /*备注                                   */
tonud01     varchar2(255),           /*自订字段-Textedit                      */
tonud02     varchar2(40),            /*自订字段-文字                          */
tonud03     varchar2(40),            /*自订字段-文字                          */
tonud04     varchar2(40),            /*自订字段-文字                          */
tonud05     varchar2(40),            /*自订字段-文字                          */
tonud06     varchar2(40),            /*自订字段-文字                          */
tonud07     number(15,3),            /*自订字段-数值                          */
tonud08     number(15,3),            /*自订字段-数值                          */
tonud09     number(15,3),            /*自订字段-数值                          */
tonud10     number(10),              /*自订字段-整数                          */
tonud11     number(10),              /*自订字段-整数                          */
tonud12     number(10),              /*自订字段-整数                          */
tonud13     date,                    /*自订字段-日期                          */
tonud14     date,                    /*自订字段-日期                          */
tonud15     date                     /*自订字段-日期                          */
);

alter table ton_file add  constraint ton_pk primary key  (ton01,ton02,ton03) enable validate;
grant select on ton_file to tiptopgp;
grant update on ton_file to tiptopgp;
grant delete on ton_file to tiptopgp;
grant insert on ton_file to tiptopgp;
grant index on ton_file to public;
grant select on ton_file to ods;
