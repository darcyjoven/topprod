/*
================================================================================
檔案代號:bxb_file
檔案名稱:保税委外加工进厂单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bxb_file
(
bxb01       varchar2(20) NOT NULL,   /*进厂单号                               */
bxb02       date,                    /*单据日期                               */
bxb03       varchar2(10),            /*加工厂商编号                           */
bxb04       varchar2(20),            /*委外入库单号                           */
bxb05       number(5),               /*项次                                   */
bxb06       varchar2(40),            /*产品品号                               */
bxb07       number(15,3),            /*进厂数量                               */
bxb08       date,                    /*进厂日期                               */
bxb09       varchar2(10),            /*审核者                                 */
bxb10       varchar2(10),            /*入库仓库                               */
bxb11       varchar2(10),            /*库位                                   */
bxb12       varchar2(24),            /*批号                                   */
bxb13       varchar2(10),            /*部门编号                               */
bxb14       varchar2(10),            /*保税人员                               */
bxb15       varchar2(255),           /*备注                                   */
bxb16       varchar2(20),            /*工单单号                               */
bxb17       date,                    /*运回截止日期                           */
bxb18       varchar2(30),            /*核准文号                               */
bxbconf     varchar2(1),             /*审核否(y/n/x)                          */
bxbuser     varchar2(10),            /*资料所有者                             */
bxbgrup     varchar2(10),            /*资料所有群                             */
bxbmodu     varchar2(10),            /*资料更改者                             */
bxbdate     date,                    /*最近更改日                             */
bxbud01     varchar2(255),           /*自订字段-Textedit                      */
bxbud02     varchar2(40),            /*自订字段-文字                          */
bxbud03     varchar2(40),            /*自订字段-文字                          */
bxbud04     varchar2(40),            /*自订字段-文字                          */
bxbud05     varchar2(40),            /*自订字段-文字                          */
bxbud06     varchar2(40),            /*自订字段-文字                          */
bxbud07     number(15,3),            /*自订字段-数值                          */
bxbud08     number(15,3),            /*自订字段-数值                          */
bxbud09     number(15,3),            /*自订字段-数值                          */
bxbud10     number(10),              /*自订字段-整数                          */
bxbud11     number(10),              /*自订字段-整数                          */
bxbud12     number(10),              /*自订字段-整数                          */
bxbud13     date,                    /*自订字段-日期                          */
bxbud14     date,                    /*自订字段-日期                          */
bxbud15     date,                    /*自订字段-日期                          */
bxbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bxblegal    varchar2(10) NOT NULL,   /*所属法人                               */
bxborig     varchar2(10),            /*资料建立部门                           */
bxboriu     varchar2(10)             /*资料建立者                             */
);

alter table bxb_file add  constraint bxb_pk primary key  (bxb01) enable validate;
grant select on bxb_file to tiptopgp;
grant update on bxb_file to tiptopgp;
grant delete on bxb_file to tiptopgp;
grant insert on bxb_file to tiptopgp;
grant index on bxb_file to public;
grant select on bxb_file to ods;
