/*
================================================================================
檔案代號:hrbt_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbt_file
(
hrbt00      varchar2(1) NOT NULL,    /*KEY                                    */
hrbt01      varchar2(1),             /*启用A触发点                            */
hrbt011     varchar2(50),            /*时间                                   */
hrbt012     varchar2(1),             /*点名                                   */
hrbt013     varchar2(1),             /*加班处理                               */
hrbt014     varchar2(1),             /*年假计算                               */
hrbt015     varchar2(1),             /*数据采集                               */
hrbt016     varchar2(255),           /*路径                                   */
hrbt02      varchar2(1),             /*启用B触发点                            */
hrbt021     varchar2(50),            /*时间                                   */
hrbt022     varchar2(1),             /*点名                                   */
hrbt023     varchar2(1),             /*加班处理                               */
hrbt024     varchar2(1),             /*年假计算                               */
hrbt025     varchar2(1),             /*数据采集                               */
hrbt026     varchar2(255),           /*路径                                   */
hrbt03      varchar2(1),             /*启用C触发点                            */
hrbt031     varchar2(50),            /*时间                                   */
hrbt032     varchar2(1),             /*点名                                   */
hrbt033     varchar2(1),             /*加班处理                               */
hrbt034     varchar2(1),             /*年假计算                               */
hrbt035     varchar2(1),             /*数据采集                               */
hrbt036     varchar2(255),           /*路径                                   */
hrbt04      varchar2(1),             /*工号与电子卡号一致                     */
hrbtud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbtud02    varchar2(40),            /*自订栏位-文字                          */
hrbtud03    varchar2(40),            /*自订栏位-文字                          */
hrbtud04    varchar2(40),            /*自订栏位-文字                          */
hrbtud05    varchar2(40),            /*自订栏位-文字                          */
hrbtud06    varchar2(40),            /*自订栏位-文字                          */
hrbtud07    number(15,3),            /*自订栏位-数值                          */
hrbtud08    number(15,3),            /*自订栏位-数值                          */
hrbtud09    number(15,3),            /*自订栏位-数值                          */
hrbtud10    number(10),              /*自订栏位-整数                          */
hrbtud11    number(10),              /*自订栏位-整数                          */
hrbtud12    number(10),              /*自订栏位-整数                          */
hrbtud13    date,                    /*自订栏位-日期                          */
hrbtud14    date,                    /*自订栏位-日期                          */
hrbtud15    date,                    /*自订栏位-日期                          */
hrbtuser    varchar2(10),            /*资料所有者                             */
hrbtgrup    varchar2(10),            /*资料所有群                             */
hrbtmodu    varchar2(10),            /*资料更改者                             */
hrbtdate    date,                    /*最近修改日                             */
hrbtorig    varchar2(10),            /*资料建立部门                           */
hrbtoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrbt_file add  constraint tpc_hrbt_pk primary key  (hrbt00) enable validate;
grant select on hrbt_file to tiptopgp;
grant update on hrbt_file to tiptopgp;
grant delete on hrbt_file to tiptopgp;
grant insert on hrbt_file to tiptopgp;
grant index on hrbt_file to public;
grant select on hrbt_file to ods;
