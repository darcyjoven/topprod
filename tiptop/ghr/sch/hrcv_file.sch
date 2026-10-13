/*
================================================================================
檔案代號:hrcv_file
檔案名稱:个税起征
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcv_file
(
hrcv01      varchar2(20) NOT NULL,   /*个税起征ID                             */
hrcv02      varchar2(100),           /*个税起征类别                           */
hrcv03      number(15,3),            /*个税起征值                             */
hrcv04      date,                    /*建立日期                               */
hrcv05      date,                    /*生效日期                               */
hrcv06      varchar2(1),             /*是否集团级                             */
hrcv07      varchar2(20),            /*所属公司ID                             */
hrcv08      varchar2(255),           /*备注                                   */
hrcvacti    varchar2(1),             /*资料有效码                             */
hrcvuser    varchar2(10),            /*资料所有者                             */
hrcvgrup    varchar2(10),            /*资料所有群                             */
hrcvmodu    varchar2(10),            /*修改者                                 */
hrcvdate    date,                    /*最近修改日                             */
hrcvoriu    varchar2(10),            /*资料建立者                             */
hrcvorig    varchar2(10),            /*资料建立部门                           */
hrcvud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcvud02    varchar2(40),            /*自订栏位-文字                          */
hrcvud03    varchar2(40),            /*自订栏位-文字                          */
hrcvud04    varchar2(40),            /*自订栏位-文字                          */
hrcvud05    varchar2(40),            /*自订栏位-文字                          */
hrcvud06    varchar2(40),            /*自订栏位-文字                          */
hrcvud07    number(15,3),            /*自订栏位-数值                          */
hrcvud08    number(15,3),            /*自订栏位-数值                          */
hrcvud09    number(15,3),            /*自订栏位-数值                          */
hrcvud10    number(10),              /*自订栏位-整数                          */
hrcvud11    number(10),              /*自订栏位-整数                          */
hrcvud12    number(10),              /*自订栏位-整数                          */
hrcvud13    date,                    /*自订栏位-日期                          */
hrcvud14    date,                    /*自订栏位-日期                          */
hrcvud15    date                     /*自订栏位-日期                          */
);

alter table hrcv_file add  constraint tpc_hrcv_pk primary key  (hrcv01) enable validate;
grant select on hrcv_file to tiptopgp;
grant update on hrcv_file to tiptopgp;
grant delete on hrcv_file to tiptopgp;
grant insert on hrcv_file to tiptopgp;
grant index on hrcv_file to public;
grant select on hrcv_file to ods;
