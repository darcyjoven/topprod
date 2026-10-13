/*
================================================================================
檔案代號:cou_file
檔案名稱:进口设备报关基本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cou_file
(
cou01       varchar2(30) NOT NULL,   /*预报关单号                             */
cou02       varchar2(30),            /*报关单号                               */
cou03       varchar2(20),            /*备案编号                               */
cou04       varchar2(20),            /*合同编号                               */
cou05       varchar2(20),            /*发货单位                               */
cou06       date,                    /*单据日期                               */
cou07       varchar2(20),            /*收货单位                               */
cou08       date,                    /*进口日期                               */
cou09       varchar2(6),             /*贸易性质                               */
cou10       varchar2(10),            /*贸易国家                               */
cou11       varchar2(4),             /*币种                                   */
cou12       varchar2(20),            /*通知单号                               */
cou13       number(5),               /*总件数                                 */
cou14       number(15,3),            /*总重量(公斤)                           */
cou15       varchar2(10),            /*集装箱号码                             */
couacti     varchar2(1),             /*资料有效码                             */
couuser     varchar2(10),            /*资料所有者                             */
cougrup     varchar2(10),            /*资料所有部门                           */
coumodu     varchar2(10),            /*资料更改者                             */
coudate     date,                    /*最近更改日                             */
couud01     varchar2(255),           /*自订字段-Textedit                      */
couud02     varchar2(40),            /*自订字段-文字                          */
couud03     varchar2(40),            /*自订字段-文字                          */
couud04     varchar2(40),            /*自订字段-文字                          */
couud05     varchar2(40),            /*自订字段-文字                          */
couud06     varchar2(40),            /*自订字段-文字                          */
couud07     number(15,3),            /*自订字段-数值                          */
couud08     number(15,3),            /*自订字段-数值                          */
couud09     number(15,3),            /*自订字段-数值                          */
couud10     number(10),              /*自订字段-整数                          */
couud11     number(10),              /*自订字段-整数                          */
couud12     number(10),              /*自订字段-整数                          */
couud13     date,                    /*自订字段-日期                          */
couud14     date,                    /*自订字段-日期                          */
couud15     date,                    /*自订字段-日期                          */
couplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coulegal    varchar2(10) NOT NULL,   /*所属法人                               */
couorig     varchar2(10),            /*资料建立部门                           */
couoriu     varchar2(10)             /*资料建立者                             */
);

alter table cou_file add  constraint cou_pk primary key  (cou01) enable validate;
grant select on cou_file to tiptopgp;
grant update on cou_file to tiptopgp;
grant delete on cou_file to tiptopgp;
grant insert on cou_file to tiptopgp;
grant index on cou_file to public;
grant select on cou_file to ods;
