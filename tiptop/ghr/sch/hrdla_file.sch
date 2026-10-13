/*
================================================================================
檔案代號:hrdla_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdla_file
(
hrdla01     varchar2(20) NOT NULL,   /*薪资类别编码                           */
hrdla02     varchar2(20) NOT NULL,   /*计算项编号                             */
hrdla03     number(5),               /*序号                                   */
hrdlaacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdlauser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdlagrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdlamodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdladate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdlaoriu   varchar2(10),            /*资料建立者                             */
hrdlaorig   varchar2(10),            /*资料建立部门                           */
hrdlaud01   varchar2(255),           /*自订栏位-Textedit                      */
hrdlaud02   varchar2(40),            /*自订栏位-文字                          */
hrdlaud03   varchar2(40),            /*自订栏位-文字                          */
hrdlaud04   varchar2(40),            /*自订栏位-文字                          */
hrdlaud05   varchar2(40),            /*自订栏位-文字                          */
hrdlaud06   varchar2(40),            /*自订栏位-文字                          */
hrdlaud07   number(15,3),            /*自订栏位-数值                          */
hrdlaud08   number(15,3),            /*自订栏位-数值                          */
hrdlaud09   number(15,3),            /*自订栏位-数值                          */
hrdlaud10   number(10),              /*自订栏位-整数                          */
hrdlaud11   number(10),              /*自订栏位-整数                          */
hrdlaud12   number(10),              /*自订栏位-整数                          */
hrdlaud13   date,                    /*自订栏位-日期                          */
hrdlaud14   date,                    /*自订栏位-日期                          */
hrdlaud15   date                     /*自订栏位-日期                          */
);

alter table hrdla_file add  constraint tpc_hrdlaa_pk primary key  (hrdla01,hrdla02) enable validate;
grant select on hrdla_file to tiptopgp;
grant update on hrdla_file to tiptopgp;
grant delete on hrdla_file to tiptopgp;
grant insert on hrdla_file to tiptopgp;
grant index on hrdla_file to public;
grant select on hrdla_file to ods;
