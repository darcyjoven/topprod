/*
================================================================================
檔案代號:hrdc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdc_file
(
hrdc01      number(15) NOT NULL,     /*编号                                   */
hrdc02      varchar2(20) NOT NULL,   /*公司编号                               */
hrdc03      varchar2(20) NOT NULL,   /*考勤区间                               */
hrdc04      varchar2(255),           /*备注                                   */
hrdcconf    varchar2(1),             /* 审核状态                              */
hrdcacti    varchar2(1) NOT NULL,    /* 资料有效否                            */
hrdcud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdcud02    varchar2(40),            /*自订栏位-文字                          */
hrdcud03    varchar2(40),            /*自订栏位-文字                          */
hrdcud04    varchar2(40),            /*自订栏位-文字                          */
hrdcud05    varchar2(40),            /*自订栏位-文字                          */
hrdcud06    varchar2(40),            /*自订栏位-文字                          */
hrdcud07    number(15,3),            /*自订栏位-数值                          */
hrdcud08    number(15,3),            /*自订栏位-数值                          */
hrdcud09    number(15,3),            /*自订栏位-数值                          */
hrdcud10    number(10),              /*自订栏位-整数                          */
hrdcud11    number(10),              /*自订栏位-整数                          */
hrdcud12    number(10),              /*自订栏位-整数                          */
hrdcud13    date,                    /*自订栏位-日期                          */
hrdcud14    date,                    /*自订栏位-日期                          */
hrdcud15    date,                    /*自订栏位-日期                          */
hrdcuser    varchar2(10),            /*  资料所有者                           */
hrdcgrup    varchar2(10),            /*  资料所有群                           */
hrdcmodu    varchar2(10),            /*  资料更改者                           */
hrdcdate    date,                    /*  最近修改日                           */
hrdcorig    varchar2(10),            /*  资料建立部门                         */
hrdcoriu    varchar2(10)             /*  资料建立者                           */
);

alter table hrdc_file add  constraint tpc_hrdc_pk primary key  (hrdc01) enable validate;
grant select on hrdc_file to tiptopgp;
grant update on hrdc_file to tiptopgp;
grant delete on hrdc_file to tiptopgp;
grant insert on hrdc_file to tiptopgp;
grant index on hrdc_file to public;
grant select on hrdc_file to ods;
