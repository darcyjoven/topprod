/*
================================================================================
檔案代號:hrdx_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdx_file
(
hrdx01      varchar2(50) NOT NULL,   /*所属薪资月                             */
hrdx02      varchar2(20),            /*所属公司ID                             */
hrdx03      varchar2(20),            /*薪资年度                               */
hrdx04      varchar2(100) NOT NULL,  /*计算组名称                             */
hrdx05      number(5),               /*本次发薪次数                           */
hrdx06      date,                    /*给付日期                               */
hrdx07      varchar2(255),           /*备注                                   */
hrdx08      varchar2(20),            /*提交人ID                               */
hrdx09      date,                    /*提交日期                               */
hrdx10      varchar2(20),            /*审核人ID                               */
hrdx11      date,                    /*审核日期                               */
hrdx12      varchar2(20),            /*归档人ID                               */
hrdx13      date,                    /*归档日期                               */
hrdx14      varchar2(20),            /*状态栏                                 */
hrdx15      varchar2(20),            /*本次计税类型                           */
hrdxacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdxuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdxgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdxmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdxdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdxoriu    varchar2(10),            /*资料建立者                             */
hrdxorig    varchar2(10),            /*资料建立部门                           */
hrdxud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdxud02    varchar2(40),            /*自订栏位-文字                          */
hrdxud03    varchar2(40),            /*自订栏位-文字                          */
hrdxud04    varchar2(40),            /*自订栏位-文字                          */
hrdxud05    varchar2(40),            /*自订栏位-文字                          */
hrdxud06    varchar2(40),            /*自订栏位-文字                          */
hrdxud07    number(15,3),            /*自订栏位-数值                          */
hrdxud08    number(15,3),            /*自订栏位-数值                          */
hrdxud09    number(15,3),            /*自订栏位-数值                          */
hrdxud10    number(10),              /*自订栏位-整数                          */
hrdxud11    number(10),              /*自订栏位-整数                          */
hrdxud12    number(10),              /*自订栏位-整数                          */
hrdxud13    date,                    /*自订栏位-日期                          */
hrdxud14    date,                    /*自订栏位-日期                          */
hrdxud15    date                     /*自订栏位-日期                          */
);

alter table hrdx_file add  constraint tpc_hrdx_pk primary key  (hrdx01,hrdx04) enable validate;
grant select on hrdx_file to tiptopgp;
grant update on hrdx_file to tiptopgp;
grant delete on hrdx_file to tiptopgp;
grant insert on hrdx_file to tiptopgp;
grant index on hrdx_file to public;
grant select on hrdx_file to ods;
