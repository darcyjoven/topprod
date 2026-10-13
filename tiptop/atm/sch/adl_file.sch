/*
================================================================================
檔案代號:adl_file
檔案名稱:派车单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adl_file
(
adl01       varchar2(20) NOT NULL,   /*派车单单号                             */
adl02       number(5) NOT NULL,      /*项次                                   */
adl03       varchar2(20),            /*来源单号                               */
adl04       number(5),               /*来源单项次                             */
adl05       number(15,6),            /*来源数量                               */
adl06       number(5),               /*拨出件数                               */
adl07       date,                    /*预计抵达日期                           */
adl08       varchar2(5),             /*预计抵达时间                           */
adl09       date,                    /*实际抵达日期                           */
adl10       varchar2(5),             /*实际抵达时间                           */
adl11       varchar2(1),             /*单据来源                               */
adl12       varchar2(4),             /*单位一                                 */
adl13       number(20,8),            /*单位一换算率                           */
adl14       number(15,3),            /*单位一数量                             */
adl15       varchar2(4),             /*单位二                                 */
adl16       number(20,8),            /*单位二换算率                           */
adl17       number(15,3),            /*单位二数量                             */
adl18       varchar2(4),             /*计价单位                               */
adl19       number(15,3),            /*计价数量                               */
adl20       varchar2(4),             /*派车单位                               */
adlud01     varchar2(255),           /*自订字段-Textedit                      */
adlud02     varchar2(40),            /*自订字段-文字                          */
adlud03     varchar2(40),            /*自订字段-文字                          */
adlud04     varchar2(40),            /*自订字段-文字                          */
adlud05     varchar2(40),            /*自订字段-文字                          */
adlud06     varchar2(40),            /*自订字段-文字                          */
adlud07     number(15,3),            /*自订字段-数值                          */
adlud08     number(15,3),            /*自订字段-数值                          */
adlud09     number(15,3),            /*自订字段-数值                          */
adlud10     number(10),              /*自订字段-整数                          */
adlud11     number(10),              /*自订字段-整数                          */
adlud12     number(10),              /*自订字段-整数                          */
adlud13     date,                    /*自订字段-日期                          */
adlud14     date,                    /*自订字段-日期                          */
adlud15     date,                    /*自订字段-日期                          */
adlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table adl_file add  constraint adl_pk primary key  (adl01,adl02) enable validate;
grant select on adl_file to tiptopgp;
grant update on adl_file to tiptopgp;
grant delete on adl_file to tiptopgp;
grant insert on adl_file to tiptopgp;
grant index on adl_file to public;
grant select on adl_file to ods;
