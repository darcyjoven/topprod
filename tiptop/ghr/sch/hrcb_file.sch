/*
================================================================================
檔案代號:hrcb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:Y
============.========================.==========================================
*/
create table hrcb_file
(
hrcb01      varchar2(20) NOT NULL,   /*群组编号                               */
hrcb02      varchar2(50),            /*群组名称                               */
hrcb03      varchar2(255),           /*备注                                   */
hrcb04      number(5) NOT NULL,      /*项次                                   */
hrcb05      varchar2(50),            /*员工ID                                 */
hrcbacti    varchar2(1),             /*资料有效否                             */
hrcbud01    varchar2(255),           /*自定栏位-Textedit                      */
hrcbud02    varchar2(40),            /*自定栏位-文字                          */
hrcbud03    varchar2(40),            /*自定栏位-文字                          */
hrcbud04    varchar2(40),            /*自定栏位-文字                          */
hrcbud05    varchar2(40),            /*自定栏位-文字                          */
hrcbud06    varchar2(40),            /*自定栏位-文字                          */
hrcbud07    number(15,3),            /*自定栏位-数值                          */
hrcbud08    number(15,3),            /*自定栏位-数值                          */
hrcbud09    number(15,3),            /*自定栏位-数值                          */
hrcbud10    number(10),              /*自定栏位-整数                          */
hrcbud11    number(10),              /*自定栏位-整数                          */
hrcbud12    number(10),              /*自定栏位-整数                          */
hrcbud13    date,                    /*自定栏位-日期                          */
hrcbud14    date,                    /*自定栏位-日期                          */
hrcbud15    date,                    /*自定栏位-日期                          */
hrcbuser    varchar2(10),            /*资料所有者                             */
hrcbgrup    varchar2(10),            /*资料所有群                             */
hrcbmodu    varchar2(10),            /*资料更改者                             */
hrcbdate    date,                    /*最近修改日                             */
hrcborig    varchar2(10),            /*资料建立部门                           */
hrcboriu    varchar2(10),            /*资料建立者                             */
hrcb06      date,                    /*有效开始日期                           */
hrcb07      date                     /*有效结束时间                           */
);

alter table hrcb_file add  constraint tpc_hrcb_pk primary key  (hrcb01,hrcb04) enable validate;
grant select on hrcb_file to tiptopgp;
grant update on hrcb_file to tiptopgp;
grant delete on hrcb_file to tiptopgp;
grant insert on hrcb_file to tiptopgp;
grant index on hrcb_file to public;
grant select on hrcb_file to ods;
