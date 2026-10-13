/*
================================================================================
檔案代號:hrdy_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdy_file
(
hrdy01      varchar2(20) NOT NULL,   /*员工ID                                 */
hrdy02      varchar2(20) NOT NULL,   /*所属财年                               */
hrdy03      varchar2(20),            /*所属公司ID                             */
hrdy04      varchar2(100),           /*参照薪资月                             */
hrdy05      varchar2(1),             /*是否按12月分摊                         */
hrdy06      number(15,2),            /*奖金总金额                             */
hrdy07      number(15,2),            /*奖金税                                 */
hrdy08      number(15,2),            /*实付金额                               */
hrdy09      number(15,2),            /*已发奖金                               */
hrdy10      varchar2(255),           /*备注                                   */
hrdyacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdyuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdygrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdymodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdydate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdyoriu    varchar2(10),            /*资料建立者                             */
hrdyorig    varchar2(10),            /*资料建立部门                           */
hrdyud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdyud02    varchar2(40),            /*自订栏位-文字                          */
hrdyud03    varchar2(40),            /*自订栏位-文字                          */
hrdyud04    varchar2(40),            /*自订栏位-文字                          */
hrdyud05    varchar2(40),            /*自订栏位-文字                          */
hrdyud06    varchar2(40),            /*自订栏位-文字                          */
hrdyud07    number(15,3),            /*自订栏位-数值                          */
hrdyud08    number(15,3),            /*自订栏位-数值                          */
hrdyud09    number(15,3),            /*自订栏位-数值                          */
hrdyud10    number(10),              /*自订栏位-整数                          */
hrdyud11    number(10),              /*自订栏位-整数                          */
hrdyud12    number(10),              /*自订栏位-整数                          */
hrdyud13    date,                    /*自订栏位-日期                          */
hrdyud14    date,                    /*自订栏位-日期                          */
hrdyud15    date                     /*自订栏位-日期                          */
);

alter table hrdy_file add  constraint tpc_hrdy_pk primary key  (hrdy01,hrdy02) enable validate;
grant select on hrdy_file to tiptopgp;
grant update on hrdy_file to tiptopgp;
grant delete on hrdy_file to tiptopgp;
grant insert on hrdy_file to tiptopgp;
grant index on hrdy_file to public;
grant select on hrdy_file to ods;
