/*
================================================================================
檔案代號:rms_file
檔案名稱:RMA 覆出报关发票单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rms_file
(
rms01       varchar2(20) NOT NULL,   /*覆出单号                               */
                                     /*覆出單號                               */
rms02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rms03       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
rms04       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rms06       varchar2(120),           /*品名                                   */
rms061      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rms12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
rms13       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
rms14       number(20,6) NOT NULL,   /*金额                                   */
                                     /*金額=rms13*rms12                       */
rms31       number(5),               /*栈板编号                               */
                                     /*棧板編號                               */
rms32       varchar2(11),            /*栈板长宽高                             */
                                     /*棧皮長寬高                             */
rms33       number(5),               /*箱号                                   */
                                     /*箱號                                   */
rms34       varchar2(11),            /*箱号长宽高                             */
                                     /*箱號長寬高                             */
rms35       number(15,3),            /*箱号重量                               */
                                     /*箱號重量                               */
rms36       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
rmsud01     varchar2(255),           /*自订字段-Textedit                      */
rmsud02     varchar2(40),            /*自订字段-文字                          */
rmsud03     varchar2(40),            /*自订字段-文字                          */
rmsud04     varchar2(40),            /*自订字段-文字                          */
rmsud05     varchar2(40),            /*自订字段-文字                          */
rmsud06     varchar2(40),            /*自订字段-文字                          */
rmsud07     number(15,3),            /*自订字段-数值                          */
rmsud08     number(15,3),            /*自订字段-数值                          */
rmsud09     number(15,3),            /*自订字段-数值                          */
rmsud10     number(10),              /*自订字段-整数                          */
rmsud11     number(10),              /*自订字段-整数                          */
rmsud12     number(10),              /*自订字段-整数                          */
rmsud13     date,                    /*自订字段-日期                          */
rmsud14     date,                    /*自订字段-日期                          */
rmsud15     date,                    /*自订字段-日期                          */
rmsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rms_file add  constraint rms_pk primary key  (rms01,rms02) enable validate;
grant select on rms_file to tiptopgp;
grant update on rms_file to tiptopgp;
grant delete on rms_file to tiptopgp;
grant insert on rms_file to tiptopgp;
grant index on rms_file to public;
grant select on rms_file to ods;
