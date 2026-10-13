/*
================================================================================
檔案代號:hrdh_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdh_file
(
hrdh01      number(5) NOT NULL,      /*参数编号                               */
hrdh02      varchar2(20),            /*参数类别ID                             */
hrdh03      varchar2(20),            /*参数类型ID                             */
hrdh04      varchar2(20),            /*数据字段名                             */
hrdh05      varchar2(50),            /*扩展信息                               */
hrdh06      varchar2(255),           /*参数名称                               */
hrdh07      varchar2(20),            /*所属公司ID                             */
hrdh08      number(15,2),            /*参数值                                 */
hrdh09      varchar2(255),           /*序列说明                               */
hrdh10      varchar2(1),             /*是否使用                               */
hrdh11      varchar2(255),           /*备注                                   */
hrdh12      varchar2(20),            /*参数ID                                 */
hrdhacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdhuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdhgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdhmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdhdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdhoriu    varchar2(10),            /*资料建立者                             */
hrdhorig    varchar2(10),            /*资料建立部门                           */
hrdhud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdhud02    varchar2(40),            /*自订栏位-文字                          */
hrdhud03    varchar2(40),            /*自订栏位-文字                          */
hrdhud04    varchar2(40),            /*自订栏位-文字                          */
hrdhud05    varchar2(40),            /*自订栏位-文字                          */
hrdhud06    varchar2(40),            /*自订栏位-文字                          */
hrdhud07    number(15,3),            /*自订栏位-数值                          */
hrdhud08    number(15,3),            /*自订栏位-数值                          */
hrdhud09    number(15,3),            /*自订栏位-数值                          */
hrdhud10    number(10),              /*自订栏位-整数                          */
hrdhud11    number(10),              /*自订栏位-整数                          */
hrdhud12    number(10),              /*自订栏位-整数                          */
hrdhud13    date,                    /*自订栏位-日期                          */
hrdhud14    date,                    /*自订栏位-日期                          */
hrdhud15    date,                    /*自订栏位-日期                          */
hrdh13      varchar2(20),
hrdh14      varchar2(1),
hrdh15      varchar2(4000)
);

alter table hrdh_file add  constraint tpc_hrdh_pk primary key  (hrdh01) enable validate;
grant select on hrdh_file to tiptopgp;
grant update on hrdh_file to tiptopgp;
grant delete on hrdh_file to tiptopgp;
grant insert on hrdh_file to tiptopgp;
grant index on hrdh_file to public;
grant select on hrdh_file to ods;
