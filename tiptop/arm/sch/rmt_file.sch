/*
================================================================================
檔案代號:rmt_file
檔案名稱:RMA 覆出随机发票单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmt_file
(
rmt01       varchar2(20) NOT NULL,   /*覆出单号                               */
                                     /*覆出單號                               */
rmt02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rmt03       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
rmt04       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmt06       varchar2(120),           /*品名                                   */
rmt061      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rmt12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
rmt13       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
rmt14       number(20,6) NOT NULL,   /*金额                                   */
                                     /*金額=rmt13*rmt12                       */
rmt31       number(5),               /*栈板编号                               */
                                     /*棧板編號                               */
rmt32       varchar2(11),            /*栈板长宽高                             */
                                     /*棧板長寬高                             */
rmt33       number(5),               /*箱号                                   */
                                     /*箱號                                   */
rmt34       varchar2(11),            /*箱号长宽高                             */
                                     /*箱號長寬高                             */
rmt35       number(15,3),            /*箱号重量                               */
                                     /*箱號重量                               */
rmtud01     varchar2(255),           /*自订字段-Textedit                      */
rmtud02     varchar2(40),            /*自订字段-文字                          */
rmtud03     varchar2(40),            /*自订字段-文字                          */
rmtud04     varchar2(40),            /*自订字段-文字                          */
rmtud05     varchar2(40),            /*自订字段-文字                          */
rmtud06     varchar2(40),            /*自订字段-文字                          */
rmtud07     number(15,3),            /*自订字段-数值                          */
rmtud08     number(15,3),            /*自订字段-数值                          */
rmtud09     number(15,3),            /*自订字段-数值                          */
rmtud10     number(10),              /*自订字段-整数                          */
rmtud11     number(10),              /*自订字段-整数                          */
rmtud12     number(10),              /*自订字段-整数                          */
rmtud13     date,                    /*自订字段-日期                          */
rmtud14     date,                    /*自订字段-日期                          */
rmtud15     date,                    /*自订字段-日期                          */
rmtplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmtlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmt_file add  constraint rmt_pk primary key  (rmt01,rmt02) enable validate;
grant select on rmt_file to tiptopgp;
grant update on rmt_file to tiptopgp;
grant delete on rmt_file to tiptopgp;
grant insert on rmt_file to tiptopgp;
grant index on rmt_file to public;
grant select on rmt_file to ods;
