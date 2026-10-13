/*
================================================================================
檔案代號:hrci_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrci_file
(
hrci01      varchar2(20) NOT NULL,   /*加班结果编号                           */
hrci02      varchar2(60) NOT NULL,   /*员工Id                                 */
hrci03      date NOT NULL,           /*加班日期                               */
hrci04      varchar2(20) NOT NULL,   /*加班类型                               */
hrci05      number(5,2) NOT NULL,    /*加班时数                               */
hrci06      number(5,2) NOT NULL,    /*给薪时数                               */
hrci07      number(5,2) NOT NULL,    /*可调时数                               */
hrci08      number(5,2),             /*已调时数                               */
hrci09      number(5,2),             /*未调时数                               */
hrci10      date,                    /*截止日期                               */
hrci11      varchar2(255),           /*备注                                   */
hrciconf    varchar2(1),             /* 审核状态                              */
hrciacti    varchar2(1) NOT NULL,    /* 资料有效否                            */
hrciud01    varchar2(255),           /*自订栏位-Textedit                      */
hrciud02    varchar2(40),            /*自订栏位-文字                          */
hrciud03    varchar2(40),            /*自订栏位-文字                          */
hrciud04    varchar2(40),            /*自订栏位-文字                          */
hrciud05    varchar2(40),            /*自订栏位-文字                          */
hrciud06    varchar2(40),            /*自订栏位-文字                          */
hrciud07    number(15,3),            /*自订栏位-数值                          */
hrciud08    number(15,3),            /*自订栏位-数值                          */
hrciud09    number(15,3),            /*自订栏位-数值                          */
hrciud10    number(10),              /*自订栏位-整数                          */
hrciud11    number(10),              /*自订栏位-整数                          */
hrciud12    number(10),              /*自订栏位-整数                          */
hrciud13    date,                    /*自订栏位-日期                          */
hrciud14    date,                    /*自订栏位-日期                          */
hrciud15    date,                    /*自订栏位-日期                          */
hrciuser    varchar2(10),            /*  资料所有者                           */
hrcigrup    varchar2(10),            /*  资料所有群                           */
hrcimodu    varchar2(10),            /*  资料更改者                           */
hrcidate    date,                    /*  最近修改日                           */
hrciorig    varchar2(10),            /*  资料建立部门                         */
hrcioriu    varchar2(10)             /*  资料建立者                           */
);

alter table hrci_file add  constraint tpc_hrci_pk primary key  (hrci01,hrci02,hrci03) enable validate;
grant select on hrci_file to tiptopgp;
grant update on hrci_file to tiptopgp;
grant delete on hrci_file to tiptopgp;
grant insert on hrci_file to tiptopgp;
grant index on hrci_file to public;
grant select on hrci_file to ods;
