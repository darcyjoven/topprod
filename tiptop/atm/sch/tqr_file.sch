/*
================================================================================
檔案代號:tqr_file
檔案名稱:合同单身有条件返利条款档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqr_file
(
tqr01       varchar2(20) NOT NULL,   /*合约单号                               */
tqr02       varchar2(1) NOT NULL,    /*条件期间                               */
tqr03       number(20,6) NOT NULL,   /*起始金额                               */
tqr04       number(20,6) NOT NULL,   /*截至金额                               */
tqr05       number(15,3),            /*折扣比率                               */
tqr06       varchar2(1) DEFAULT ' ' NOT NULL, /*现返类型 1-单次返,2-累计返*/
tqr07       date DEFAULT sysdate NOT NULL, /*起始日期,适用此现返条件的开*/
tqr08       date DEFAULT sysdate NOT NULL, /*截止日期,适用此现返条件的截*/
tqr09       number(5) DEFAULT '0' NOT NULL, /*项次*/
tqr10       varchar2(10),            /*理由码                                 */
tqrud01     varchar2(255),           /*自订字段-Textedit                      */
tqrud02     varchar2(40),            /*自订字段-文字                          */
tqrud03     varchar2(40),            /*自订字段-文字                          */
tqrud04     varchar2(40),            /*自订字段-文字                          */
tqrud05     varchar2(40),            /*自订字段-文字                          */
tqrud06     varchar2(40),            /*自订字段-文字                          */
tqrud07     number(15,3),            /*自订字段-数值                          */
tqrud08     number(15,3),            /*自订字段-数值                          */
tqrud09     number(15,3),            /*自订字段-数值                          */
tqrud10     number(10),              /*自订字段-整数                          */
tqrud11     number(10),              /*自订字段-整数                          */
tqrud12     number(10),              /*自订字段-整数                          */
tqrud13     date,                    /*自订字段-日期                          */
tqrud14     date,                    /*自订字段-日期                          */
tqrud15     date,                    /*自订字段-日期                          */
tqrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqrlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tqr_file add  constraint tqr_pk primary key  (tqr01,tqr06,tqr07,tqr08,tqr03,tqr04) enable validate;
grant select on tqr_file to tiptopgp;
grant update on tqr_file to tiptopgp;
grant delete on tqr_file to tiptopgp;
grant insert on tqr_file to tiptopgp;
grant index on tqr_file to public;
grant select on tqr_file to ods;
