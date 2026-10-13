/*
================================================================================
檔案代號:hrcyb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcyb_file
(
hrcyb01     varchar2(20) NOT NULL,   /*等级编码                               */
hrcyb02     varchar2(20) NOT NULL,   /*薪资等级档编码                         */
hrcyb03     number(5) NOT NULL,      /*序号                                   */
hrcyb04     varchar2(50),            /*薪资等级档名称                         */
hrcyb05     varchar2(50),            /*薪资等级栏名称                         */
hrcyb06     number(15,2),            /*本栏最小值                             */
hrcyb07     number(15,2),            /*本栏最大值                             */
hrcyb08     number(15,2),            /*本栏标准值                             */
hrcyb09     varchar2(255),           /*备注                                   */
hrcybacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrcybuser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrcybgrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrcybmodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrcybdate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrcyboriu   varchar2(10),            /*资料建立者                             */
hrcyborig   varchar2(10),            /*资料建立部门                           */
hrcybud01   varchar2(255),           /*自订栏位-Textedit                      */
hrcybud02   varchar2(40),            /*自订栏位-文字                          */
hrcybud03   varchar2(40),            /*自订栏位-文字                          */
hrcybud04   varchar2(40),            /*自订栏位-文字                          */
hrcybud05   varchar2(40),            /*自订栏位-文字                          */
hrcybud06   varchar2(40),            /*自订栏位-文字                          */
hrcybud07   number(15,3),            /*自订栏位-数值                          */
hrcybud08   number(15,3),            /*自订栏位-数值                          */
hrcybud09   number(15,3),            /*自订栏位-数值                          */
hrcybud10   number(10),              /*自订栏位-整数                          */
hrcybud11   number(10),              /*自订栏位-整数                          */
hrcybud12   number(10),              /*自订栏位-整数                          */
hrcybud13   date,                    /*自订栏位-日期                          */
hrcybud14   date,                    /*自订栏位-日期                          */
hrcybud15   date                     /*自订栏位-日期                          */
);

alter table hrcyb_file add  constraint tpc_hrcyb_pk primary key  (hrcyb01,hrcyb02,hrcyb03) enable validate;
grant select on hrcyb_file to tiptopgp;
grant update on hrcyb_file to tiptopgp;
grant delete on hrcyb_file to tiptopgp;
grant insert on hrcyb_file to tiptopgp;
grant index on hrcyb_file to public;
grant select on hrcyb_file to ods;
