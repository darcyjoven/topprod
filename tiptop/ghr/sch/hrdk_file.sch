/*
================================================================================
檔案代號:hrdk_file
檔案名稱:考勤计算项维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdk_file
(
hrdk01      varchar2(20) NOT NULL,   /*计算项编号                             */
hrdk02      varchar2(20),            /*所属公司ID                             */
hrdk03      varchar2(50),            /*计算项名称                             */
hrdk04      varchar2(20),            /*计税方式                               */
hrdk05      varchar2(20),            /*进位方式                               */
hrdk06      number(5),               /*小数位数                               */
hrdk07      varchar2(1),             /*是否加减项                             */
hrdk08      varchar2(1),             /*是否计入薪资                           */
hrdk09      varchar2(1),             /*是否是福利项                           */
hrdk10      varchar2(20),            /*基金类别                               */
hrdk11      varchar2(1),             /*是否分段                               */
hrdk12      varchar2(20),            /*分段参数                               */
hrdk13      varchar2(20),            /*项目分类                               */
hrdk14      varchar2(4000),          /*参数                                   */
hrdk15      varchar2(4000),          /*公式内容                               */
hrdk16      varchar2(255),           /*结果返回字段                           */
hrdk17      varchar2(4000),          /*公式存储过程                           */
hrdk18      varchar2(255),           /*备注                                   */
hrdkacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdkuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdkgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdkmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdkdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdkoriu    varchar2(10),            /*资料建立者                             */
hrdkorig    varchar2(10),            /*资料建立部门                           */
hrdkud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdkud02    varchar2(40),            /*自订栏位-文字                          */
hrdkud03    varchar2(40),            /*自订栏位-文字                          */
hrdkud04    varchar2(40),            /*自订栏位-文字                          */
hrdkud05    varchar2(40),            /*自订栏位-文字                          */
hrdkud06    varchar2(40),            /*自订栏位-文字                          */
hrdkud07    number(15,3),            /*自订栏位-数值                          */
hrdkud08    number(15,3),            /*自订栏位-数值                          */
hrdkud09    number(15,3),            /*自订栏位-数值                          */
hrdkud10    number(10),              /*自订栏位-整数                          */
hrdkud11    number(10),              /*自订栏位-整数                          */
hrdkud12    number(10),              /*自订栏位-整数                          */
hrdkud13    date,                    /*自订栏位-日期                          */
hrdkud14    date,                    /*自订栏位-日期                          */
hrdkud15    date,                    /*自订栏位-日期                          */
hrdk19      varchar2(20),            /*薪资项首字母缩写                       */
hrdk20      varchar2(1),             /*是否正在编辑公式                       */
hrdk21      varchar2(20),            /*薪资收入分类                           */
hrdk22      varchar2(10)             /*福利项编号                             */
);

alter table hrdk_file add  constraint tpc_hrdk_pk primary key  (hrdk01) enable validate;
grant select on hrdk_file to tiptopgp;
grant update on hrdk_file to tiptopgp;
grant delete on hrdk_file to tiptopgp;
grant insert on hrdk_file to tiptopgp;
grant index on hrdk_file to public;
grant select on hrdk_file to ods;
