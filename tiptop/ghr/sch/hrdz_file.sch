/*
================================================================================
檔案代號:hrdz_file
檔案名稱:预算分摊权数管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdz_file
(
hrdz00      varchar2(20) NOT NULL,   /*预算年度                               */
hrdz01      number(15,2),            /*第一期分配权数                         */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
hrdz02      number(15,2),            /*第二期分配权数                         */
hrdz03      number(15,2),            /*第三期分配权数                         */
hrdz04      number(15,2),            /*第四期分配权数                         */
hrdz05      number(15,2),            /*第五期分配权数                         */
hrdz06      number(15,2),            /*第六期分配权数                         */
hrdz07      number(15,2),            /*第七期分配权数                         */
hrdz08      number(15,2),            /*第八期分配权数                         */
hrdz09      number(15,2),            /*第九期分配权数                         */
                                     /*                                       */
hrdz10      number(15,2),            /*第十期分配权数                         */
hrdz11      number(15,2),            /*第十一期分配权数                       */
hrdz12      number(15,2),            /*第十二期分配权数                       */
                                     /*                                       */
hrdzacti    varchar2(1),             /*资料有效码                             */
                                     /*                                       */
hrdzuser    varchar2(10),            /*资料所有者                             */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
hrdzmodu    varchar2(10),            /*资料更改者                             */
hrdzdate    date,                    /*最近修改日                             */
                                     /*                                       */
hrdzoriu    varchar2(10),            /*资料建立者                             */
hrdzorig    varchar2(10),            /*资料建立部门                           */
hrdzud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdzud02    varchar2(40),            /*自订栏位-Textedit                      */
hrdzud03    varchar2(40),            /*自订栏位-Textedit                      */
                                     /*                                       */
                                     /*                                       */
hrdzud04    varchar2(40),            /*自订栏位-Textedit                      */
hrdzud05    varchar2(40),            /*自订栏位-Textedit                      */
hrdzud06    varchar2(40),            /*自订栏位-Textedit                      */
hrdzud07    number(15,3),            /*自订栏位-数值                          */
                                     /*                                       */
hrdzud08    number(15,3),            /*自订栏位-数值                          */
hrdzud09    number(15,3),            /*自订栏位-数值                          */
hrdzud10    number(10),              /*自订栏位-整数                          */
hrdzud11    number(10),              /*自订栏位-整数                          */
hrdzud12    number(10),              /*自订栏位-整数                          */
hrdzud13    date,                    /*自订栏位-日期                          */
hrdzud14    date,                    /*自订栏位-日期                          */
hrdzud15    date,                    /*自订栏位-日期                          */
hrdzgrup    varchar2(10)
);

alter table hrdz_file add  constraint tpc_hrdz_pk primary key  (hrdz00) enable validate;
grant select on hrdz_file to tiptopgp;
grant update on hrdz_file to tiptopgp;
grant delete on hrdz_file to tiptopgp;
grant insert on hrdz_file to tiptopgp;
grant index on hrdz_file to public;
grant select on hrdz_file to ods;
