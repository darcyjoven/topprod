/*
================================================================================
檔案代號:hrde_file
檔案名稱:薪点薪资标准设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrde_file
(
hrde01      varchar2(20) NOT NULL,   /*编码                                   */
hrde02      varchar2(100) NOT NULL,  /*名称                                   */
hrde03      varchar2(20) NOT NULL,   /*开窗信息                               */
hrde04      varchar2(20) NOT NULL,   /*职务/职位/其他                         */
hrde05      varchar2(10) NOT NULL,   /*等级                                   */
hrde06      number(15,2),            /*标准薪资                               */
hrde07      varchar2(255),           /*备注                                   */
hrdeacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdeuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdegrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdemodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdedate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdeoriu    varchar2(10),            /*资料建立者                             */
hrdeorig    varchar2(10),            /*资料建立部门                           */
hrdeud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdeud02    varchar2(40),            /*自订栏位-文字                          */
hrdeud03    varchar2(40),            /*自订栏位-文字                          */
hrdeud04    varchar2(40),            /*自订栏位-文字                          */
hrdeud05    varchar2(40),            /*自订栏位-文字                          */
hrdeud06    varchar2(40),            /*自订栏位-文字                          */
hrdeud07    number(15,3),            /*自订栏位-数值                          */
hrdeud08    number(15,3),            /*自订栏位-数值                          */
hrdeud09    number(15,3),            /*自订栏位-数值                          */
hrdeud10    number(10),              /*自订栏位-整数                          */
hrdeud11    number(10),              /*自订栏位-整数                          */
hrdeud12    number(10),              /*自订栏位-整数                          */
hrdeud13    date,                    /*自订栏位-日期                          */
hrdeud14    date,                    /*自订栏位-日期                          */
hrdeud15    date,                    /*自订栏位-日期                          */
hrde08      varchar2(20),            /*所属公司                               */
hrde09      varchar2(1),             /*是否集团级                             */
hrde10      date,                    /*建立日期                               */
hrde11      date                     /*生效日期                               */
);

alter table hrde_file add  constraint tpc_hrde_pk primary key  (hrde01,hrde02,hrde03,hrde04,hrde05) enable validate;
grant select on hrde_file to tiptopgp;
grant update on hrde_file to tiptopgp;
grant delete on hrde_file to tiptopgp;
grant insert on hrde_file to tiptopgp;
grant index on hrde_file to public;
grant select on hrde_file to ods;
