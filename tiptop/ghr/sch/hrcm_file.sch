/*
================================================================================
檔案代號:hrcm_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcm_file
(
hrcm01      varchar2(20) NOT NULL,   /*公司                                   */
hrcm02      varchar2(20) NOT NULL,   /*编码                                   */
hrcm03      varchar2(60) NOT NULL,   /*名称                                   */
hrcm04      varchar2(255),           /*原因                                   */
hrcm05      varchar2(1) NOT NULL,    /*有效计划                               */
hrcm06      varchar2(255),           /*备注                                   */
hrcm07      varchar2(1),             /*已处理                                 */
hrcmconf    varchar2(1),             /* 审核状态                              */
hrcmacti    varchar2(1),             /* 资料有效否                            */
hrcmud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcmud02    varchar2(40),            /*自订栏位-文字                          */
hrcmud03    varchar2(40),            /*自订栏位-文字                          */
hrcmud04    varchar2(40),            /*自订栏位-文字                          */
hrcmud05    varchar2(40),            /*自订栏位-文字                          */
hrcmud06    varchar2(40),            /*自订栏位-文字                          */
hrcmud07    number(15,3),            /*自订栏位-数值                          */
hrcmud08    number(15,3),            /*自订栏位-数值                          */
hrcmud09    number(15,3),            /*自订栏位-数值                          */
hrcmud10    number(10),              /*自订栏位-整数                          */
hrcmud11    number(10),              /*自订栏位-整数                          */
hrcmud12    number(10),              /*自订栏位-整数                          */
hrcmud13    date,                    /*自订栏位-日期                          */
hrcmud14    date,                    /*自订栏位-日期                          */
hrcmud15    date,                    /*自订栏位-日期                          */
hrcmuser    varchar2(10),            /*  资料所有者                           */
hrcmgrup    varchar2(10),            /*  资料所有群                           */
hrcmmodu    varchar2(10),            /*  资料更改者                           */
hrcmdate    date,                    /*  最近修改日                           */
hrcmorig    varchar2(10),            /*  资料建立部门                         */
hrcmoriu    varchar2(10)             /*  资料建立者                           */
);

alter table hrcm_file add  constraint tpc_hrcm_pk primary key  (hrcm02) enable validate;
grant select on hrcm_file to tiptopgp;
grant update on hrcm_file to tiptopgp;
grant delete on hrcm_file to tiptopgp;
grant insert on hrcm_file to tiptopgp;
grant index on hrcm_file to public;
grant select on hrcm_file to ods;
