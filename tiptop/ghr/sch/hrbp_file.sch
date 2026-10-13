/*
================================================================================
檔案代號:hrbp_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbp_file
(
hrbp01      varchar2(20) NOT NULL,   /*公司编号                               */
hrbp02      varchar2(20) NOT NULL,   /*轮班编号                               */
hrbp03      varchar2(60) NOT NULL,   /*轮班名称                               */
hrbp04      varchar2(255),           /*备注                                   */
hrbp05      varchar2(1),             /*轮班依据                               */
hrbpud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbpud02    varchar2(40),            /*自订栏位-文字                          */
hrbpud03    varchar2(40),            /*自订栏位-文字                          */
hrbpud04    varchar2(40),            /*自订栏位-文字                          */
hrbpud05    varchar2(40),            /*自订栏位-文字                          */
hrbpud06    varchar2(40),            /*自订栏位-文字                          */
hrbpud07    number(15,3),            /*自订栏位-数值                          */
hrbpud08    number(15,3),            /*自订栏位-数值                          */
hrbpud09    number(15,3),            /*自订栏位-数值                          */
hrbpud10    number(10),              /*自订栏位-整数                          */
hrbpud11    number(10),              /*自订栏位-整数                          */
hrbpud12    number(10),              /*自订栏位-整数                          */
hrbpud13    date,                    /*自订栏位-日期                          */
hrbpud14    date,                    /*自订栏位-日期                          */
hrbpud15    date,                    /*自订栏位-日期                          */
hrbpuser    varchar2(10),            /*资料所有者                             */
hrbpgrup    varchar2(10),            /*资料所有群                             */
hrbpmodu    varchar2(10),            /*资料更改者                             */
hrbpdate    date,                    /*最近修改日                             */
hrbporig    varchar2(10),            /*资料建立部门                           */
hrbporiu    varchar2(10)             /*资料建立者                             */
);

alter table hrbp_file add  constraint tpc_hrbp_pk primary key  (hrbp02) enable validate;
grant select on hrbp_file to tiptopgp;
grant update on hrbp_file to tiptopgp;
grant delete on hrbp_file to tiptopgp;
grant insert on hrbp_file to tiptopgp;
grant index on hrbp_file to public;
grant select on hrbp_file to ods;
