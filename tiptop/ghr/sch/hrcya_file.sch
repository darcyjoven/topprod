/*
================================================================================
檔案代號:hrcya_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcya_file
(
hrcya01     varchar2(20) NOT NULL,   /*等级编码                               */
hrcya02     varchar2(20) NOT NULL,   /*薪资等级档编码                         */
hrcya03     varchar2(20),            /*薪资等级档名称                         */
hrcyaacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrcyauser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrcyagrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrcyamodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrcyadate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrcyaoriu   varchar2(10),            /*资料建立者                             */
hrcyaorig   varchar2(10),            /*资料建立部门                           */
hrcyaud01   varchar2(255),           /*自订栏位-Textedit                      */
hrcyaud02   varchar2(40),            /*自订栏位-文字                          */
hrcyaud03   varchar2(40),            /*自订栏位-文字                          */
hrcyaud04   varchar2(40),            /*自订栏位-文字                          */
hrcyaud05   varchar2(40),            /*自订栏位-文字                          */
hrcyaud06   varchar2(40),            /*自订栏位-文字                          */
hrcyaud07   number(15,3),            /*自订栏位-数值                          */
hrcyaud08   number(15,3),            /*自订栏位-数值                          */
hrcyaud09   number(15,3),            /*自订栏位-数值                          */
hrcyaud10   number(10),              /*自订栏位-整数                          */
hrcyaud11   number(10),              /*自订栏位-整数                          */
hrcyaud12   number(10),              /*自订栏位-整数                          */
hrcyaud13   date,                    /*自订栏位-日期                          */
hrcyaud14   date,                    /*自订栏位-日期                          */
hrcyaud15   date                     /*自订栏位-日期                          */
);

alter table hrcya_file add  constraint tpc_hrcya_pk primary key  (hrcya01,hrcya02) enable validate;
grant select on hrcya_file to tiptopgp;
grant update on hrcya_file to tiptopgp;
grant delete on hrcya_file to tiptopgp;
grant insert on hrcya_file to tiptopgp;
grant index on hrcya_file to public;
grant select on hrcya_file to ods;
