/*
================================================================================
檔案代號:icx_file
檔案名稱:NEW CODE申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table icx_file
(
icx01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号码*/
icx02       number(5) DEFAULT '0' NOT NULL, /*项次*/
icx03       varchar2(40) DEFAULT ' ' NOT NULL, /*产品型号*/
icx04       varchar2(10),            /*Number of Voice Sections               */
icx05       varchar2(10),            /*Number of Melody Sections              */
icx06       varchar2(10),            /*Number of Data Sections                */
icx07       varchar2(10),            /*Aproved By                             */
icx08       date,                    /*Program Date                           */
icx09       varchar2(10),            /*Program Length                         */
icx10       date,                    /*EPROM Date                             */
icx11       number(10),              /*EPROM Length                           */
icx12       varchar2(10),            /*Layout                                 */
icx13       date,                    /*Layout日期                             */
icx14       number(10),              /*Layout Size                            */
icx15       varchar2(10),            /*Check Sum                              */
icx16       varchar2(80),            /*Comment                                */
icx17       varchar2(10),            /*Customer Approval Signature            */
icx18       varchar2(80),            /*Remark                                 */
icx19       number(9,4),             /*Multi Die比例                          */
icx20       varchar2(1),             /*Status                                 */
icx21       varchar2(1),             /*New Code否                             */
icx22       varchar2(10),            /*版次                                   */
icx23       varchar2(80),            /*Program Name                           */
icx24       varchar2(80),            /*EPROM Name                             */
icx25       varchar2(1),             /*no use                                 */
icx26       varchar2(80),            /*子Code                                 */
icxud01     varchar2(255),           /*自订字段-Textedit                      */
icxud02     varchar2(40),            /*自订字段-文字                          */
icxud03     varchar2(40),            /*自订字段-文字                          */
icxud04     varchar2(40),            /*自订字段-文字                          */
icxud05     varchar2(40),            /*自订字段-文字                          */
icxud06     varchar2(40),            /*自订字段-文字                          */
icxud07     number(15,3),            /*自订字段-数值                          */
icxud08     number(15,3),            /*自订字段-数值                          */
icxud09     number(15,3),            /*自订字段-数值                          */
icxud10     number(10),              /*自订字段-整数                          */
icxud11     number(10),              /*自订字段-整数                          */
icxud12     number(10),              /*自订字段-整数                          */
icxud13     date,                    /*自订字段-日期                          */
icxud14     date,                    /*自订字段-日期                          */
icxud15     date,                    /*自订字段-日期                          */
icxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
icxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table icx_file add  constraint icx_pk primary key  (icx01,icx02,icx03) enable validate;
grant select on icx_file to tiptopgp;
grant update on icx_file to tiptopgp;
grant delete on icx_file to tiptopgp;
grant insert on icx_file to tiptopgp;
grant index on icx_file to public;
grant select on icx_file to ods;
