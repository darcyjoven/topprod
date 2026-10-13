/*
================================================================================
檔案代號:cci_file
檔案名稱:每日投入工时单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cci_file
(
cci01       date NOT NULL,           /*日期                                   */
cci02       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
cci03       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
cci04       varchar2(1),             /*No Use                                 */
cci05       number(15,3) NOT NULL,   /*工时合计                               */
                                     /*工時合計                               */
ccifirm     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
cciinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
cciacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
cciuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ccigrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
ccimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
ccidate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
cciud01     varchar2(255),           /*自订字段-Textedit                      */
cciud02     varchar2(40),            /*自订字段-文字                          */
cciud03     varchar2(40),            /*自订字段-文字                          */
cciud04     varchar2(40),            /*自订字段-文字                          */
cciud05     varchar2(40),            /*自订字段-文字                          */
cciud06     varchar2(40),            /*自订字段-文字                          */
cciud07     number(15,3),            /*自订字段-数值                          */
cciud08     number(15,3),            /*自订字段-数值                          */
cciud09     number(15,3),            /*自订字段-数值                          */
cciud10     number(10),              /*自订字段-整数                          */
cciud11     number(10),              /*自订字段-整数                          */
cciud12     number(10),              /*自订字段-整数                          */
cciud13     date,                    /*自订字段-日期                          */
cciud14     date,                    /*自订字段-日期                          */
cciud15     date,                    /*自订字段-日期                          */
ccioriu     varchar2(10),            /*资料建立者                             */
cciorig     varchar2(10),            /*资料建立部门                           */
ccilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cci_file add  constraint cci_pk primary key  (cci01,cci02) enable validate;
grant select on cci_file to tiptopgp;
grant update on cci_file to tiptopgp;
grant delete on cci_file to tiptopgp;
grant insert on cci_file to tiptopgp;
grant index on cci_file to public;
grant select on cci_file to ods;
