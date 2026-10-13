/*
================================================================================
檔案代號:qcp_file
檔案名稱:质量异常单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcp_file
(
qcp01       varchar2(20) NOT NULL,   /*质量异常单单号                         */
qcp02       number(5) NOT NULL,      /*项次                                   */
qcp03       varchar2(30),            /*异常状况                               */
qcp04       number(15,3),            /*不良数量                               */
qcp05       varchar2(80),            /*处理对策                               */
qcp06       varchar2(6),             /*异常项目                               */
qcpud01     varchar2(255),           /*自订字段-Textedit                      */
qcpud02     varchar2(40),            /*自订字段-文字                          */
qcpud03     varchar2(40),            /*自订字段-文字                          */
qcpud04     varchar2(40),            /*自订字段-文字                          */
qcpud05     varchar2(40),            /*自订字段-文字                          */
qcpud06     varchar2(40),            /*自订字段-文字                          */
qcpud07     number(15,3),            /*自订字段-数值                          */
qcpud08     number(15,3),            /*自订字段-数值                          */
qcpud09     number(15,3),            /*自订字段-数值                          */
qcpud10     number(10),              /*自订字段-整数                          */
qcpud11     number(10),              /*自订字段-整数                          */
qcpud12     number(10),              /*自订字段-整数                          */
qcpud13     date,                    /*自订字段-日期                          */
qcpud14     date,                    /*自订字段-日期                          */
qcpud15     date,                    /*自订字段-日期                          */
qcpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table qcp_file add  constraint qcp_pk primary key  (qcp01,qcp02) enable validate;
grant select on qcp_file to tiptopgp;
grant update on qcp_file to tiptopgp;
grant delete on qcp_file to tiptopgp;
grant insert on qcp_file to tiptopgp;
grant index on qcp_file to public;
grant select on qcp_file to ods;
