/*
================================================================================
檔案代號:hrbe_file
檔案名稱:合同参数
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbe_file
(
hrbe01      varchar2(20) NOT NULL,   /*合同编码                               */
hrbe02      varchar2(50),            /*合同名称                               */
hrbe03      varchar2(20),            /*合同类型编码                           */
hrbe04      varchar2(1),             /*是否作为劳动合同附件                   */
hrbe05      varchar2(1),             /*是否与劳动合同同时解除                 */
hrbe06      varchar2(1),             /*是否生效                               */
hrbe07      date,                    /*生效日期                               */
hrbeacti    varchar2(1),             /*资料有效码                             */
hrbeuser    varchar2(10),            /*资料所有者                             */
hrbegrup    varchar2(10),            /*资料所有群                             */
hrbemodu    varchar2(10),            /*资料更改者                             */
hrbedate    date,                    /*最近修改日                             */
hrbeoriu    varchar2(10),            /*资料建立者                             */
hrbeorig    varchar2(10),            /*资料建立部门                           */
hrbeud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbeud02    varchar2(40),            /*自订栏位-文字                          */
hrbeud03    varchar2(40),            /*自订栏位-文字                          */
hrbeud04    varchar2(40),            /*自订栏位-文字                          */
hrbeud05    varchar2(40),            /*自订栏位-文字                          */
hrbeud06    varchar2(40),            /*自订栏位-文字                          */
hrbeud07    number(15,3),            /*自订栏位-数值                          */
hrbeud08    number(15,3),            /*自订栏位-数值                          */
hrbeud09    number(15,3),            /*自订栏位-数值                          */
hrbeud10    number(10),              /*自订栏位-整数                          */
hrbeud11    number(10),              /*自订栏位-整数                          */
hrbeud12    number(10),              /*自订栏位-整数                          */
hrbeud13    date,                    /*自订栏位-日期                          */
hrbeud14    date,                    /*自订栏位-日期                          */
hrbeud15    date                     /*自订栏位-日期                          */
);

alter table hrbe_file add  constraint tpc_hrbe_pk primary key  (hrbe01) enable validate;
grant select on hrbe_file to tiptopgp;
grant update on hrbe_file to tiptopgp;
grant delete on hrbe_file to tiptopgp;
grant insert on hrbe_file to tiptopgp;
grant index on hrbe_file to public;
grant select on hrbe_file to ods;
