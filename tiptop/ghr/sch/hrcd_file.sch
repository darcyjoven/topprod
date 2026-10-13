/*
================================================================================
檔案代號:hrcd_file
檔案名稱:假勤单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcd_file
(
hrcd01      varchar2(20),            /*假勤项目编号                           */
hrcd02      date,                    /*开始日期                               */
hrcd03      varchar2(5),             /*开始时间                               */
hrcd04      date,                    /*结束日期                               */
hrcd05      varchar2(5),             /*结束时间                               */
hrcd06      number(15,3),            /*请假时长                               */
hrcd07      varchar2(20),            /*单位                                   */
hrcd08      varchar2(1),             /*规律时段假                             */
hrcd09      varchar2(10),            /*员工ID                                 */
hrcd10      varchar2(20) NOT NULL,   /*请假单编号                             */
hrcd11      varchar2(1),             /*数据类型                               */
                                     /*1：特殊假、2：年假、3：出差、4：其他假 */
hrcd12      varchar2(255),           /*备注                                   */
hrcdud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcdud02    varchar2(40),            /*自订栏位-文字                          */
hrcdud03    varchar2(40),            /*自订栏位-文字                          */
hrcdud04    varchar2(40),            /*自订栏位-文字                          */
hrcdud05    varchar2(40),            /*自订栏位-文字                          */
hrcdud06    varchar2(40),            /*自订栏位-文字                          */
hrcdud07    number(15,3),            /*自订栏位-数值                          */
hrcdud08    number(15,3),            /*自订栏位-数值                          */
hrcdud09    number(15,3),            /*自订栏位-数值                          */
hrcdud10    number(10),              /*自订栏位-整数                          */
hrcdud11    number(10),              /*自订栏位-整数                          */
hrcdud12    number(10),              /*自订栏位-整数                          */
hrcdud13    date,                    /*自订栏位-日期                          */
hrcdud14    date,                    /*自订栏位-日期                          */
hrcdud15    date,                    /*自订栏位-日期                          */
hrcduser    varchar2(10),            /*资料所有者                             */
hrcdgrup    varchar2(10),            /*资料所有群                             */
hrcdmodu    varchar2(10),            /*资料更改者                             */
hrcddate    date,                    /*最近修改日                             */
hrcdacti    varchar2(1),             /*资料有效否                             */
hrcdoriu    varchar2(10),            /*资料建立者                             */
hrcdorig    varchar2(10),            /*资料建立部门                           */
hrcdconf    varchar2(1)              /*审核码                                 */
);

alter table hrcd_file add  constraint tpc_hrcd_pk primary key  (hrcd10) enable validate;
grant select on hrcd_file to tiptopgp;
grant update on hrcd_file to tiptopgp;
grant delete on hrcd_file to tiptopgp;
grant insert on hrcd_file to tiptopgp;
grant index on hrcd_file to public;
grant select on hrcd_file to ods;
